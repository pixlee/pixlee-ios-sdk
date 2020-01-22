//
//  PXLProductConverter.swift
//  Example
//
//  Created by Csaba Toth on 2020. 01. 15..
//  Copyright © 2020. Pixlee. All rights reserved.
//

import Foundation

class PXLProductConverter {
    func convertProductDTOtoProduct(dto: PXLProductDTO) ->
        PXLProduct {
        return PXLProduct(identifier: dto.id,
                          linkText: dto.linkText,
                          link: URL(string: dto.link),
                          imageUrl: URL(string: dto.image),
                          title: dto.title,
                          sku: dto.sku,
                          productDescription: dto.productDescription)
    }
}
