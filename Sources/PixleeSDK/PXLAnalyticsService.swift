//
//  PXLAnalyticsService.swift
//  Example
//
//  Created by Csaba Toth on 2020. 01. 20..
//  Copyright © 2020. Pixlee. All rights reserved.
//

import Foundation

public class PXLAnalyticsService {
    public static let TAG = "PXLAnalyticsService"
    public static var sharedAnalytics = PXLAnalyticsService()
    private var client: PXLClient

    init() {
        client = PXLClient.sharedClient
    }

    public func logEvent(event: PXLAnalyticsEvent, completionHandler: @escaping (Error?) -> Void) {
        NotificationCenter.default.post(name:NSNotification.Name(rawValue: PXLAnalyticsService.TAG), object:event.eventName)
        print("⚠️PIXLEE SDK - Logging event:\(event.eventName)")
        client.logAnalyticsEvent(event: event, completionHandler: completionHandler)
    }
}

public struct PXLAnalyticsError: Error {
    let reason: String
}
