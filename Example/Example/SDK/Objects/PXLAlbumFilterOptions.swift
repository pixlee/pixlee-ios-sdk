//
//  PXLAlbumFilterOptions.swift
//  pixlee_sdk
//
//  Created by Csaba Toth on 2020. 01. 07..
//  Copyright © 2020. BitRaptors. All rights reserved.
//

import Foundation

struct PXLAlbumFilterOptions: Codable {
    let minInstagramFollowers: Int?
    let minTwitterFollowers: Int?
    let contentSource: [String]?
    let contentType: [String]?
    let inCategories: [Int]?
    let filterBySubcaption: String?
    let filterByUserhandle: [String: String]?
    let submittedDateStart: Date?
    let submittedDateEnd: Date?
    let computerVision: [String: String]?
    let filterByLocation: [String: String]?
    let filterByRadius: String?

    var deniedPhotos: Bool = false {
        didSet {
            flagDeniedPhotos = true
        }
    }

    var starredPhotos: Bool = false {
        didSet {
            flagStarredPhotos = true
        }
    }

    var deletedPhotos: Bool = false {
        didSet {
            flagDeletedPhotos = true
        }
    }

    var flaggedPhotos: Bool = false {
        didSet {
            flagFlaggedPhotos = true
        }
    }

    var hasPermission: Bool = false {
        didSet {
            flagHasPermission = true
        }
    }

    var hasProduct: Bool = false {
        didSet {
            flagHasPermission = true
        }
    }

    var inStockOnly: Bool = false {
        didSet {
            flagInStockOnly = true
        }
    }

    var hasActionLink: Bool = false {
        didSet {
            flagHasActionLink = true
        }
    }

    var flagDeniedPhotos: Bool?
    var flagStarredPhotos: Bool?
    var flagDeletedPhotos: Bool?
    var flagFlaggedPhotos: Bool?
    var flagHasPermission: Bool?
    var flagHasProduct: Bool?
    var flagInStockOnly: Bool?
    var flagHasActionLink: Bool?

    var urlParamString: String? {
        var options = [String: Any]()
        if let minInstagramFollowers = minInstagramFollowers {
            options["min_instagram_followers"] = minInstagramFollowers
        }

        if let minTwitterFollowers = minTwitterFollowers {
            options["min_twitter_followers"] = minTwitterFollowers
        }

        if let flagDeniedPhotos = flagDeniedPhotos, flagDeniedPhotos {
            options["denied_photos"] = deniedPhotos
        }

        if let flagStarredPhotos = flagStarredPhotos, flagStarredPhotos {
            options["starred_photos"] = starredPhotos
        }

        if let flagDeletedPhotos = flagDeletedPhotos, flagDeletedPhotos {
            options["deleted_photos"] = deletedPhotos
        }

        if let flagFlaggedPhotos = flagFlaggedPhotos, flagFlaggedPhotos {
            options["flagged_photos"] = flaggedPhotos
        }

        if let flagHasPermission = flagHasPermission, flagHasPermission {
            options["has_permission"] = hasPermission
        }

        if let flagHasProduct = flagHasProduct, flagHasProduct {
            options["has_product"] = hasProduct
        }

        if let flagInStockOnly = flagInStockOnly, flagInStockOnly {
            options["has_product"] = inStockOnly
        }

        if let flagHasActionLink = flagHasActionLink, flagHasActionLink {
            options["has_action_link"] = hasActionLink
        }

        if let contentSource = contentSource {
            options["content_source"] = contentSource
        }

        if let contentType = self.contentType {
            options["content_type"] = contentType
        }

        if let filterBySubcaption = self.filterBySubcaption {
            options["filter_by_subcaption"] = filterBySubcaption
        }

        if let submittedDateStart = submittedDateStart {
            options["submitted_date_start"] = submittedDateStart.timeIntervalSince1970
        }

        if let submittedDateEnd = submittedDateEnd {
            options["submitted_date_end"] = submittedDateEnd.timeIntervalSince1970
        }

        if let inCategories = inCategories {
            options["in_categories"] = inCategories
        }

        if let computerVision = computerVision {
            options["computer_vision"] = computerVision
        }
        if let filterByLocation = filterByLocation {
            options["filter_by_location"] = filterByLocation
        }
        if let filterByUserhandle = filterByUserhandle {
            options["filter_by_userhandle"] = filterByUserhandle
        }
        if let filterByRadius = filterByRadius {
            options["filter_by_radius"] = filterByRadius
        }

        do {
            let jsonData = try JSONSerialization.data(withJSONObject: options, options: JSONSerialization.WritingOptions.prettyPrinted)

            if let JSONString = String(data: jsonData, encoding: String.Encoding.utf8) {
                return JSONString
            }
        } catch {
            print("PixleeSDK Error during the serialization of the sort options: \(error)")
        }
        return nil
    }
}
