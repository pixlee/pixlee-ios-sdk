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

    var formattedPrice: String? {
        guard let currency = currency, let price = price else { return nil }
        return "\(currency) \(price)"
    }
}
