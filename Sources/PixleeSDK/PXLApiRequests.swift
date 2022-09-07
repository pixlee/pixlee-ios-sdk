//
//  PXLApiRequests.swift
//  pixlee_sdk
//
//  Created by Csaba Toth on 2020. 01. 07..
//  Copyright © 2020. BitRaptors. All rights reserved.
//

import Foundation

class PXLApiRequests {
    private let baseURL: String = "https://distillery.pixlee.com/"
    private let analyticsBaseURL: String = "https://inbound-analytics.pixlee.com/events/"

    var apiKey: String?
    var secretKey: String?
    var disableCaching: Bool = false

    private func defaultGetParameters() -> [String: Any] {
        guard let apiKey = apiKey else {
            assertionFailure("Your Pixlee API key must be set before making API calls.")
            return [:]
        }
        return ["api_key": apiKey]
    }

    private func defaultPostParameters() -> [String: Any] {
        guard let apiKey = apiKey else {
            assertionFailure("Your Pixlee API key must be set before making API calls.")
            return [:]
        }
        return ["API_KEY": apiKey]
    }

    private func postHeaders(isDistilleryServer:Bool, headers: [String: String], parameters: [String: Any]) -> [String: String] {
        var httpHeaders = [String: String]()

        assert(apiKey != nil, "Your Pixlee API Key must be set before making API calls.")

        let newParameters = parameters

        httpHeaders["Content-Type"] = "application/json"
        httpHeaders["Accept"] = "application/json"

        if(isDistilleryServer) {
            assert(secretKey != nil, "Your Pixlee Secret Key must be set before making API calls.")
        }
        
        if let secret = self.secretKey {
            if let parametersData = try? JSONSerialization.data(withJSONObject: newParameters, options: []), let jsonParameters = String(data: parametersData, encoding: String.Encoding.utf8) {
                let cleanedJSON = jsonParameters.replacingOccurrences(of: "\\", with: "")
                let signedParameters = cleanedJSON.hmac(algorithm: .SHA1, key: secret)
                let timestamp = Date().timeIntervalSince1970

                if let hexString = signedParameters.data(using: .bytesHexLiteral)?.base64EncodedString() {
                    httpHeaders["Signature"] = hexString
                    httpHeaders["X-Authorization-Timestamp"] = "\(timestamp)"
                }
            }
        }

        return httpHeaders
    }

    func loadNextAlbumPage(album: PXLAlbum) -> URLRequest {
        guard let albumIdentifier = album.identifier else {
            fatalError("You need to set the album identifier for this request")
        }

        let url = baseURL + "api/v2/albums/\(albumIdentifier)/photos"
        do {
            var params = defaultGetParameters()

            params["per_page"] = album.perPage

            if album.lastPageFetched != NSNotFound {
                params["page"] = album.lastPageFetched + 1
            }

            if let sortOptions = album.sortOptions, let sortParamString = sortOptions.urlParamString {
                params["sort"] = sortParamString
            }
            if let filterOptions = album.filterOptions, let filterParamString = filterOptions.urlParamString {
                params["filters"] = filterParamString
            }
            
            if let regionId = PXLClient.sharedClient.regionId {
                params["region_id"] = regionId
            }
            
            let request = try urlRequest(.get, url, parameters: params)
            
            #if DEBUG
            print("request: \(request)\n")
            #endif
            
            return request
        } catch {
            fatalError("Worng url request")
        }
    }

    func loadNextAlbumPageWithSKU(album: PXLAlbum) -> URLRequest {
        guard let sku = album.sku else {
            fatalError("You need to set the album SKU for this request")
        }

        let url = baseURL + "api/v2/albums/from_sku"
        do {
            var params = defaultGetParameters()
            params["sku"] = sku
            params["per_page"] = album.perPage

            if album.lastPageFetched != NSNotFound {
                params["page"] = album.lastPageFetched + 1
            }

            if let sortOptions = album.sortOptions, let sortParamString = sortOptions.urlParamString {
                params["sort"] = sortParamString
            }
            if let filterOptions = album.filterOptions, let filterParamString = filterOptions.urlParamString {
                params["filters"] = filterParamString
            }
            
            if let regionId = PXLClient.sharedClient.regionId {
                params["region_id"] = regionId
            }

            let request = try urlRequest(.get, url, parameters: params)
            return request
        } catch {
            fatalError("Worng url request")
        }
    }

    func getPhotoWithPhotoAlbumId(_ photoAlbumId: String) -> URLRequest {
        // we no longer use this API since this does not support multi-region
//        let url = baseURL + "api/v2/media/\(photoAlbumId)"
//        do {
//            let params = defaultGetParameters()
//            let request = try urlRequest(.get, url, parameters: params)
//            return request
//        } catch {
//            fatalError("Worng url request")
//        }
        return getPhotoWithPhotoAlbumIdAndRegionId(photoAlbumId: photoAlbumId)
    }
    
