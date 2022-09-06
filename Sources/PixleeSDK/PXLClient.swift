//
//  PXLClient.swift
//  pixlee_sdk
//
//  Created by Csaba Toth on 2020. 01. 07..
//  Copyright © 2020. BitRaptors. All rights reserved.
//

import Foundation
import Nuke

public class PXLClient {
    public init() {
        ImagePipeline.Configuration.isAnimatedImageDataEnabled = true
    }
    public static var sharedClient = PXLClient()

    private let apiRequests = PXLApiRequests()

    private let photoConverter = PXLPhotoConverter(productConverter: PXLProductConverter())
    private var loadingOperations: [String: [Int: URLRequest?]] = [:]

    // globally used with in the SDK
    public var apiKey: String? {
        didSet {
            apiRequests.apiKey = apiKey
        }
    }

    // globally used with in the SDK
    public var secretKey: String? {
        didSet {
            apiRequests.secretKey = secretKey
        }
    }

    // globally used with in the SDK
    public var disableCaching: Bool = true {
        didSet {
            apiRequests.disableCaching = disableCaching
        }
    }
    
    // globally used with in the SDK
    public var autoAnalyticsEnabled: Bool = false
    
    // globally used with in the SDK
    public var regionId: Int? = nil
    

    public func getPhotoWithPhotoAlbumId(photoAlbumId: String, completionHandler: ((PXLPhoto?, Error?) -> Void)?) -> URLSessionDataTask {
        var task = URLSession.shared
            .dataTask(with: apiRequests.getPhotoWithPhotoAlbumId(photoAlbumId), completionHandler: { data, response, error in
                if let error = error {
                    // failure
                    let handledError = self.getErrorFromResponse(responseData: data, error: error)
                    print("🛑 PIXLEE SDK Error: \(handledError.errorMessage)")
                    DispatchQueue.main.async { completionHandler?(nil, handledError) }
                } else {
                    // success
                    let jsonRes = try? JSONSerialization.jsonObject(with: data!, options:[])
                    print("response json is: \(jsonRes)")
                    
                    let responseDTO = try? JSONDecoder().decode(PXLPhotoResponseDTO.self, from: data!)
                    let photo = self.photoConverter.convertPhotoDTOToPhoto(dto: responseDTO!.data)
                    DispatchQueue.main.async { completionHandler?(photo, nil) }
                    
                }
            })
        task.resume()
        return task
    }

    public func getPhotoWithPhotoAlbumIdAndRegionId(photoAlbumId: String, completionHandler: ((PXLPhoto?, Error?) -> Void)?) -> URLSessionDataTask {
        var task = URLSession.shared
            .dataTask(with: apiRequests.getPhotoWithPhotoAlbumIdAndRegionId(photoAlbumId: photoAlbumId), completionHandler: { data, response, error in
                if let error = error {
                    // failure
                    let handledError = self.getErrorFromResponse(responseData: data, error: error)
                    print("🛑 PIXLEE SDK Error: \(handledError.errorMessage)")
                    DispatchQueue.main.async { completionHandler?(nil, handledError) }
                    
                } else {
                    // success
                    let jsonRes = try? JSONSerialization.jsonObject(with: data!, options:[])
                    print("response json is: \(jsonRes)")
                    
                    let responseDTO = try? JSONDecoder().decode(PXLPhotoDTO.self, from: data!)
                    let photo = self.photoConverter.convertPhotoDTOToPhoto(dto: responseDTO!)
                    DispatchQueue.main.async { completionHandler?(photo, nil) }
                    
                }
            })
        task.resume()
        return task
    }

    
    public func loadNextPageOfPhotosForAlbum(album: PXLAlbum, completionHandler: (([PXLPhoto]?, Error?) -> Void)?) {
        if album.hasNextPage {
            debugPrint("album.lastPageFetched == NSNotFound: \(album.lastPageFetched == NSNotFound), page:\(album.lastPageFetched), NSNotFound: \(NSNotFound)")
            let nextPage = album.lastPageFetched == NSNotFound ? 1 : album.lastPageFetched + 1
            if let identifier = album.identifier {
                var requestsForAlbum = loadingOperations[identifier]
                if requestsForAlbum == nil {
                    requestsForAlbum = [:]
                }
                if var requestsForAlbum = requestsForAlbum, requestsForAlbum[nextPage] == nil {
                    print("Loading page \(nextPage)")
                    let request = apiRequests.loadNextAlbumPage(album: album)
                    var task = URLSession.shared
                        .dataTask(with: request, completionHandler: { data, response, error in
                            requestsForAlbum[nextPage] = nil
                            self.loadingOperations[identifier] = nil
                            let (photos, error) = self.handleAlbumResponse(data, response, error, album)
                            if let photos = photos, let completionHandler = completionHandler {
                                DispatchQueue.main.async { completionHandler(photos, nil) }
                                
                                // Analytics: call loadmore if loading the page(2...) is done
                                if self.autoAnalyticsEnabled && nextPage >= 2 {
                                    album.triggerEventLoadMoreTapped { error in

                                    }
                                }

                            } else if let error = error, let completionHandler = completionHandler {
                                print("🛑 PIXLEE SDK Error: \(error.errorMessage)")
                                DispatchQueue.main.async { completionHandler(nil, error) }
                                
                            }
                        })
                    task.resume()
                    
                    requestsForAlbum[nextPage] = request
                    loadingOperations[identifier] = requestsForAlbum
                    
                } else {
                    DispatchQueue.main.async {
                        completionHandler?(nil, nil)
                    }
                    
                }
            } else if let sku = album.sku {
                var requestsForAlbum = loadingOperations[sku]
                if requestsForAlbum == nil {
                    requestsForAlbum = [:]
                }
                if var requestsForAlbum = requestsForAlbum, requestsForAlbum[nextPage] == nil {
                    print("Loading page \(nextPage)")
                    
                    let request = apiRequests.loadNextAlbumPageWithSKU(album: album)
                    var task = URLSession.shared
                        .dataTask(with: request, completionHandler: { data, response, error in
                            requestsForAlbum[nextPage] = nil
                            self.loadingOperations[sku] = nil
                            let (photos, error) = self.handleAlbumResponse(data, response, error, album)
                            if let photos = photos, let completionHandler = completionHandler {
                                DispatchQueue.main.async { completionHandler(photos, nil) }
                                
                                // Analytics: call loadmore if loading the page(2...) is done
                                if self.autoAnalyticsEnabled && nextPage >= 2 {
                                    album.triggerEventLoadMoreTapped { error in
                                        
                                    }
                                }
                                
                            } else if let error = error, let completionHandler = completionHandler {
                                print("🛑 PIXLEE SDK Error: \(error.errorMessage)")
                                DispatchQueue.main.async { completionHandler(nil, error) }
                            }
                        })
                    task.resume()
                    
                    requestsForAlbum[nextPage] = request
                    loadingOperations[sku] = requestsForAlbum
                } else {
                    DispatchQueue.main.async { completionHandler?(nil, nil) }
                }
            } else {
                DispatchQueue.main.async { completionHandler?(nil, nil) }
            }
        } else {
            DispatchQueue.main.async { completionHandler?(nil, nil) }
        }
    }

