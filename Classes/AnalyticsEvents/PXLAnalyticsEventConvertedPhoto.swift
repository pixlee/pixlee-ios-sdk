//
//  PXLConvertedPhotoAnalyticsEvent.swift
//  Example
//
//  Created by Csaba Toth on 2020. 01. 20..
//  Copyright © 2020. Pixlee. All rights reserved.
//

import UIKit

public struct PXLAnalyticsEventConvertedPhoto: PXLAnalyticsEvent {
    let cartContents: [Int]
    let cartTotal: Int
    let cartTotalQuantity: Int
    let orderId: Int?
    let currency: String?

    public var eventName = "conversion"

    public init(cartContents: [Int], cartTotal: Int, cartTotalQuantity: Int, orderId: Int? = nil, currency: String? = nil) {
        self.cartContents = cartContents
        self.cartTotal = cartTotal
        self.cartTotalQuantity = cartTotalQuantity
        self.orderId = orderId
        self.currency = currency
    }

    public var logParameters: [String: Any] {
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
