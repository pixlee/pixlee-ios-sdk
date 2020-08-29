//
//  PXLProduct.swift
//  pixlee_sdk
//
//  Created by Csaba Toth on 2020. 01. 07..
//  Copyright © 2020. BitRaptors. All rights reserved.
//

import Foundation

public struct PXLProduct {
    public let identifier: Int
    public let linkText: String?
    public let link: URL?
    public let imageUrl: URL?
    public let imageThumbUrl: URL?
    public let imageThumbSquareUrl: URL?
    public let title: String?
    public let sku: String?
    public let productDescription: String?
    public let price: Double?
    public let currency: String?

    static var currencyFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "en_US")
        return formatter
    }()

    var formattedPrice: String? {
        guard let price = price else { return nil }
        return PXLProduct.currencyFormatter.string(from: NSNumber(value: price))
    }
}
