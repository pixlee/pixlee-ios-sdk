//
//  PXLConvertedPhotoAnalyticsEvent.swift
//  Example
//
//  Created by Csaba Toth on 2020. 01. 20..
//  Copyright © 2020. Pixlee. All rights reserved.
//

import UIKit

public struct PXLAnalyitcsCartContents {
    let price: String
    let productSKU: String
    let quantity: Int

    public init(price: String, productSKU: String, quantity: Int) {
        self.price = price
        self.productSKU = productSKU
        self.quantity = quantity
    }

    var dictionaryRepresentation: [String: Any] {
        return ["price": price,
                "product_sku": productSKU,
                "quantity": quantity]
    }
}

public struct PXLAnalyticsEventConvertedPhoto: PXLAnalyticsEvent {
    let cartContents: [PXLAnalyitcsCartContents]
    let cartTotal: Double
    let cartTotalQuantity: Int
    let orderId: Int?
    let currency: String?

    public var eventName = "conversion"

    public init(cartContents: [PXLAnalyitcsCartContents], cartTotal: Double, cartTotalQuantity: Int, orderId: Int? = nil, currency: String? = nil) {
        self.cartContents = cartContents
        self.cartTotal = cartTotal
        self.cartTotalQuantity = cartTotalQuantity
        self.orderId = orderId
        self.currency = currency
    }

    public var logParameters: [String: Any] {
        let udid = UIDevice.current.identifierForVendor?.uuidString ?? "Unknown udid"

        let cartContentsDictArray = cartContents.map({ (cartContent) -> [String: Any] in
            cartContent.dictionaryRepresentation
        })
        var parameters: [String: Any] = ["cart_contents": cartContentsDictArray,
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
