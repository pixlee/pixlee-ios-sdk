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
    private let analyitcsBaseURL: String = "https://inbound-analytics.pixlee.com/events/"

    var apiKey: String?
    var secretKey: String?

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

        var newParameters = parameters

        if let apiKey = apiKey {
            newParameters["API_KEY"] = "\(apiKey)"
        }

        httpHeaders["Content-Type"] = "application/json"
        httpHeaders["Accept"] = "application/json"

        assert(secretKey != nil, "Your Pixlee Secret Key must be set before making API calls.")
        if let secret = self.secretKey {
            if let parametersData = try? JSONSerialization.data(withJSONObject: newParameters, options: []), let jsonParameters = String(data: parametersData, encoding: String.Encoding.utf8) {
                let signedParameters = jsonParameters.hmac(algorithm: .SHA1, key: secret)
                let timestamp = Date().timeIntervalSinceNow

                httpHeaders["Signature"] = signedParameters
                httpHeaders["X-Authorization-Timestamp"] = "\(timestamp)"
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

            let request = try PXLApiRequests.urlRequest(.get, url, parameters: params)
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

            let request = try PXLApiRequests.urlRequest(.get, url, parameters: params)
            return request
        } catch {
            fatalError("Worng url request")
        }
    }

    func getPhotoWithPhotoAlbumId(_ photoAlbumId: String) -> URLRequest {
        let url = baseURL + "media/\(photoAlbumId)"
        do {
            let params = defaultGetParameters()
            let request = try PXLApiRequests.urlRequest(.get, url, parameters: params)
            return request
        } catch {
            fatalError("Worng url request")
        }
    }

    func postLogAnalyticsEvent(_ event: PXLAnalyticsEvent) -> URLRequest {
        let url = analyitcsBaseURL + event.eventName
        
        do {
            let parameters = defaultPostParameters().reduce(into: event.logParameters) { (r, e) in r[e.0] = e.1 }
            let postHeaders = self.postHeaders(headers: [:], parameters: parameters)
            let request = try PXLApiRequests.urlRequest(.post, url, parameters: parameters, encoding: JSONEncoding.default, headers: postHeaders)
            return request
        } catch {
            fatalError("Worng url request")
        }
    }
}

extension PXLApiRequests {
    private static func urlRequest(_ method: Alamofire.HTTPMethod,
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

        return mutableURLRequest
    }
}
