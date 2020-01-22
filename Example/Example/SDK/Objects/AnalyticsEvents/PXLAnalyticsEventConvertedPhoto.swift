//
//  PXLConvertedPhotoAnalyticsEvent.swift
//  Example
//
//  Created by Csaba Toth on 2020. 01. 20..
//  Copyright © 2020. Pixlee. All rights reserved.
//

import UIKit

struct PXLAnalyticsEventConvertedPhoto: PXLAnalyticsEvent {
    let cartContents: [Int]
    let cartTotal: Int
    let cartTotalQuantity: Int
    let orderId: Int?
    let currency: String?

    var eventName = "conversion"

    var logParameters: [String: Any] {
        let udid = UIDevice.current.identifierForVendor?.uuidString ?? "Unknown udid"

        var parameters: [String: Any] = ["cart_contents": cartContents,
                                         "cart_total_quantity": cartTotalQuantity,
                                         "cart_total": cartTotal,
                                         "platform": "ios",
                                         "uid": udid]
        if let orderId = orderId {
            parameters["order_id"] = orderId
        }

        if let currency = currency {
            parameters["currency"] = currency
        }

        return parameters
    }
}
