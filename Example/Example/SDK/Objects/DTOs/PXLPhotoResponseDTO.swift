//
//  PXLPhotoResponseDTO.swift
//  Example
//
//  Created by Csaba Toth on 2020. 01. 12..
//  Copyright © 2020. Pixlee. All rights reserved.
//

import Foundation

struct PXLPhotoResponseDTO: Codable {
    let data: PXLPhotoDTO
    let status: String

    enum CodingKeys: String, CodingKey {
        case data, status
    }
}

struct PXLPhotoDTO: Codable {
    let id: Int
    let photoTitle: String?
    let latitude, longitude: Double?
    let taggedAt: Int
    let emailAddress: String?
    let instagramFollowers: Int
    let twitterFollowers: Int?
    let avatarURL: String?
    let userName: String
    let connectedUserID: Int
    let source: String
    let contentType: String
    let dataFileName: String?
    let mediumURL, bigURL, thumbnailURL: String?
    let sourceURL: String
    let mediaID: String?
    let existIn: Int
    let collectTerm: String?
    let albumPhotoID, likeCount, shareCount: Int
    let actionLink, actionLinkText, actionLinkTitle, actionLinkPhoto: String?
    let updatedAt: Int
    let isStarred, approved, archived, isFlagged: Bool
    let albumID, unreadCount: Int
    let collectMethod: String?
    let title: String
    let messaged: Bool?
    let hasPermission, awaitingPermission, socialUserHasLiked: Bool
    let platformLink: String
    let customOrder: JSONNull?
    let hasHeavyPermission, awaitingHeavyPermission: Bool
    let permissionedAt: Int?
    let heavyPermissionedAt, permissionedByUserID: JSONNull?
    let locality, country: String?
    let isScheduled: Bool?
    let scheduler: String?
    let engagementRate: Double?
    let notes: JSONNull?
    let markedAsSpam: Bool
    let uploaderAdditionalFields: PXLUploaderAdditionalFields
    let isInfluencer: Bool
    let submitterLink, altText: String
    let boundingBoxProducts: [BoundingBoxProduct]
    let tagAlbumIDS: [Int]
    let mentions: [String]?
    let nativeLikes, nativeComments, nativeRetweets, nativeFavorites: Int
    let nativeShares, nativeFollowers: Int
    let language: String?
    let deletedAt: Int?
    let connectedUserSocialID: String
    let subtype: JSONNull?
    let narrowDistrict: String?
    let createdAt, approvedOnDate: Int
    let taggedUsernames: [String]
    let resized: Bool?
    let pageID: String
    let products: [PXLProductDTO]
    let pixleeCDNPhotos: PixleeCDNPhotos

    enum CodingKeys: String, CodingKey {
        case id
        case photoTitle = "photo_title"
        case latitude, longitude
        case taggedAt = "tagged_at"
        case emailAddress = "email_address"
        case instagramFollowers = "instagram_followers"
        case twitterFollowers = "twitter_followers"
        case avatarURL = "avatar_url"
        case userName = "user_name"
        case connectedUserID = "connected_user_id"
        case source
        case contentType = "content_type"
        case dataFileName = "data_file_name"
        case mediumURL = "medium_url"
        case bigURL = "big_url"
        case thumbnailURL = "thumbnail_url"
        case sourceURL = "source_url"
        case mediaID = "media_id"
        case existIn = "exist_in"
        case collectTerm = "collect_term"
        case albumPhotoID = "album_photo_id"
        case likeCount = "like_count"
        case shareCount = "share_count"
        case actionLink = "action_link"
        case actionLinkText = "action_link_text"
        case actionLinkTitle = "action_link_title"
        case actionLinkPhoto = "action_link_photo"
        case updatedAt = "updated_at"
        case isStarred = "is_starred"
        case approved, archived
        case isFlagged = "is_flagged"
        case albumID = "album_id"
        case unreadCount = "unread_count"
        case collectMethod = "collect_method"
        case title, messaged
        case hasPermission = "has_permission"
        case awaitingPermission = "awaiting_permission"
        case socialUserHasLiked = "social_user_has_liked"
        case platformLink = "platform_link"
        case customOrder = "custom_order"
        case hasHeavyPermission = "has_heavy_permission"
        case awaitingHeavyPermission = "awaiting_heavy_permission"
        case permissionedAt = "permissioned_at"
        case heavyPermissionedAt = "heavy_permissioned_at"
        case permissionedByUserID = "permissioned_by_user_id"
        case locality, country
        case isScheduled = "is_scheduled"
        case scheduler
        case engagementRate = "engagement_rate"
        case notes
        case markedAsSpam = "marked_as_spam"
        case uploaderAdditionalFields = "uploader_additional_fields"
        case isInfluencer = "is_influencer"
        case submitterLink = "submitter_link"
        case altText = "alt_text"
        case boundingBoxProducts = "bounding_box_products"
        case tagAlbumIDS = "tag_album_ids"
        case mentions
        case nativeLikes = "native_likes"
        case nativeComments = "native_comments"
        case nativeRetweets = "native_retweets"
        case nativeFavorites = "native_favorites"
        case nativeShares = "native_shares"
        case nativeFollowers = "native_followers"
        case language
        case deletedAt = "deleted_at"
        case connectedUserSocialID = "connected_user_social_id"
        case subtype
        case narrowDistrict = "narrow_district"
        case createdAt = "created_at"
        case approvedOnDate = "approved_on_date"
        case taggedUsernames = "tagged_usernames"
        case resized
        case pageID = "page_id"
        case products
        case pixleeCDNPhotos = "pixlee_cdn_photos"
    }
}

// MARK: - PXLUploaderAdditionalInfos

struct PXLUploaderAdditionalFields: Codable {
    let height: String?
    let submissions: Int?
    let name: String?
}

// MARK: - PixleeCDNPhotos

struct PixleeCDNPhotos: Codable {
    let smallURL, mediumURL, largeURL, originalURL: String
    let squareMediumURL, attributedMediumURL: String

    enum CodingKeys: String, CodingKey {
        case smallURL = "small_url"
        case mediumURL = "medium_url"
        case largeURL = "large_url"
        case originalURL = "original_url"
        case squareMediumURL = "square_medium_url"
        case attributedMediumURL = "attributed_medium_url"
    }
}
