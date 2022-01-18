//
//  PXLPhoto.swift
//  pixlee_sdk
//
//  Created by Csaba Toth on 2020. 01. 07..
//  Copyright © 2020. BitRaptors. All rights reserved.
//

import Alamofire
import Foundation
import MapKit

public enum PXLPhotoSize {
    case thumbnail
    case medium
    case big
    case original
}

public struct PXLPhoto: Equatable {
    public static func == (lhs: PXLPhoto, rhs: PXLPhoto) -> Bool {
        lhs.id == rhs.id
    }

    public let id: Int
    public let photoTitle: String?
    public let latitude: Double?
    public let longitude: Double?
    public let taggedAt: Date?
    public let emailAddress: String?
    public let instagramFollowers: Int?
    public let twitterFollowers: Int?
    public let avatarUrl: URL?
    public let username: String?
    public let connectedUserId: Int?
    public let source: String?
    public let contentType: String?
    public let dataFileName: String?
    public let mediumUrl: URL?
    public let bigUrl: URL?
    public let thumbnailUrl: URL?
    public let sourceUrl: URL?
    public let mediaId: String?
    public let existIn: Int?
    public let collectTerm: String?
    public let albumPhotoId: Int
    public let albumId: Int
    public let likeCount: Int?
    public let shareCount: Int?
    public let actionLink: URL?
    public let actionLinkText: String?
    public let actionLinkTitle: String?
    public let actionLinkPhoto: String?
    public let updatedAt: Date?
    public let isStarred: Bool?
    public let approved: Bool
    public let archived: Bool?
    public let isFlagged: Bool?
    public let unreadCount: Int?
    public let albumActionLink: URL?
    public let title: String?
    public let messaged: Bool?
    public let hasPermission: Bool?
    public let awaitingPermission: Bool?
    public let instUserHasLiked: Bool?
    public let platformLink: URL?
    public let products: [PXLProduct]?
    public let cdnSmallUrl: URL?
    public let cdnMediumUrl: URL?
    public let cdnLargeUrl: URL?
    public let cdnOriginalUrl: URL?
    public let cdnSquareMediumUrl: URL?
    public let uploaderAdditionalFields: [String: Any]?
    public let boundingBoxProducts: [BoundingBoxProduct]?

    public var coordinate: CLLocationCoordinate2D? {
        guard let latitude = self.latitude, let longitude = self.longitude else { return nil }
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }

    public func photoUrl(for size: PXLPhotoSize) -> URL? {
        if contentType == "video" {
            return getResizedPhotoUrl(for: size)
        }

        if approved {
            return getCDNPhotoUrl(for: size)
        } else {
            return getResizedPhotoUrl(for: size)
        }
    }

    public var isVideo: Bool {
        return contentType == "video"
    }

    public func videoUrl() -> URL? {
        if contentType == "video" {
            return sourceUrl
        }
        return nil
    }

    func getResizedPhotoUrl(for size: PXLPhotoSize) -> URL? {
        switch size {
        case .thumbnail:
            return thumbnailUrl
        case .medium:
            return mediumUrl
        case .big:
            return bigUrl
        case .original:
            return sourceUrl
        }
    }

    func getCDNPhotoUrl(for size: PXLPhotoSize) -> URL? {
        switch size {
        case .thumbnail:
            return cdnSmallUrl
        case .medium:
            return cdnMediumUrl
        case .big:
            return cdnLargeUrl
        case .original:
            return cdnOriginalUrl
        }
    }

    public var sourceIconImage: UIImage? {
        // test it in Cocoapods
        #if SWIFT_PACKAGE
        let bundle = Bundle.module
        #else
        let bundle = Bundle(for: PXLAlbum.self)
        #endif
        switch source {
        case "instagram":
            return UIImage(named: "instagram", in: bundle, compatibleWith: nil)
        case "facebook":
            return UIImage(named: "facebook", in: bundle, compatibleWith: nil)
        case "pinterest":
            return UIImage(named: "pinterest", in: bundle, compatibleWith: nil)
        case "tumblr":
            return UIImage(named: "tumblr", in: bundle, compatibleWith: nil)
        case "twitter":
            return UIImage(named: "twitter", in: bundle, compatibleWith: nil)
        case "vine":
            return UIImage(named: "vine", in: bundle, compatibleWith: nil)
        default:
            return nil
        }
    }

    public func triggerEventActionClicked(actionLink: String, completionHandler: @escaping (Error?) -> Void) -> DataRequest {
        return PXLAnalyticsService.sharedAnalytics.logEvent(event: PXLAnalyticsEventActionClicked(photo: self, actionLink: actionLink), completionHandler: completionHandler)
    }

    public func triggerEventOpenedLightbox(completionHandler: @escaping (Error?) -> Void) -> DataRequest {
        return PXLAnalyticsService.sharedAnalytics.logEvent(event: PXLAnalyticsEventOpenedLightBox(photo: self), completionHandler: completionHandler)
    }
}
