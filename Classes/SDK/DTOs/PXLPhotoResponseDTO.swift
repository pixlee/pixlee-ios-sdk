//
//  PXLPhotoResponseDTO.swift
//  Example
//
//  Created by Csaba Toth on 2020. 01. 12..
//  Copyright © 2020. Pixlee. All rights reserved.
//

import Foundation

struct PXLPhotoResponseDTO: Decodable {
    let data: PXLPhotoDTO
    let status: String

    enum CodingKeys: String, CodingKey {
        case data, status
    }
}

struct PXLPhotoDTO: Decodable {
    let id: Int
    let photoTitle: String?
    let latitude, longitude: Double?
    let taggedAt: Int?
    let emailAddress: String?
    let instagramFollowers: Int?
    let twitterFollowers: Int?
    let avatarURL: String?
    let userName: String?
    let connectedUserID: Int?
    let source: String?
    let contentType: String?
    let dataFileName: String?
    let mediumURL, bigURL, thumbnailURL: String?
    let sourceURL: String?
    let mediaID: String?
    let existIn: Int?
    let collectTerm: String?
    let albumPhotoID: Int
    let likeCount, shareCount, unreadCount: Int
    let actionLink, actionLinkText, actionLinkTitle, actionLinkPhoto: String?
    let updatedAt: Int?
    let isStarred, approved, archived, isFlagged: Bool
    let albumID: Int
    let collectMethod: String?
    let title: String?
    let messaged: Bool?
    let hasPermission, awaitingPermission, socialUserHasLiked: Bool
    let platformLink: String?
    let hasHeavyPermission, awaitingHeavyPermission: Bool
    let permissionedAt: Int?
    let locality, country: String?
    let isScheduled: Bool?
    let scheduler: String?
    let engagementRate: Double?
    let markedAsSpam: Bool?
    let uploaderAdditionalFields: [String: Any]?
    let isInfluencer: Bool?
    let submitterLink, altText: String?
    let boundingBoxProducts: [BoundingBoxProduct]?
    let tagAlbumIDS: [Int]?
    let mentions: [String]?
    let nativeLikes, nativeComments, nativeRetweets, nativeFavorites: Int?
    let nativeShares, nativeFollowers: Int?
    let language: String?
    let deletedAt: Int?
    let connectedUserSocialID: String?
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
        case hasHeavyPermission = "has_heavy_permission"
        case awaitingHeavyPermission = "awaiting_heavy_permission"
        case permissionedAt = "permissioned_at"
        case locality, country
        case isScheduled = "is_scheduled"
        case scheduler
        case engagementRate = "engagement_rate"
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
        case narrowDistrict = "narrow_district"
        case createdAt = "created_at"
        case approvedOnDate = "approved_on_date"
        case taggedUsernames = "tagged_usernames"
        case resized
        case pageID = "page_id"
        case products
        case pixleeCDNPhotos = "pixlee_cdn_photos"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = (try? values.decode(Int.self, forKey: .id)) ?? 0
        photoTitle = (try? values.decode(String.self, forKey: .photoTitle)) ?? ""
        latitude = (try? values.decode(Double.self, forKey: .latitude))
        longitude = (try? values.decode(Double.self, forKey: .longitude))
        taggedAt = (try? values.decode(Int.self, forKey: .taggedAt))
        emailAddress = (try? values.decode(String.self, forKey: .emailAddress))
        instagramFollowers = (try? values.decode(Int.self, forKey: .instagramFollowers))
        twitterFollowers = (try? values.decode(Int.self, forKey: .twitterFollowers))
        avatarURL = (try? values.decode(String.self, forKey: .avatarURL))
        userName = (try? values.decode(String.self, forKey: .userName))
        connectedUserID = (try? values.decode(Int.self, forKey: .connectedUserID))
        source = (try? values.decode(String.self, forKey: .source))
        contentType = (try? values.decode(String.self, forKey: .contentType))
        dataFileName = (try? values.decode(String.self, forKey: .dataFileName))
        mediumURL = (try? values.decode(String.self, forKey: .mediumURL))
        bigURL = (try? values.decode(String.self, forKey: .bigURL))
        thumbnailURL = (try? values.decode(String.self, forKey: .thumbnailURL))
        sourceURL = (try? values.decode(String.self, forKey: .sourceURL))
        mediaID = (try? values.decode(String.self, forKey: .mediaID))
        existIn = (try? values.decode(Int.self, forKey: .existIn))
        collectTerm = (try? values.decode(String.self, forKey: .collectTerm))
        albumPhotoID = (try? values.decode(Int.self, forKey: .albumPhotoID)) ?? 0
        likeCount = (try? values.decode(Int.self, forKey: .likeCount)) ?? 0
        shareCount = (try? values.decode(Int.self, forKey: .shareCount)) ?? 0
        unreadCount = (try? values.decode(Int.self, forKey: .unreadCount)) ?? 0
        actionLink = (try? values.decode(String.self, forKey: .actionLink)) ?? ""
        actionLinkText = (try? values.decode(String.self, forKey: .actionLinkText)) ?? ""
        actionLinkTitle = (try? values.decode(String.self, forKey: .actionLinkTitle)) ?? ""
        actionLinkPhoto = (try? values.decode(String.self, forKey: .actionLinkPhoto)) ?? ""
        updatedAt = (try? values.decode(Int.self, forKey: .updatedAt))
        isStarred = (try? values.decode(Bool.self, forKey: .isStarred)) ?? false
        approved = (try? values.decode(Bool.self, forKey: .approved)) ?? false
        archived = (try? values.decode(Bool.self, forKey: .archived)) ?? false
        isFlagged = (try? values.decode(Bool.self, forKey: .isFlagged)) ?? false
        albumID = (try? values.decode(Int.self, forKey: .albumID)) ?? 0
        collectMethod = (try? values.decode(String.self, forKey: .collectMethod))
        title = (try? values.decode(String.self, forKey: .title))
        messaged = (try? values.decode(Bool.self, forKey: .messaged))
        hasPermission = (try? values.decode(Bool.self, forKey: .hasPermission)) ?? false
        awaitingPermission = (try? values.decode(Bool.self, forKey: .awaitingPermission)) ?? false
        socialUserHasLiked = (try? values.decode(Bool.self, forKey: .socialUserHasLiked)) ?? false
        platformLink = (try? values.decode(String.self, forKey: .platformLink))
        hasHeavyPermission = (try? values.decode(Bool.self, forKey: .hasHeavyPermission)) ?? false
        awaitingHeavyPermission = (try? values.decode(Bool.self, forKey: .awaitingHeavyPermission)) ?? false
        permissionedAt = (try? values.decode(Int.self, forKey: .permissionedAt))
        locality = (try? values.decode(String.self, forKey: .locality))
        country = (try? values.decode(String.self, forKey: .country))
        isScheduled = (try? values.decode(Bool.self, forKey: .isScheduled))
        scheduler = (try? values.decode(String.self, forKey: .scheduler))
        engagementRate = (try? values.decode(Double.self, forKey: .engagementRate))
        markedAsSpam = (try? values.decode(Bool.self, forKey: .markedAsSpam))
        uploaderAdditionalFields = (try? values.decode([String: Any].self, forKey: .uploaderAdditionalFields))
        isInfluencer = (try? values.decode(Bool.self, forKey: .isInfluencer))
        submitterLink = (try? values.decode(String.self, forKey: .submitterLink))
        altText = (try? values.decode(String.self, forKey: .altText))
        boundingBoxProducts = (try? values.decode([BoundingBoxProduct].self, forKey: .boundingBoxProducts))
        tagAlbumIDS = (try? values.decode([Int].self, forKey: .tagAlbumIDS))
        mentions = (try? values.decode([String].self, forKey: .mentions))
        nativeLikes = (try? values.decode(Int.self, forKey: .nativeLikes))
        nativeComments = (try? values.decode(Int.self, forKey: .nativeComments))
        nativeRetweets = (try? values.decode(Int.self, forKey: .nativeRetweets))
        nativeFavorites = (try? values.decode(Int.self, forKey: .nativeFavorites))
        nativeShares = (try? values.decode(Int.self, forKey: .nativeShares))
        nativeFollowers = (try? values.decode(Int.self, forKey: .nativeFollowers))
        language = (try? values.decode(String.self, forKey: .language))
        deletedAt = (try? values.decode(Int.self, forKey: .deletedAt))
        connectedUserSocialID = (try? values.decode(String.self, forKey: .connectedUserSocialID))
        narrowDistrict = (try? values.decode(String.self, forKey: .narrowDistrict))
        createdAt = (try? values.decode(Int.self, forKey: .createdAt)) ?? 0
        approvedOnDate = (try? values.decode(Int.self, forKey: .approvedOnDate)) ?? 0
        taggedUsernames = (try? values.decode([String].self, forKey: .taggedUsernames)) ?? []
        resized = (try? values.decode(Bool.self, forKey: .resized))
        pageID = (try? values.decode(String.self, forKey: .pageID)) ?? ""
        products = (try? values.decode([PXLProductDTO].self, forKey: .products)) ?? []
        pixleeCDNPhotos = (try? values.decode(PixleeCDNPhotos.self, forKey: .pixleeCDNPhotos)) ?? PixleeCDNPhotos(smallURL: "", mediumURL: "", largeURL: "", originalURL: "", squareMediumURL: "", attributedMediumURL: "")
    }

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

