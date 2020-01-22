//
//  PXLProduct.swift
//  pixlee_sdk
//
//  Created by Csaba Toth on 2020. 01. 07..
//  Copyright © 2020. BitRaptors. All rights reserved.
//

import Foundation

struct PXLProduct {
    let identifier: Int
    let linkText: String?
    let link: URL?
    let imageUrl: URL?
    let title: String
    let sku: String
    let productDescription: String
}
