//
//  PXLProductDTO.swift
//  Example
//
//  Created by Csaba Toth on 2020. 01. 12..
//  Copyright © 2020. Pixlee. All rights reserved.
//

import Foundation

// MARK: - Product

struct PXLProductDTO: Codable {
    let id: Int
    let productAlbumPhotoID: Int
    let photoID: Int
    let albumID: Int
    let linkText: String?
    let link: String?
    let image: String?
    let imageThumb, imageThumbSquare: String?
    let title, sku, productDescription: String?
    let price: Double?
    let stock: Int?
    let currency: String?
    let category: [Int]?
    let customCtaPhoto: String?
    let linkValid: Bool?
    let reviewsInfo: PXLReviewsInfo?
    let productRegionLinks: [PXLProductRegionLink]?
    let productTaggedAt: Int?
    let salesPrice: Double?
    let salesStartDate: Int?
    let salesEndDate: Int?

    enum CodingKeys: String, CodingKey {
        case id
        case productAlbumPhotoID = "product_album_photo_id"
        case photoID = "photo_id"
        case albumID = "album_id"
        case linkText = "link_text"
        case link, image
        case imageThumb = "image_thumb"
        case imageThumbSquare = "image_thumb_square"
        case title, sku
        case productDescription = "description"
        case price, stock, currency, category
        case customCtaPhoto = "custom_cta_photo"
        case linkValid = "link_valid"
        case reviewsInfo = "reviews_info"
        case productRegionLinks = "product_region_links"
        case productTaggedAt = "product_tagged_at"
        case salesPrice = "sales_price"
        case salesStartDate = "sales_start_date"
        case salesEndDate = "sales_end_date"
    }
}

// MARK: - ProductRegionLink

struct PXLProductRegionLink: Codable {
    let url: String?
    let regionName: String?
    let regionIsDefault: Bool?
    let regionStock: Int?

    enum CodingKeys: String, CodingKey {
        case url
        case regionName = "region_name"
        case regionIsDefault = "region_is_default"
        case regionStock = "region_stock"
    }
}