// MARK: - JSONCodingKeys for [String: Any] <- Dynamic JSON variable
// reference: https://stackoverflow.com/questions/44603248/how-to-decode-a-property-with-type-of-json-dictionary-in-swift-45-decodable-pr/46049763#46049763
struct JSONCodingKeys: CodingKey {
    var stringValue: String

    init?(stringValue: String) {
        self.stringValue = stringValue
    }

    var intValue: Int?

    init?(intValue: Int) {
        self.init(stringValue: "\(intValue)")
        self.intValue = intValue
    }
}

// MARK: - KeyedDecodingContainer for [String: Any] <- Dynamic JSON variable
extension KeyedDecodingContainer {

    func decode(_ type: Dictionary<String, Any>.Type, forKey key: K) throws -> Dictionary<String, Any> {
        let container = try self.nestedContainer(keyedBy: JSONCodingKeys.self, forKey: key)
        return try container.decode(type)
    }

    func decodeIfPresent(_ type: Dictionary<String, Any>.Type, forKey key: K) throws -> Dictionary<String, Any>? {
        guard contains(key) else {
            return nil
        }
        guard try decodeNil(forKey: key) == false else {
            return nil
        }
        return try decode(type, forKey: key)
    }

    func decode(_ type: Array<Any>.Type, forKey key: K) throws -> Array<Any> {
        var container = try self.nestedUnkeyedContainer(forKey: key)
        return try container.decode(type)
    }

