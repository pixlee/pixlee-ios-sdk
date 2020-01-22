//
//  PXLAlbumFilterOptions.swift
//  pixlee_sdk
//
//  Created by Csaba Toth on 2020. 01. 07..
//  Copyright © 2020. BitRaptors. All rights reserved.
//

import Foundation

public struct PXLAlbumFilterOptions: Codable {
    public let minInstagramFollowers: Int?
    public let minTwitterFollowers: Int?
    public let contentSource: [String]?
    public let contentType: [String]?
    public let inCategories: [Int]?
    public let filterBySubcaption: String?
    public let filterByUserhandle: [String: String]?
    public let submittedDateStart: Date?
    public let submittedDateEnd: Date?
    public let computerVision: [String: String]?
    public let filterByLocation: [String: String]?
    public let filterByRadius: String?

    public var deniedPhotos: Bool = false {
        didSet {
            flagDeniedPhotos = true
        }
    }

    public var starredPhotos: Bool = false {
        didSet {
            flagStarredPhotos = true
        }
    }

    public var deletedPhotos: Bool = false {
        didSet {
            flagDeletedPhotos = true
        }
    }

    public var flaggedPhotos: Bool = false {
        didSet {
            flagFlaggedPhotos = true
        }
    }

    public var hasPermission: Bool = false {
        didSet {
            flagHasPermission = true
        }
    }

    public var hasProduct: Bool = false {
        didSet {
            flagHasPermission = true
        }
    }

    public var inStockOnly: Bool = false {
        didSet {
            flagInStockOnly = true
        }
    }

    public var hasActionLink: Bool = false {
        didSet {
            flagHasActionLink = true
        }
    }

    public var flagDeniedPhotos: Bool?
    public var flagStarredPhotos: Bool?
    public var flagDeletedPhotos: Bool?
    public var flagFlaggedPhotos: Bool?
    public var flagHasPermission: Bool?
    public var flagHasProduct: Bool?
    public var flagInStockOnly: Bool?
    public var flagHasActionLink: Bool?

    public init(minInstagramFollowers: Int? = nil,
                minTwitterFollowers: Int? = nil,
                contentSource: [String]? = nil,
                contentType: [String]? = nil,
                inCategories: [Int]? = nil,
                filterBySubcaption: String? = nil,
                filterByUserhandle: [String: String]? = nil,
                submittedDateStart: Date? = nil,
                submittedDateEnd: Date? = nil,
                computerVision: [String: String]? = nil,
                filterByLocation: [String: String]? = nil,
                filterByRadius: String? = nil,
                deniedPhotos: Bool = false,
                starredPhotos: Bool = false,
                deletedPhotos: Bool = false,
                flaggedPhotos: Bool = false,
                hasPermission: Bool = false,
                hasProduct: Bool = false,
                inStockOnly: Bool = false,
                hasActionLink: Bool = false,
                flagDeniedPhotos: Bool? = nil,
                flagStarredPhotos: Bool? = nil,
                flagDeletedPhotos: Bool? = nil,
                flagFlaggedPhotos: Bool? = nil,
                flagHasPermission: Bool? = nil,
                flagHasProduct: Bool? = nil,
                flagInStockOnly: Bool? = nil,
                flagHasActionLink: Bool? = nil) {
        self.minInstagramFollowers = minInstagramFollowers
        self.minTwitterFollowers = minTwitterFollowers
        self.contentSource = contentSource
        self.contentType = contentType
        self.inCategories = inCategories
        self.filterBySubcaption = filterBySubcaption
        self.filterByUserhandle = filterByUserhandle
        self.submittedDateStart = submittedDateStart
        self.submittedDateEnd = submittedDateEnd
        self.computerVision = computerVision
        self.filterByLocation = filterByLocation
        self.filterByRadius = filterByRadius
        self.deniedPhotos = deniedPhotos
        self.starredPhotos = starredPhotos
        self.deletedPhotos = deletedPhotos
        self.flaggedPhotos = flaggedPhotos
        self.hasPermission = hasPermission
        self.hasProduct = hasProduct
        self.inStockOnly = inStockOnly
        self.hasActionLink = hasActionLink
        self.flagDeniedPhotos = flagDeniedPhotos
        self.flagStarredPhotos = flagStarredPhotos
        self.flagDeletedPhotos = flagDeletedPhotos
        self.flagFlaggedPhotos = flagFlaggedPhotos
        self.flagHasPermission = flagHasPermission
        self.flagHasProduct = flagHasProduct
        self.flagInStockOnly = flagInStockOnly
        self.flagHasActionLink = flagHasActionLink
    }

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
