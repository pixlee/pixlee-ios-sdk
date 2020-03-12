//
//  PXLApiRequests.swift
//  pixlee_sdk
//
//  Created by Csaba Toth on 2020. 01. 07..
//  Copyright © 2020. BitRaptors. All rights reserved.
//

import Alamofire
import Foundation

class PXLApiRequests {
    private let baseURL: String = "https://distillery.pixlee.com/api/v2/"
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

    private func postHeaders(headers: [String: String], parameters: [String: Any]) -> [String: String] {
        var httpHeaders = [String: String]()

        assert(apiKey != nil, "Your Pixlee API Key must be set before making API calls.")

        let newParameters = parameters

        httpHeaders["Content-Type"] = "application/json"
        httpHeaders["Accept"] = "application/json"

        assert(secretKey != nil, "Your Pixlee Secret Key must be set before making API calls.")
        if let secret = self.secretKey {
            if let parametersData = try? JSONSerialization.data(withJSONObject: newParameters, options: []), let jsonParameters = String(data: parametersData, encoding: String.Encoding.utf8) {
                let cleanedJSON = jsonParameters.replacingOccurrences(of: "\\", with: "")
                let signedParameters = cleanedJSON.hmac(algorithm: .SHA1, key: secret)
                let timestamp = Date().timeIntervalSince1970

                if let hexString = signedParameters.data(using: .bytesHexLiteral)?.base64EncodedString(){
                    print(hexString)
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

        let url = baseURL + "albums/\(albumIdentifier)/photos"
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

            let request = try urlRequest(.get, url, parameters: params)
            return request
        } catch {
            fatalError("Worng url request")
        }
    }

    func loadNextAlbumPageWithSKU(album: PXLAlbum) -> URLRequest {
        guard let sku = album.sku else {
            fatalError("You need to set the album SKU for this request")
        }

        let url = baseURL + "albums/from_sku"
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

            let request = try urlRequest(.get, url, parameters: params)
            return request
        } catch {
            fatalError("Worng url request")
        }
    }

    func getPhotoWithPhotoAlbumId(_ photoAlbumId: String) -> URLRequest {
        let url = baseURL + "media/\(photoAlbumId)"
        do {
            let params = defaultGetParameters()
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
//            let postHeaders = self.postHeaders(headers: [:], parameters: parameters)
            let request = try urlRequest(.post, url, parameters: parameters, encoding: JSONEncoding.default)
            return request
        } catch {
            fatalError("Worng url request")
        }
    }

    func addMedia(_ newMedia: PXLNewImage) {
        if let apiKey = apiKey {
            let url = baseURL + "media/file?api_key=\(apiKey)"

            do {
                let parameters = newMedia.parameters
                let jsonData = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)

                let jsonString = String(data: jsonData, encoding: .utf8)!

                let postHeaders = self.postHeaders(headers: [:], parameters: parameters)

                var url = url
                url = url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!

                print("Url: \(url), \n headers: \(postHeaders), jsonString:\(jsonString)")

                if let imageData = newMedia.image.jpegData(compressionQuality: 0.7) {
                    Alamofire.upload(multipartFormData: { multipartFormData in
                        multipartFormData.append(imageData, withName: "file", fileName: "uploadImage.png", mimeType: "image/png")
                        multipartFormData.append(jsonString.data(using: String.Encoding.utf8)!, withName: "json")
                    }, usingThreshold: UInt64(), to: url, method: .post, headers: postHeaders) { result in
                        switch result {
                        case .success(let upload, _, _):
                            print("the status code is :")

                            upload.uploadProgress(closure: { _ in
                                print("something")
                            })

                            upload.responseJSON { response in
                                print("the resopnse code is : \(response.response?.statusCode)")
                                print("the response is : \(response)")
                            }
                            break
                        case let .failure(encodingError):
                            print("the error is  : \(encodingError.localizedDescription)")
                            break
                        }
                    }
                }
                return
            } catch {
                fatalError("Worng url request")
            }
        }
    }
}

extension PXLApiRequests {
    private func urlRequest(_ method: Alamofire.HTTPMethod,
                            _ url: URLConvertible,
                            parameters: [String: Any]? = nil,
                            encoding: ParameterEncoding = URLEncoding.default,
                            headers: [String: String]? = nil)
        throws -> Foundation.URLRequest {
        var mutableURLRequest = Foundation.URLRequest(url: try url.asURL())
        mutableURLRequest.httpMethod = method.rawValue

        if let headers = headers {
            for (headerField, headerValue) in headers {
                mutableURLRequest.setValue(headerValue, forHTTPHeaderField: headerField)
            }
        }

        if let parameters = parameters {
            mutableURLRequest = try encoding.encode(mutableURLRequest, with: parameters)
        }

        if disableCaching {
            mutableURLRequest.cachePolicy = .reloadIgnoringCacheData
        }

        return mutableURLRequest
    }
}

extension String {
    /// Expanded encoding
    ///
    /// - bytesHexLiteral: Hex string of bytes
    /// - base64: Base64 string
    enum ExpandedEncoding {
        /// Hex string of bytes
        case bytesHexLiteral
        /// Base64 string
        case base64
    }

    /// Convert to `Data` with expanded encoding
    ///
    /// - Parameter encoding: Expanded encoding
    /// - Returns: data
    func data(using encoding: ExpandedEncoding) -> Data? {
        switch encoding {
        case .bytesHexLiteral:
            guard count % 2 == 0 else { return nil }
            var data = Data()
            var byteLiteral = ""
            for (index, character) in enumerated() {
                if index % 2 == 0 {
                    byteLiteral = String(character)
                } else {
                    byteLiteral.append(character)
                    guard let byte = UInt8(byteLiteral, radix: 16) else { return nil }
                    data.append(byte)
                }
            }
            return data
        case .base64:
            return Data(base64Encoded: self)
        }
    }
}
