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
        var link: URL?
        if let dtoLink = dto.link {
            link = URL(string: dtoLink)
        }
        var imageURL: URL?
        if let imageUrl = dto.image {
            imageURL = URL(string: imageUrl)
        }
        var imageThumbURL: URL?
        if let imageThumbUrl = dto.imageThumb {
            imageThumbURL = URL(string: imageThumbUrl)
        }
        var imageThumbSquareURL: URL?
        if let imageThumbSquareUrl = dto.imageThumb {
            imageThumbSquareURL = URL(string: imageThumbSquareUrl)
        }

        return PXLProduct(identifier: dto.id,
                          linkText: dto.linkText,
                          link: link,
                          imageUrl: imageURL,
                          imageThumbUrl: imageThumbURL,
                          imageThumbSquareUrl: imageThumbSquareURL,
                          title: dto.title,
                          sku: dto.sku,
                          productDescription: dto.productDescription)
    }
}
