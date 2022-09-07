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
                self.processPhotoResponse(data, response, error, completionHandler, extractPhotoFromData: {(data: Data) -> PXLPhoto? in
                    let responseDTO = try? JSONDecoder().decode(PXLPhotoResponseDTO.self, from: data)
                    guard let responseDTO = responseDTO else { return nil}
                    return self.photoConverter.convertPhotoDTOToPhoto(dto: responseDTO.data)
                })
            })
        task.resume()
        return task
    }

    public func getPhotoWithPhotoAlbumIdAndRegionId(photoAlbumId: String, completionHandler: ((PXLPhoto?, Error?) -> Void)?) -> URLSessionDataTask {
        var task = URLSession.shared
            .dataTask(with: apiRequests.getPhotoWithPhotoAlbumIdAndRegionId(photoAlbumId: photoAlbumId), completionHandler: { data, response, error in
                self.processPhotoResponse(data, response, error, completionHandler, extractPhotoFromData: {(data: Data) -> PXLPhoto? in
                    let responseDTO = try? JSONDecoder().decode(PXLPhotoDTO.self, from: data)
                    guard let responseDTO = responseDTO else { return nil}
                    return self.photoConverter.convertPhotoDTOToPhoto(dto: responseDTO)
                })
            })
        task.resume()
        return task
    }
    
    private func processPhotoResponse(_ data: Data?, _ response: URLResponse?, _ error: Error?, _ completionHandler: ((PXLPhoto?, Error?) -> Void)?, extractPhotoFromData: (Data) -> PXLPhoto?) {
        if let error = error {
            // failure
            let handledError = self.getErrorFromResponse(responseData: data, error: error)
            print("🛑 PIXLEE SDK Error: \(handledError.errorMessage)")
            DispatchQueue.main.async { completionHandler?(nil, handledError) }
        } else if let data = data {
            // success
            do {
                let photo = extractPhotoFromData(data)
                DispatchQueue.main.async { completionHandler?(photo, nil) }
            } catch {
                DispatchQueue.main.async { completionHandler?(nil, self.getErrorFromResponse(responseData: nil, error: nil)) }
            }
        } else {
            DispatchQueue.main.async { completionHandler?(nil, self.getErrorFromResponse(responseData: nil, error: nil)) }
        }
    }

    public func loadNextPageOfPhotosForAlbum(album: PXLAlbum, completionHandler: (([PXLPhoto]?, Error?) -> Void)?) {
        func fetchPhotos(id: String, nextPage:Int, getRequest: (PXLAlbum) -> URLRequest) {
            var requestsForAlbum = loadingOperations[id]
            if requestsForAlbum == nil {
                requestsForAlbum = [:]
            }
            if var requestsForAlbum = requestsForAlbum, requestsForAlbum[nextPage] == nil {
                print("Loading page \(nextPage)")
                let request = getRequest(album)
                var task = URLSession.shared
                    .dataTask(with: request, completionHandler: { data, response, error in
                        requestsForAlbum[nextPage] = nil
                        self.loadingOperations[id] = nil
                        let (photos, error) = self.handleAlbumResponse(data, response, error, album)
                        DispatchQueue.main.async { completionHandler?(photos, error) }

                        if let photos = photos, let completionHandler = completionHandler {
                            // Analytics: call loadmore if loading the page(2...) is done
                            if self.autoAnalyticsEnabled && nextPage >= 2 {
                                album.triggerEventLoadMoreTapped { error in
                                    
                                }
                            }
                        }
                    })
                task.resume()
                
                requestsForAlbum[nextPage] = request
                loadingOperations[id] = requestsForAlbum
                
            } else {
                DispatchQueue.main.async { completionHandler?(nil, nil) }
            }
        }
        
        if album.hasNextPage {
            debugPrint("album.lastPageFetched == NSNotFound: \(album.lastPageFetched == NSNotFound), page:\(album.lastPageFetched), NSNotFound: \(NSNotFound)")
            let nextPage = album.lastPageFetched == NSNotFound ? 1 : album.lastPageFetched + 1
            if let identifier = album.identifier {
                fetchPhotos(id: identifier, nextPage: nextPage, getRequest: { album in
                    return apiRequests.loadNextAlbumPage(album: album)
                })
            } else if let sku = album.sku {
                fetchPhotos(id: sku, nextPage: nextPage, getRequest: { album in
                    return apiRequests.loadNextAlbumPageWithSKU(album: album)
                })

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
        } else if let data = data {
            do {
                let responseDTO = (try? JSONDecoder().decode(PXLAlbumNextPageResponse.self, from: data))
                guard let responseDTO = responseDTO else {
                    return (nil, getErrorFromResponse(responseData: data, error: nil))
                }
                if album.lastPageFetched == NSNotFound || responseDTO.page > album.lastPageFetched {
                    album.lastPageFetched = responseDTO.page
                }
                album.hasNextPage = responseDTO.next
                
                let newPhotos = photoConverter.convertPhotoDTOsToPhotos(photoDtos: responseDTO.data)
                
                album.photos.append(contentsOf: newPhotos)
                return (newPhotos, nil)
            } catch {
                print("JSON error: \(error.localizedDescription)")
                return (nil, getErrorFromResponse(responseData: nil, error: nil))
            }
        } else {
            return (nil, getErrorFromResponse(responseData: data, error: nil))
        }
    }
    
    public func logAnalyticsEvent(event: PXLAnalyticsEvent, completionHandler: @escaping (Error?) -> Void) -> URLSessionDataTask {
        var task = URLSession.shared
            .dataTask(with: apiRequests.postLogAnalyticsEvent(event), completionHandler: { data, response, error in
                if let error = error {
                    // failure
                    let handledError = self.getErrorFromResponse(responseData: data, error: error)
                    print("🛑 PIXLEE SDK Error: \(handledError.errorMessage)")
                    DispatchQueue.main.async { completionHandler(handledError) }
                } else if let data = data {
                    // success
                    do {
                        let json = try? JSONSerialization.jsonObject(with: data, options:[])
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
                    } catch {
                        DispatchQueue.main.async { completionHandler(PXLAnalyticsError(reason: "Invalid response")) }
                    }
                    
                } else {
                    DispatchQueue.main.async { completionHandler(PXLAnalyticsError(reason: "Invalid response")) }
                }
            })
        task.resume()
        return task
    }

    public func uploadPhoto(photo: PXLNewImage, urlSessionTaskDelegate: URLSessionTaskDelegate? = nil, uploadRequest: @escaping (URLSessionTask?) -> Void, completion: @escaping (_ photoId: Int?, _ connectedUserId: Int?, _ error: Error?) -> Void) -> URLSessionDataTask? {
        guard let request = apiRequests.addMedia(photo, uploadRequest: uploadRequest, completion: completion) else {
            completion(nil, nil, PXLError(code: 1002, message: "Wrong request", externalError: nil))
            return nil
        }
        
        let urlSession = URLSession(configuration: URLSessionConfiguration.default, delegate: urlSessionTaskDelegate, delegateQueue: nil)
        var task = urlSession
            .dataTask(with: request, completionHandler: { data, response, error in
                if let error = error {
                    // failure
                    DispatchQueue.main.async {
                        if let httpResponse = response as? HTTPURLResponse {
                            completion(nil, nil, PXLError(code: httpResponse.statusCode, message: "Unknown error", externalError: error))
                        } else {
                            completion(nil, nil, error)
                        }
                    }
                } else if let data = data {
                    // success
                    do {
                        let json = try? JSONSerialization.jsonObject(with: data, options:[])
                        if let dict = json as? [String: Any], let photoId = dict["album_photo_id"] as? String, let connectedUserId = dict["connected_user_id"] as? String, let photoID = Int(photoId), let connectedUserID = Int(connectedUserId) {
                            completion(photoID, connectedUserID, nil)
                        }
                    } catch {
                        completion(nil, nil, self.getErrorFromResponse(responseData: nil, error: nil))
                    }
                } else {
                    completion(nil, nil, self.getErrorFromResponse(responseData: nil, error: nil))
                }
            })
        
        task.resume()
        return task
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
