//
//  PXLAlbumNexPageResponseDTO.swift
//  Example
//
//  Created by Csaba Toth on 2020. 01. 11..
//  Copyright © 2020. Pixlee. All rights reserved.
//
import Foundation

// MARK: - PXLAlbumNextPageResponse

struct PXLAlbumNextPageResponse: Codable {
    let accountID, albumID, page, perPage: Int
    let total: Int
    let next: Bool
    let data: [PXLPhotoDTO]
    let message: String
    let status: Int
    let sortType: String

    enum CodingKeys: String, CodingKey {
        case accountID = "account_id"
        case albumID = "album_id"
        case page
        case perPage = "per_page"
        case total, next, data, message, status, sortType
    }
}

// MARK: - BoundingBoxProduct

struct BoundingBoxProduct: Codable {
    let x, y, width, height: Int
    let aspectRatio, productID: Int

    enum CodingKeys: String, CodingKey {
        case x, y, width, height
        case aspectRatio = "aspect_ratio"
        case productID = "product_id"
    }
}

// MARK: - ReviewsInfo

struct PXLReviewsInfo: Codable {
    let numReviews, averageRating: Int
    let reviews: [PXLReview]

    enum CodingKeys: String, CodingKey {
        case numReviews = "num_reviews"
        case averageRating = "average_rating"
        case reviews
    }
}

struct PXLReview: Codable {
    let id: Int
    let title: String
    let content: String
    let score: Int
    let votesUp: Int
    let votesDown: Int
    let verifiedBuyer: Bool
    let userName: String

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case content
        case score
        case votesUp = "votes_up"
        case votesDown = "votes_down"
        case verifiedBuyer = "verified_buyer"
        case userName = "user_name"
    }
}