    func getPhotoWithPhotoAlbumIdAndRegionId(photoAlbumId: String) -> URLRequest {
        let url = baseURL + "getPhoto"
        do {
            var params = defaultGetParameters()
            params["album_photo_id"] = photoAlbumId
            
            if let regionId = PXLClient.sharedClient.regionId {
                params["region_id"] = regionId
            }
            
            let request = try urlRequest(.get, url, parameters: params)
            return request
        } catch {
            fatalError("Worng url request")
        }
    }

    func postLogAnalyticsEvent(_ event: PXLAnalyticsEvent) -> URLRequest {
        let url = analyticsBaseURL + event.eventName

        do {
            let parameters = defaultPostParameters().reduce(into: event.logParameters) { r, e in r[e.0] = e.1 }
            let postHeaders = self.postHeaders(isDistilleryServer: false, headers: [:], parameters: parameters)
            let request = try urlRequest(.post, url, parameters: parameters, headers: postHeaders)
            
            #if DEBUG
            print("request: \(request)")
            print("parameters: \(parameters)\n")
            #endif
            return request
        } catch {
            fatalError("Worng url request")
        }
    }

    func addMedia(_ newMedia: PXLNewImage, uploadRequest: @escaping (URLSessionTask?) -> Void, completion: @escaping (_ photoId: Int?, _ connectedUserId: Int?, _ error: Error?) -> Void) -> URLRequest? {
        if let apiKey = apiKey {
            let url = baseURL + "api/v2/media/file?api_key=\(apiKey)"
            do {
                if let imageData = newMedia.image.jpegData(compressionQuality: 0.7) {
                    let boundary = generateBoundaryString()
                    let parameters = newMedia.parameters
                    var request = try self.urlRequest(.post, url, headers: self.postHeaders(isDistilleryServer: true, headers: [:], parameters: parameters))
                    
                    // Mark the start of multi part
                    request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
                    
                    var httpBody = NSMutableData()
                    
                    // upload an image
                    httpBody.append(convertFileData(fieldName: "file", fileName: "uploadImage.png", mimeType: "image/png", fileData: imageData, using: boundary))
                    
                    // upload a json data
                    let jsonData = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
                    let jsonString = String(data: jsonData, encoding: .utf8)!
                    httpBody.appendString(convertFormField(named: "json", value: jsonString, using: boundary))
                    
                    // Mark the end of multi part
                    // Add final boundary with the two trailing dashes
                    httpBody.appendString("--\(boundary)--")
                    request.httpBody = httpBody as Data
                    return request
                }
            } catch {
                return nil
            }
        }
        return nil
    }
}

extension PXLApiRequests {
    private func urlRequest(_ method: HTTP.Method,
                            _ urlString: String,
                            parameters: [String: Any]? = nil,
                            headers: [String: String]? = nil)
    throws -> URLRequest {
        var url = URL(string: "")
        switch method {
        case .get:
            var urlComponents = URLComponents(string: urlString)!
            
            // ✅ add uqery
            let queryItemArray = parameters?.map {
                URLQueryItem(name: $0.key, value: String(describing: $0.value ?? ""))
            }
            urlComponents.queryItems = queryItemArray
            
            // add url + params
            url = urlComponents.url
            
        case .post:
            // add url only
            url = URL(string: urlString)
        }
        
        var request = URLRequest(url: url!)
        request.httpMethod = method.rawValue
        
        if method == .post, let parameters = parameters {
            request.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: [])
        }
        
        if let headers = headers {
            for (headerField, headerValue) in headers {
                request.setValue(headerValue, forHTTPHeaderField: headerField)
            }
        }
        
        if disableCaching {
            request.cachePolicy = .reloadIgnoringCacheData
        }
        
        return request
    }

    func convertFormField(named name: String, value: String, using boundary: String) -> String {
        var fieldString = "--\(boundary)\r\n"
        fieldString += "Content-Disposition: form-data; name=\"\(name)\"\r\n"
        fieldString += "\r\n"
        fieldString += "\(value)\r\n"
        
        return fieldString
    }
    
    func convertFileData(fieldName: String, fileName: String, mimeType: String, fileData: Data, using boundary: String) -> Data {
        let data = NSMutableData()
        data.appendString("--\(boundary)\r\n")
        data.appendString("Content-Disposition: form-data; name=\"\(fieldName)\"; filename=\"\(fileName)\"\r\n")
        data.appendString("Content-Type: \(mimeType)\r\n\r\n")
        data.append(fileData)
        data.appendString("\r\n")
        
        return data as Data
    }

    private func generateBoundaryString() -> String {
        return "Boundary-\(UUID().uuidString)"
    }
}

extension NSMutableData {
    func appendString(_ string: String) {
        if let data = string.data(using: .utf8) {
            self.append(data)
        }
    }
}

enum HTTP {
    enum Method: String {
        case get = "GET"
        case post = "POST"
    }
}
