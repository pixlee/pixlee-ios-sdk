//
//  PXLAnalyitcsService.swift
//  Example
//
//  Created by Csaba Toth on 2020. 01. 20..
//  Copyright © 2020. Pixlee. All rights reserved.
//

import Alamofire
import Foundation

public class PXLAnalyitcsService {
    public static var sharedAnalyitcs = PXLAnalyitcsService()

    private var client: PXLClient

    init() {
        client = PXLClient.sharedClient
    }

    public func logEvent(event: PXLAnalyticsEvent, completionHandler: @escaping (Error?) -> Void) -> DataRequest {
        print("⚠️PIXLEE SDK - Logging event:\(event.eventName)")
        return client.logAnalyticsEvent(event: event, completionHandler: completionHandler)
    }
}

public struct PXLAnalyitcsError: Error {
    let reason: String
}
