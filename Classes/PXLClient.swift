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
        return Alamofire.request(apiRequests.getPhotoWithPhotoAlbumId(photoAlbumId)).responseData { resultData in
            if let data = resultData.data {
                do {
                    let decoder = JSONDecoder()
                    let resultDTO = try decoder.decode(PXLPhotoResponseDTO.self, from: data)
                    let photo = self.photoConverter.convertPhotoDTOToPhoto(dto: resultDTO.data)
                    completionHandler?(photo, nil)
                } catch let error {
                    let handledError = self.getErrorFromResponse(responseData: data, error: error)
                    print("🛑 PIXLEE SDK Error: \(handledError.errorMessage)")
                    completionHandler?(nil, handledError)
                }
            } else {
                let handledError = self.getErrorFromResponse(responseData: nil, error: nil)
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
                    let request = Alamofire.request(apiRequests.loadNextAlbumPage(album: album)).responseData { resultData in
                        if let data = resultData.data {
                            do {
                                let decoder = JSONDecoder()
                                let resultDTO = try decoder.decode(PXLAlbumNextPageResponse.self, from: data)
                                let (photos, error) = self.handleAlbumResponse(resultDTO, album: album)
                                if let photos = photos, let completionHandler = completionHandler {
                                    print("Page\(nextPage) loaded allPhotos: \(album.photos.count)")
                                    completionHandler(photos, nil)
                                } else if let error = error, let completionHandler = completionHandler {
                                    print("🛑 PIXLEE SDK Error: \(error.errorMessage)")
                                    completionHandler(nil, error)
                                }
                            } catch let error {
                                let handledError = self.getErrorFromResponse(responseData: data, error: error)
                                print("🛑 PIXLEE SDK Error: \(handledError.errorMessage)")
                                completionHandler?(nil, handledError)
                            }
                        } else {
                            let handledError = self.getErrorFromResponse(responseData: nil, error: nil)
                            print("🛑 PIXLEE SDK Error: \(handledError.errorMessage)")
                            completionHandler?(nil, handledError)
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
                    let request = Alamofire.request(apiRequests.loadNextAlbumPageWithSKU(album: album)).responseData { resultData in
                        if let data = resultData.data {
                            do {
                                let decoder = JSONDecoder()
                                let resultDTO = try decoder.decode(PXLAlbumNextPageResponse.self, from: data)
                                let (photos, error) = self.handleAlbumResponse(resultDTO, album: album)
                                if let photos = photos, let completionHandler = completionHandler {
                                    print("Page\(nextPage) loaded allPhotos: \(album.photos.count)")
                                    completionHandler(photos, nil)
                                } else if let error = error, let completionHandler = completionHandler {
                                    print("🛑 PIXLEE SDK Error: \(error.errorMessage)")
                                    completionHandler(nil, error)
                                }
                            } catch let error {
                                let handledError = self.getErrorFromResponse(responseData: data, error: error)
                                print("🛑 PIXLEE SDK Error: \(handledError.errorMessage)")
                                completionHandler?(nil, handledError)
                            }
                        } else {
                            let handledError = self.getErrorFromResponse(responseData: nil, error: nil)
                            print("🛑 PIXLEE SDK Error: \(handledError.errorMessage)")
                            completionHandler?(nil, handledError)
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

    private func handleAlbumResponse(_ responseDTO: PXLAlbumNextPageResponse, album: PXLAlbum) -> (newPhotos: [PXLPhoto]?, error: PXLError?) {
        if album.lastPageFetched == NSNotFound || responseDTO.page > album.lastPageFetched {
            album.lastPageFetched = responseDTO.page
        }
        album.hasNextPage = responseDTO.next

        let newPhotos = photoConverter.convertPhotoDTOsToPhotos(photoDtos: responseDTO.data)

        album.photos.append(contentsOf: newPhotos)

        return (newPhotos, nil)
    }

    public func logAnalyticsEvent(event: PXLAnalyticsEvent, completionHandler: @escaping (Error?) -> Void) -> DataRequest {
        return Alamofire.request(apiRequests.postLogAnalyticsEvent(event)).responseJSON { response in
            if let error = response.error {
                let handledError = self.getErrorFromResponse(responseData: response.data, error: error)
                print("🛑 PIXLEE SDK Error: \(handledError.errorMessage)")
                completionHandler(handledError)

            } else if let jsonDict = response.result.value as? [String: Any], let status = jsonDict["status"] as? String, status == "OK" {
                completionHandler(nil)
            } else if let jsonDict = response.result.value as? [String: Any], let error = jsonDict["error"] as? String {
                completionHandler(PXLAnalyticsError(reason: error))
            } else {
                completionHandler(PXLAnalyticsError(reason: "Invalid response"))
            }
        }
    }

    public func uploadPhoto(photo: PXLNewImage, progress: @escaping (Double) -> Void, uploadRequest: @escaping (UploadRequest?) -> Void, completion: @escaping (_ photoId: Int?, _ connectedUserId: Int?, _ error: Error?) -> Void) {
        return apiRequests.addMedia(photo, progress: progress, uploadRequest: uploadRequest, completion: completion)
    }

    func getErrorFromResponse(responseData: Data?, error: Error?) -> PXLError {
        if let data = responseData {
            let decoder = JSONDecoder()
            do {
                let errorDto = try decoder.decode(PXLErrorDTO.self, from: data)
                return PXLError(code: errorDto.status, message: errorDto.message, externalError: nil)
            } catch {
                do {
                    let errorDto = try decoder.decode(PXLPlainErrorDTO.self, from: data)
                    if let status = errorDto.status, let statusCode = Int(status) {
                        return PXLError(code: statusCode, message: errorDto.error, externalError: nil)
                    }
                    return PXLError(code: 1001, message: errorDto.error, externalError: nil)
                } catch {
                    do {
                        let errorDto = try decoder.decode(String.self, from: data)
                        return PXLError(code: 1002, message: errorDto, externalError: nil)
                    } catch {
                        if let serializationError = error as? AFError {
                            return PXLError(code: 502, message: "Response serialization error", externalError: serializationError)
                        }

                        return PXLError(code: 1000, message: "Unknown error", externalError: error)
                    }
                }
            }
        }

        return PXLError(code: 502, message: "Invalid response error", externalError: error)
    }
}
