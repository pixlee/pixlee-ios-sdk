//
//  PXLAnalyitcsService.swift
//  Example
//
//  Created by Csaba Toth on 2020. 01. 20..
//  Copyright © 2020. Pixlee. All rights reserved.
//

import Alamofire
import Foundation

class PXLAnalyitcsService {
    static var sharedAnalyitcs = PXLAnalyitcsService()

    private var client: PXLClient

    init() {
        client = PXLClient.sharedClient
    }

    func logEvent(event: PXLAnalyticsEvent, completionHandler: @escaping (Error?) -> Void) -> DataRequest {
        print("⚠️PIXLEE SDK - Logging event:\(event.eventName)")
        return client.logAnalyticsEvent(event: event, completionHandler: completionHandler)
    }
}

struct PXLAnalyitcsError: Error {
    let reason: String
}
