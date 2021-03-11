//
//  PXLTimeBasedProductDTO.swift
//  PixleeSDK
//
//  Created by Sungjun Hong on 3/11/21.
//

import Foundation
struct PXLTimeBasedProductDTO: Codable {
    let productId: Int
    let timestamp: Int
        
    enum CodingKeys: String, CodingKey {
        case productId = "product_id"
        case timestamp
    }
}