    func decodeIfPresent(_ type: Array<Any>.Type, forKey key: K) throws -> Array<Any>? {
        guard contains(key) else {
            return nil
        }
        guard try decodeNil(forKey: key) == false else {
            return nil
        }
        return try decode(type, forKey: key)
    }

    func decode(_ type: Dictionary<String, Any>.Type) throws -> Dictionary<String, Any> {
        var dictionary = Dictionary<String, Any>()

        for key in allKeys {
            if let boolValue = try? decode(Bool.self, forKey: key) {
                dictionary[key.stringValue] = boolValue
            } else if let stringValue = try? decode(String.self, forKey: key) {
                dictionary[key.stringValue] = stringValue
            } else if let intValue = try? decode(Int.self, forKey: key) {
                dictionary[key.stringValue] = intValue
            } else if let doubleValue = try? decode(Double.self, forKey: key) {
                dictionary[key.stringValue] = doubleValue
            } else if let nestedDictionary = try? decode(Dictionary<String, Any>.self, forKey: key) {
                dictionary[key.stringValue] = nestedDictionary
            } else if let nestedArray = try? decode(Array<Any>.self, forKey: key) {
                dictionary[key.stringValue] = nestedArray
            }
        }
        return dictionary
    }
}

// MARK: - UnkeyedDecodingContainer for [String: Any] <- Dynamic JSON variable
extension UnkeyedDecodingContainer {

    mutating func decode(_ type: Array<Any>.Type) throws -> Array<Any> {
        var array: [Any] = []
        while isAtEnd == false {
            // See if the current value in the JSON array is `null` first and prevent infite recursion with nested arrays.
            if try decodeNil() {
                continue
            } else if let value = try? decode(Bool.self) {
                array.append(value)
            } else if let value = try? decode(Double.self) {
                array.append(value)
            } else if let value = try? decode(String.self) {
                array.append(value)
            } else if let nestedDictionary = try? decode(Dictionary<String, Any>.self) {
                array.append(nestedDictionary)
            } else if let nestedArray = try? decode(Array<Any>.self) {
                array.append(nestedArray)
            }
        }
        return array
    }

    mutating func decode(_ type: Dictionary<String, Any>.Type) throws -> Dictionary<String, Any> {

        let nestedContainer = try self.nestedContainer(keyedBy: JSONCodingKeys.self)
        return try nestedContainer.decode(type)
    }
}