    private func handleAlbumResponse(_ data: Data?, _ response: URLResponse?, _ error: Error?, _ album: PXLAlbum) -> (newPhotos: [PXLPhoto]?, error: PXLError?) {
        if let error = error {
            let handledError = getErrorFromResponse(responseData: data, error: error)
            print("🛑 PIXLEE SDK Error: \(handledError.errorMessage)")
            return (nil, handledError)
        } else {
            let responseDTO = (try? JSONDecoder().decode(PXLAlbumNextPageResponse.self, from: data!))!
            if album.lastPageFetched == NSNotFound || responseDTO.page > album.lastPageFetched {
                album.lastPageFetched = responseDTO.page
            }
            album.hasNextPage = responseDTO.next
            
            let newPhotos = photoConverter.convertPhotoDTOsToPhotos(photoDtos: responseDTO.data)
            
            album.photos.append(contentsOf: newPhotos)
            return (newPhotos, nil)
            
        }
    }
    public func logAnalyticsEvent(event: PXLAnalyticsEvent, completionHandler: @escaping (Error?) -> Void) -> URLSessionDataTask {
        var task = URLSession.shared
            .dataTask(with: apiRequests.postLogAnalyticsEvent(event), completionHandler: { data, response, error in
                if let error = error {
                    // failure
                    let handledError = self.getErrorFromResponse(responseData: data, error: error)
                    print("🛑 PIXLEE SDK Error: \(handledError.errorMessage)")
                    DispatchQueue.main.async {
                        completionHandler(handledError)
                    }
                } else {
                    // success
                    let json = try? JSONSerialization.jsonObject(with: data!, options:[])
                    print("response json is: \(json)")
                    
                    DispatchQueue.main.async {
                        if let jsonDict = json as? [String: Any], let status = jsonDict["status"] as? String, status == "OK" {
                            completionHandler(nil)
                        } else if let jsonDict = json as? [String: Any], let error = jsonDict["error"] as? String {
                            completionHandler(PXLAnalyticsError(reason: error))
                        } else {
                            completionHandler(PXLAnalyticsError(reason: "Invalid response"))
                        }
                    }
                }
            })
        task.resume()
        return task
    }

    public func uploadPhoto(photo: PXLNewImage, urlSessionTaskDelegate: URLSessionTaskDelegate? = nil, uploadRequest: @escaping (URLSessionTask?) -> Void, completion: @escaping (_ photoId: Int?, _ connectedUserId: Int?, _ error: Error?) -> Void) {
        return apiRequests.addMedia(photo, urlSessionTaskDelegate: urlSessionTaskDelegate, uploadRequest: uploadRequest, completion: completion)
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
//                        if let serializationError = error as? AFError {
                        if let serializationError = error as? Error {
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
