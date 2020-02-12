//
//  PXLClient.swift
//  pixlee_sdk
//
//  Created by Csaba Toth on 2020. 01. 07..
//  Copyright © 2020. BitRaptors. All rights reserved.
//

import Alamofire
import Foundation

public class PXLClient {
    public static var sharedClient = PXLClient()

    private let apiRequests = PXLApiRequests()

    private let photoConverter = PXLPhotoConverter(productConverter: PXLProductConverter())
    private var loadingOperations: [String: [Int: DataRequest?]] = [:]

    public var apiKey: String? {
        didSet {
            apiRequests.apiKey = apiKey
        }
    }

    public var secretKey: String? {
        didSet {
            apiRequests.secretKey = secretKey
        }
    }

    public var disableCaching: Bool = true {
        didSet {
            apiRequests.disableCaching = disableCaching
        }
    }

    public func getPhotoWithPhotoAlbumId(photoAlbumId: String, completionHandler: ((PXLPhoto?, Error?) -> Void)?) -> DataRequest {
        return AF.request(apiRequests.getPhotoWithPhotoAlbumId(photoAlbumId)).responseDecodable { (response: DataResponse<PXLPhotoResponseDTO, AFError>) in

//            if let data = response.data, let responseJSONString = String(data: data, encoding: .utf8) {
//                print("responseJson: \(responseJSONString)")
//            }

            switch response.result {
            case let .success(responseDTO):
                let photo = self.photoConverter.convertPhotoDTOToPhoto(dto: responseDTO.data)
                completionHandler?(photo, nil)

            case let .failure(error):
                let handledError = self.getErrorFromResponse(responseData: response.data, error: error)
                print("🛑 PIXLEE SDK Error: \(handledError.errorMessage)")
                completionHandler?(nil, handledError)
            }
        }
    }

    public func loadNextPageOfPhotosForAlbum(album: PXLAlbum, completionHandler: (([PXLPhoto]?, Error?) -> Void)?) -> DataRequest? {
        if album.hasNextPage {
            let nextPage = album.lastPageFetched == NSNotFound ? 1 : album.lastPageFetched + 1
            if let identifier = album.identifier {
                var requestsForAlbum = loadingOperations[identifier]
                if requestsForAlbum == nil {
                    requestsForAlbum = [:]
                }
                if var requestsForAlbum = requestsForAlbum, requestsForAlbum[nextPage] == nil {
                    print("Loading page \(nextPage)")
                    let request = AF.request(apiRequests.loadNextAlbumPage(album: album)).responseDecodable { (response: DataResponse<PXLAlbumNextPageResponse, AFError>) in

                        let (photos, error) = self.handleAlbumResponse(response, album: album)

                        if let photos = photos, let completionHandler = completionHandler {
                            print("Page\(nextPage) loaded allPhotos: \(album.photos.count)")
                            completionHandler(photos, nil)
                        } else if let error = error, let completionHandler = completionHandler {
                            print("🛑 PIXLEE SDK Error: \(error.errorMessage)")
                            completionHandler(nil, error)
                        }
                    }
                    requestsForAlbum[nextPage] = request
                    loadingOperations[identifier] = requestsForAlbum
                    return request
                } else {
                    completionHandler?(nil, nil)
                    return nil
                }
            } else if let sku = album.identifier {
                var requestsForAlbum = loadingOperations[sku]
                if requestsForAlbum == nil {
                    requestsForAlbum = [:]
                }
                if var requestsForAlbum = requestsForAlbum, requestsForAlbum[nextPage] == nil {
                    print("Loading page \(nextPage)")
                    let request = AF.request(apiRequests.loadNextAlbumPageWithSKU(album: album)).responseDecodable { (response: DataResponse<PXLAlbumNextPageResponse, AFError>) in

                        let (photos, error) = self.handleAlbumResponse(response, album: album)

                        if let photos = photos, let completionHandler = completionHandler {
                            print("Page\(nextPage) loaded allPhotos: \(album.photos.count)")
                            completionHandler(photos, nil)
                        } else if let error = error, let completionHandler = completionHandler {
                            print("🛑 PIXLEE SDK Error: \(error.errorMessage)")
                            completionHandler(nil, error)
                        }
                    }
                    requestsForAlbum[nextPage] = request
                    loadingOperations[sku] = requestsForAlbum
                    return request
                } else {
                    completionHandler?(nil, nil)
                    return nil
                }
            } else {
                completionHandler?(nil, nil)
                return nil
            }
        } else {
            completionHandler?(nil, nil)
            return nil
        }
    }

    private func handleAlbumResponse(_ response: DataResponse<PXLAlbumNextPageResponse, AFError>, album: PXLAlbum) -> (newPhotos: [PXLPhoto]?, error: PXLError?) {
        switch response.result {
        case let .success(responseDTO):
            if album.lastPageFetched == NSNotFound || responseDTO.page > album.lastPageFetched {
                album.lastPageFetched = responseDTO.page
            }
            album.hasNextPage = responseDTO.next

            let newPhotos = photoConverter.convertPhotoDTOsToPhotos(photoDtos: responseDTO.data)

            album.photos.append(contentsOf: newPhotos)

            return (newPhotos, nil)
        case let .failure(error):
            let handledError = getErrorFromResponse(responseData: response.data, error: error)
            print("🛑 PIXLEE SDK Error: \(handledError.errorMessage)")
            return (nil, handledError)
        }
    }

    public func logAnalyticsEvent(event: PXLAnalyticsEvent, completionHandler: @escaping (Error?) -> Void) -> DataRequest {
        return AF.request(apiRequests.postLogAnalyticsEvent(event)).responseJSON { response in
            switch response.result {
            case let .success(json):
                if let jsonDict = json as? [String: Any], let status = jsonDict["status"] as? String, status == "OK" {
                    completionHandler(nil)
                } else if let jsonDict = json as? [String: Any], let error = jsonDict["error"] as? String {
                    completionHandler(PXLAnalyticsError(reason: error))
                } else {
                    completionHandler(PXLAnalyticsError(reason: "Invalid response"))
                }
                break
            case let .failure(error):
                let handledError = self.getErrorFromResponse(responseData: response.data, error: error)
                print("🛑 PIXLEE SDK Error: \(handledError.errorMessage)")
                completionHandler(handledError)
                break
            }
        }
    }

    func getErrorFromResponse(responseData: Data?, error: Error?) -> PXLError {
        if let data = responseData {
            let decoder = JSONDecoder()
            do {
                let errorDto = try decoder.decode(PXLErrorDTO.self, from: data)
                return PXLError(code: errorDto.status, message: errorDto.message, externalError: nil)
            } catch {
                if let serializationError = error as? AFError {
                    return PXLError(code: 502, message: "Response serialization error", externalError: serializationError)
                }

                return PXLError(code: 1000, message: "Unknown error", externalError: error)
            }
        }

        return PXLError(code: 502, message: "Invalid response error", externalError: error)
    }
}
