//
//  PXLAddToCartAnalyticsEvent.swift
//  Example
//
//  Created by Csaba Toth on 2020. 01. 20..
//  Copyright © 2020. Pixlee. All rights reserved.
//

import UIKit

struct PXLAnalyticsEventAddCart: PXLAnalyticsEvent {
    let sku: String
    let quantity: Int
    let price: String
    let currency: String?

    var eventName = "addToCart"

    var logParameters: [String: Any] {
        let udid = UIDevice.current.identifierForVendor?.uuidString ?? "Unknown udid"

        var parameters: [String: Any] = ["product_sku": sku,
                                         "quantity": quantity,
                                         "price": price,
                                         "platform": "ios",
                                         "uid": udid,
                                         "distinct_user_hash": udid,
                                         "fingerprint": udid]
        if let currency = currency {
            parameters["currency"] = currency
        }

        return parameters
    }
}
