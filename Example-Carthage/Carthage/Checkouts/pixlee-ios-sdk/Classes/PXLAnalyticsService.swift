//
//  PXLAnalyticsService.swift
//  Example
//
//  Created by Csaba Toth on 2020. 01. 20..
//  Copyright © 2020. Pixlee. All rights reserved.
//

import Alamofire
import Foundation

public class PXLAnalyticsService {
    public static var sharedAnalytics = PXLAnalyticsService()

    private var client: PXLClient

    init() {
        client = PXLClient.sharedClient
    }

    public func logEvent(event: PXLAnalyticsEvent, completionHandler: @escaping (Error?) -> Void) -> DataRequest {
        print("⚠️PIXLEE SDK - Logging event:\(event.eventName)")
        return client.logAnalyticsEvent(event: event, completionHandler: completionHandler)
    }
}

public struct PXLAnalyticsError: Error {
    let reason: String
}
