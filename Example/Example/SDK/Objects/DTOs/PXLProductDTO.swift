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
    let id, productAlbumPhotoID, photoID, albumID: Int
    let linkText: String?
    let link: String
    let image: String
    let imageThumb, imageThumbSquare: String
    let title, sku, productDescription: String
    let price: Double?
    let stock: Int?
    let currency: String?
    let category: [Int]?
    let extraUrls: JSONAny?
    let customCtaPhoto: String?
    let linkValid: Bool?
    let totalReviews, averageRating, datcOverride: JSONNull?
    let reviewsInfo: PXLReviewsInfo
    let productRegionLinks: [PXLProductRegionLink]
    let productTaggedAt: Int?

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
        case extraUrls = "extra_urls"
        case customCtaPhoto = "custom_cta_photo"
        case linkValid = "link_valid"
        case totalReviews = "total_reviews"
        case averageRating = "average_rating"
        case datcOverride = "datc_override"
        case reviewsInfo = "reviews_info"
        case productRegionLinks = "product_region_links"
        case productTaggedAt = "product_tagged_at"
    }
}

// MARK: - ProductRegionLink

struct PXLProductRegionLink: Codable {
    let url: String
    let regionName: String
    let regionIsDefault: Bool
    let regionStock: Int

    enum CodingKeys: String, CodingKey {
        case url
        case regionName = "region_name"
        case regionIsDefault = "region_is_default"
        case regionStock = "region_stock"
    }
}
