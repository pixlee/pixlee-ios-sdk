//
//  PXLTimeBasedProductConverter.swift
//  PixleeSDK
//
//  Created by Sungjun Hong on 3/11/21.
//

import Foundation

class PXLTimeBasedProductConverter {
    func convert(dto: PXLTimeBasedProductDTO) -> PXLTimeBasedProduct {
        return PXLTimeBasedProduct(productId: dto.productId, timestamp: dto.timestamp)
    }
}
