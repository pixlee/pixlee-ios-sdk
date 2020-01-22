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

enum PXLPhotoSize {
    case thumbnail
    case medium
    case big
}

struct PXLPhoto {
    let id: Int
    let photoTitle: String?
    let latitude: Double?
    let longitude: Double?
    let taggedAt: Date?
    let emailAddress: String?
    let instagramFollowers: Int?
    let twitterFollowers: Int?
    let avatarUrl: URL?
    let username: String
    let connectedUserId: Int
    let source: String
    let contentType: String
    let dataFileName: String?
    let mediumUrl: URL?
    let bigUrl: URL?
    let thumbnailUrl: URL?
    let sourceUrl: URL?
    let mediaId: String?
    let existIn: Int?
    let collectTerm: String?
    let albumPhotoId: Int
    let albumId: Int
    let likeCount: Int?
    let shareCount: Int?
    let actionLink: URL?
    let actionLinkText: String?
    let actionLinkTitle: String?
    let actionLinkPhoto: String?
    let updatedAt: Date?
    let isStarred: Bool?
    let approved: Bool
    let archived: Bool?
    let isFlagged: Bool?
    let unreadCount: Int?
    let albumActionLink: URL?
    let title: String?
    let messaged: Bool?
    let hasPermission: Bool?
    let awaitingPermission: Bool?
    let instUserHasLiked: Bool?
    let platformLink: URL?
    let products: [PXLProduct]?
    let cdnSmallUrl: URL?
    let cdnMediumUrl: URL?
    let cdnLargeUrl: URL?
    let cdnOriginalUrl: URL?

    var coordinate: CLLocationCoordinate2D? {
        guard let latitude = self.latitude, let longitude = self.longitude else { return nil }
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }

    func photoUrl(for size: PXLPhotoSize) -> URL? {
        if contentType == "video" {
            return getResizedPhotoUrl(for: size)
        }

        if approved {
            return getCDNPhotoUrl(for: size)
        } else {
            return getResizedPhotoUrl(for: size)
        }
    }

    func getResizedPhotoUrl(for size: PXLPhotoSize) -> URL? {
        switch size {
        case .thumbnail:
            return thumbnailUrl
        case .medium:
            return mediumUrl
        case .big:
            return bigUrl
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
        }
    }

    var sourceIconImage: UIImage? {
        switch source {
        case "instagram":
            return UIImage(named: "instagram", in: Bundle(identifier: "Pixlee.pixlee-sdk"), with: nil)
        case "facebook":
            return UIImage(named: "facebook", in: Bundle(identifier: "Pixlee.pixlee-sdk"), with: nil)
        case "pinterest":
            return UIImage(named: "pinterest", in: Bundle(identifier: "Pixlee.pixlee-sdk"), with: nil)
        case "tumblr":
            return UIImage(named: "tumblr", in: Bundle(identifier: "Pixlee.pixlee-sdk"), with: nil)
        case "twitter":
            return UIImage(named: "twitter", in: Bundle(identifier: "Pixlee.pixlee-sdk"), with: nil)
        case "vine":
            return UIImage(named: "vine", in: Bundle(identifier: "Pixlee.pixlee-sdk"), with: nil)
        default:
            return nil
        }
    }
}
