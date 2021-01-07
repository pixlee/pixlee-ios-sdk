//
//  PXLAddToCartAnalyticsEvent.swift
//  Example
//
//  Created by Csaba Toth on 2020. 01. 20..
//  Copyright © 2020. Pixlee. All rights reserved.
//

import UIKit

public struct PXLAnalyticsEventAddCart: PXLAnalyticsEvent {
    let sku: String
    let quantity: Int
    let price: String
    let currency: String?
    let regionId: Int?

    public var eventName = "addToCart"

    public init(sku: String, quantity: Int, price: String, currency: String? = nil, regionId: Int?) {
        self.sku = sku
        self.quantity = quantity
        self.price = price
        self.currency = currency
        self.regionId = regionId
    }

    public var logParameters: [String: Any] {
        let udid = UIDevice.current.identifierForVendor?.uuidString ?? "Unknown udid"

        var parameters: [String: Any] = ["product_sku": sku,
                                         "quantity": quantity,
                                         "price": price,
                                         "platform": "ios",
                                         "uid": udid,
                                         "fingerprint": udid]
        if let currency = currency {
            parameters["currency"] = currency
        }
        
        if let regionId = regionId {
            parameters["region_id"] = regionId
        }

        return parameters
    }
}
