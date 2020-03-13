//
//  PXLAlbumFilterOptions.swift
//  pixlee_sdk
//
//  Created by Csaba Toth on 2020. 01. 07..
//  Copyright © 2020. BitRaptors. All rights reserved.
//

import Foundation

public enum PXLContentSource {
    case instagram_feed
    case instagram_story
    case twitter
    case facebook
    case api
    case desktop
    case email
    var key: String {
        switch self {
        case .instagram_feed:
            return "instagram_feed"
        case .instagram_story:
            return "instagram_story"
        case .twitter:
            return "twitter"
        case .facebook:
            return "facebook"
        case .api:
            return "api"
        case .desktop:
            return "desktop"
        case .email:
            return "email"
        }
    }
}


public struct PXLAlbumFilterOptions {
    public let minInstagramFollowers: Int?
    public let minTwitterFollowers: Int?
    public let contentSource: [PXLContentSource]?
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
                contentSource: [PXLContentSource]? = nil,
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

    public func changeMinInstagramFollowers(minFollowers: Int) -> PXLAlbumFilterOptions {
        return PXLAlbumFilterOptions(minInstagramFollowers: minFollowers,
                                     minTwitterFollowers: minTwitterFollowers,
                                     contentSource: contentSource,
                                     contentType: contentType,
                                     inCategories: inCategories,
                                     filterBySubcaption: filterBySubcaption,
                                     filterByUserhandle: filterByUserhandle,
                                     submittedDateStart: submittedDateStart,
                                     submittedDateEnd: submittedDateEnd,
                                     computerVision: computerVision,
                                     filterByLocation: filterByLocation,
                                     filterByRadius: filterByRadius,
                                     deniedPhotos: deniedPhotos,
                                     starredPhotos: starredPhotos,
                                     deletedPhotos: deletedPhotos,
                                     flaggedPhotos: flaggedPhotos,
                                     hasPermission: hasPermission,
                                     hasProduct: hasProduct,
                                     inStockOnly: inStockOnly,
                                     hasActionLink: hasActionLink,
                                     flagDeniedPhotos: flagDeniedPhotos,
                                     flagStarredPhotos: flagStarredPhotos,
                                     flagDeletedPhotos: flagDeletedPhotos,
                                     flagFlaggedPhotos: flagFlaggedPhotos,
                                     flagHasPermission: flagHasPermission,
                                     flagHasProduct: flagHasProduct,
                                     flagInStockOnly: flagInStockOnly,
                                     flagHasActionLink: flagHasActionLink)
    }

    public func changeMinTwitterFollowers(minFollowers: Int) -> PXLAlbumFilterOptions {
        return PXLAlbumFilterOptions(minInstagramFollowers: minInstagramFollowers,
                                     minTwitterFollowers: minFollowers,
                                     contentSource: contentSource,
                                     contentType: contentType,
                                     inCategories: inCategories,
                                     filterBySubcaption: filterBySubcaption,
                                     filterByUserhandle: filterByUserhandle,
                                     submittedDateStart: submittedDateStart,
                                     submittedDateEnd: submittedDateEnd,
                                     computerVision: computerVision,
                                     filterByLocation: filterByLocation,
                                     filterByRadius: filterByRadius,
                                     deniedPhotos: deniedPhotos,
                                     starredPhotos: starredPhotos,
                                     deletedPhotos: deletedPhotos,
                                     flaggedPhotos: flaggedPhotos,
                                     hasPermission: hasPermission,
                                     hasProduct: hasProduct,
                                     inStockOnly: inStockOnly,
                                     hasActionLink: hasActionLink,
                                     flagDeniedPhotos: flagDeniedPhotos,
                                     flagStarredPhotos: flagStarredPhotos,
                                     flagDeletedPhotos: flagDeletedPhotos,
                                     flagFlaggedPhotos: flagFlaggedPhotos,
                                     flagHasPermission: flagHasPermission,
                                     flagHasProduct: flagHasProduct,
                                     flagInStockOnly: flagInStockOnly,
                                     flagHasActionLink: flagHasActionLink)
    }

    public func changeContentSource(newContentSource: [PXLContentSource]?) -> PXLAlbumFilterOptions {
        return PXLAlbumFilterOptions(minInstagramFollowers: minInstagramFollowers,
                                     minTwitterFollowers: minTwitterFollowers,
                                     contentSource: newContentSource,
                                     contentType: contentType,
                                     inCategories: inCategories,
                                     filterBySubcaption: filterBySubcaption,
                                     filterByUserhandle: filterByUserhandle,
                                     submittedDateStart: submittedDateStart,
                                     submittedDateEnd: submittedDateEnd,
                                     computerVision: computerVision,
                                     filterByLocation: filterByLocation,
                                     filterByRadius: filterByRadius,
                                     deniedPhotos: deniedPhotos,
                                     starredPhotos: starredPhotos,
                                     deletedPhotos: deletedPhotos,
                                     flaggedPhotos: flaggedPhotos,
                                     hasPermission: hasPermission,
                                     hasProduct: hasProduct,
                                     inStockOnly: inStockOnly,
                                     hasActionLink: hasActionLink,
                                     flagDeniedPhotos: flagDeniedPhotos,
                                     flagStarredPhotos: flagStarredPhotos,
                                     flagDeletedPhotos: flagDeletedPhotos,
                                     flagFlaggedPhotos: flagFlaggedPhotos,
                                     flagHasPermission: flagHasPermission,
                                     flagHasProduct: flagHasProduct,
                                     flagInStockOnly: flagInStockOnly,
                                     flagHasActionLink: flagHasActionLink)
    }

    public func changeContentType(newContentType: [String]?) -> PXLAlbumFilterOptions {
        return PXLAlbumFilterOptions(minInstagramFollowers: minInstagramFollowers,
                                     minTwitterFollowers: minTwitterFollowers,
                                     contentSource: contentSource,
                                     contentType: newContentType,
                                     inCategories: inCategories,
                                     filterBySubcaption: filterBySubcaption,
                                     filterByUserhandle: filterByUserhandle,
                                     submittedDateStart: submittedDateStart,
                                     submittedDateEnd: submittedDateEnd,
                                     computerVision: computerVision,
                                     filterByLocation: filterByLocation,
                                     filterByRadius: filterByRadius,
                                     deniedPhotos: deniedPhotos,
                                     starredPhotos: starredPhotos,
                                     deletedPhotos: deletedPhotos,
                                     flaggedPhotos: flaggedPhotos,
                                     hasPermission: hasPermission,
                                     hasProduct: hasProduct,
                                     inStockOnly: inStockOnly,
                                     hasActionLink: hasActionLink,
                                     flagDeniedPhotos: flagDeniedPhotos,
                                     flagStarredPhotos: flagStarredPhotos,
                                     flagDeletedPhotos: flagDeletedPhotos,
                                     flagFlaggedPhotos: flagFlaggedPhotos,
                                     flagHasPermission: flagHasPermission,
                                     flagHasProduct: flagHasProduct,
                                     flagInStockOnly: flagInStockOnly,
                                     flagHasActionLink: flagHasActionLink)
    }

    public func changeInCategories(newInCategories: [Int]?) -> PXLAlbumFilterOptions {
        return PXLAlbumFilterOptions(minInstagramFollowers: minInstagramFollowers,
                                     minTwitterFollowers: minTwitterFollowers,
                                     contentSource: contentSource,
                                     contentType: contentType,
                                     inCategories: newInCategories,
                                     filterBySubcaption: filterBySubcaption,
                                     filterByUserhandle: filterByUserhandle,
                                     submittedDateStart: submittedDateStart,
                                     submittedDateEnd: submittedDateEnd,
                                     computerVision: computerVision,
                                     filterByLocation: filterByLocation,
                                     filterByRadius: filterByRadius,
                                     deniedPhotos: deniedPhotos,
                                     starredPhotos: starredPhotos,
                                     deletedPhotos: deletedPhotos,
                                     flaggedPhotos: flaggedPhotos,
                                     hasPermission: hasPermission,
                                     hasProduct: hasProduct,
                                     inStockOnly: inStockOnly,
                                     hasActionLink: hasActionLink,
                                     flagDeniedPhotos: flagDeniedPhotos,
                                     flagStarredPhotos: flagStarredPhotos,
                                     flagDeletedPhotos: flagDeletedPhotos,
                                     flagFlaggedPhotos: flagFlaggedPhotos,
                                     flagHasPermission: flagHasPermission,
                                     flagHasProduct: flagHasProduct,
                                     flagInStockOnly: flagInStockOnly,
                                     flagHasActionLink: flagHasActionLink)
    }

    public func changeFilterBySubcaption(newFilterBySubcaption: String?) -> PXLAlbumFilterOptions {
        return PXLAlbumFilterOptions(minInstagramFollowers: minInstagramFollowers,
                                     minTwitterFollowers: minTwitterFollowers,
                                     contentSource: contentSource,
                                     contentType: contentType,
                                     inCategories: inCategories,
                                     filterBySubcaption: newFilterBySubcaption,
                                     filterByUserhandle: filterByUserhandle,
                                     submittedDateStart: submittedDateStart,
                                     submittedDateEnd: submittedDateEnd,
                                     computerVision: computerVision,
                                     filterByLocation: filterByLocation,
                                     filterByRadius: filterByRadius,
                                     deniedPhotos: deniedPhotos,
                                     starredPhotos: starredPhotos,
                                     deletedPhotos: deletedPhotos,
                                     flaggedPhotos: flaggedPhotos,
                                     hasPermission: hasPermission,
                                     hasProduct: hasProduct,
                                     inStockOnly: inStockOnly,
                                     hasActionLink: hasActionLink,
                                     flagDeniedPhotos: flagDeniedPhotos,
                                     flagStarredPhotos: flagStarredPhotos,
                                     flagDeletedPhotos: flagDeletedPhotos,
                                     flagFlaggedPhotos: flagFlaggedPhotos,
                                     flagHasPermission: flagHasPermission,
                                     flagHasProduct: flagHasProduct,
                                     flagInStockOnly: flagInStockOnly,
                                     flagHasActionLink: flagHasActionLink)
    }

    public func changeFilterUserhandle(newFilterByUserhandle: [String: String]?) -> PXLAlbumFilterOptions {
        return PXLAlbumFilterOptions(minInstagramFollowers: minInstagramFollowers,
                                     minTwitterFollowers: minTwitterFollowers,
                                     contentSource: contentSource,
                                     contentType: contentType,
                                     inCategories: inCategories,
                                     filterBySubcaption: filterBySubcaption,
                                     filterByUserhandle: newFilterByUserhandle,
                                     submittedDateStart: submittedDateStart,
                                     submittedDateEnd: submittedDateEnd,
                                     computerVision: computerVision,
                                     filterByLocation: filterByLocation,
                                     filterByRadius: filterByRadius,
                                     deniedPhotos: deniedPhotos,
                                     starredPhotos: starredPhotos,
                                     deletedPhotos: deletedPhotos,
                                     flaggedPhotos: flaggedPhotos,
                                     hasPermission: hasPermission,
                                     hasProduct: hasProduct,
                                     inStockOnly: inStockOnly,
                                     hasActionLink: hasActionLink,
                                     flagDeniedPhotos: flagDeniedPhotos,
                                     flagStarredPhotos: flagStarredPhotos,
                                     flagDeletedPhotos: flagDeletedPhotos,
                                     flagFlaggedPhotos: flagFlaggedPhotos,
                                     flagHasPermission: flagHasPermission,
                                     flagHasProduct: flagHasProduct,
                                     flagInStockOnly: flagInStockOnly,
                                     flagHasActionLink: flagHasActionLink)
    }

    public func changeSubmittedDateStart(newSubmittedDateStart: Date?) -> PXLAlbumFilterOptions {
        return PXLAlbumFilterOptions(minInstagramFollowers: minInstagramFollowers,
                                     minTwitterFollowers: minTwitterFollowers,
                                     contentSource: contentSource,
                                     contentType: contentType,
                                     inCategories: inCategories,
                                     filterBySubcaption: filterBySubcaption,
                                     filterByUserhandle: filterByUserhandle,
                                     submittedDateStart: newSubmittedDateStart,
                                     submittedDateEnd: submittedDateEnd,
                                     computerVision: computerVision,
                                     filterByLocation: filterByLocation,
                                     filterByRadius: filterByRadius,
                                     deniedPhotos: deniedPhotos,
                                     starredPhotos: starredPhotos,
                                     deletedPhotos: deletedPhotos,
                                     flaggedPhotos: flaggedPhotos,
                                     hasPermission: hasPermission,
                                     hasProduct: hasProduct,
                                     inStockOnly: inStockOnly,
                                     hasActionLink: hasActionLink,
                                     flagDeniedPhotos: flagDeniedPhotos,
                                     flagStarredPhotos: flagStarredPhotos,
                                     flagDeletedPhotos: flagDeletedPhotos,
                                     flagFlaggedPhotos: flagFlaggedPhotos,
                                     flagHasPermission: flagHasPermission,
                                     flagHasProduct: flagHasProduct,
                                     flagInStockOnly: flagInStockOnly,
                                     flagHasActionLink: flagHasActionLink)
    }

    public func changeSubmittedDateEnd(newSubmittedDateEnd: Date?) -> PXLAlbumFilterOptions {
        return PXLAlbumFilterOptions(minInstagramFollowers: minInstagramFollowers,
                                     minTwitterFollowers: minTwitterFollowers,
                                     contentSource: contentSource,
                                     contentType: contentType,
                                     inCategories: inCategories,
                                     filterBySubcaption: filterBySubcaption,
                                     filterByUserhandle: filterByUserhandle,
                                     submittedDateStart: submittedDateStart,
                                     submittedDateEnd: newSubmittedDateEnd,
                                     computerVision: computerVision,
                                     filterByLocation: filterByLocation,
                                     filterByRadius: filterByRadius,
                                     deniedPhotos: deniedPhotos,
                                     starredPhotos: starredPhotos,
                                     deletedPhotos: deletedPhotos,
                                     flaggedPhotos: flaggedPhotos,
                                     hasPermission: hasPermission,
                                     hasProduct: hasProduct,
                                     inStockOnly: inStockOnly,
                                     hasActionLink: hasActionLink,
                                     flagDeniedPhotos: flagDeniedPhotos,
                                     flagStarredPhotos: flagStarredPhotos,
                                     flagDeletedPhotos: flagDeletedPhotos,
                                     flagFlaggedPhotos: flagFlaggedPhotos,
                                     flagHasPermission: flagHasPermission,
                                     flagHasProduct: flagHasProduct,
                                     flagInStockOnly: flagInStockOnly,
                                     flagHasActionLink: flagHasActionLink)
    }

    public func changeComputerVision(newComputerVision: [String: String]?) -> PXLAlbumFilterOptions {
        return PXLAlbumFilterOptions(minInstagramFollowers: minInstagramFollowers,
                                     minTwitterFollowers: minTwitterFollowers,
                                     contentSource: contentSource,
                                     contentType: contentType,
                                     inCategories: inCategories,
                                     filterBySubcaption: filterBySubcaption,
                                     filterByUserhandle: filterByUserhandle,
                                     submittedDateStart: submittedDateStart,
                                     submittedDateEnd: submittedDateEnd,
                                     computerVision: newComputerVision,
                                     filterByLocation: filterByLocation,
                                     filterByRadius: filterByRadius,
                                     deniedPhotos: deniedPhotos,
                                     starredPhotos: starredPhotos,
                                     deletedPhotos: deletedPhotos,
                                     flaggedPhotos: flaggedPhotos,
                                     hasPermission: hasPermission,
                                     hasProduct: hasProduct,
                                     inStockOnly: inStockOnly,
                                     hasActionLink: hasActionLink,
                                     flagDeniedPhotos: flagDeniedPhotos,
                                     flagStarredPhotos: flagStarredPhotos,
                                     flagDeletedPhotos: flagDeletedPhotos,
                                     flagFlaggedPhotos: flagFlaggedPhotos,
                                     flagHasPermission: flagHasPermission,
                                     flagHasProduct: flagHasProduct,
                                     flagInStockOnly: flagInStockOnly,
                                     flagHasActionLink: flagHasActionLink)
    }

    public func changeFilterByLocation(newFilterByLocation: [String: String]?) -> PXLAlbumFilterOptions {
        return PXLAlbumFilterOptions(minInstagramFollowers: minInstagramFollowers,
                                     minTwitterFollowers: minTwitterFollowers,
                                     contentSource: contentSource,
                                     contentType: contentType,
                                     inCategories: inCategories,
                                     filterBySubcaption: filterBySubcaption,
                                     filterByUserhandle: filterByUserhandle,
                                     submittedDateStart: submittedDateStart,
                                     submittedDateEnd: submittedDateEnd,
                                     computerVision: computerVision,
                                     filterByLocation: newFilterByLocation,
                                     filterByRadius: filterByRadius,
                                     deniedPhotos: deniedPhotos,
                                     starredPhotos: starredPhotos,
                                     deletedPhotos: deletedPhotos,
                                     flaggedPhotos: flaggedPhotos,
                                     hasPermission: hasPermission,
                                     hasProduct: hasProduct,
                                     inStockOnly: inStockOnly,
                                     hasActionLink: hasActionLink,
                                     flagDeniedPhotos: flagDeniedPhotos,
                                     flagStarredPhotos: flagStarredPhotos,
                                     flagDeletedPhotos: flagDeletedPhotos,
                                     flagFlaggedPhotos: flagFlaggedPhotos,
                                     flagHasPermission: flagHasPermission,
                                     flagHasProduct: flagHasProduct,
                                     flagInStockOnly: flagInStockOnly,
                                     flagHasActionLink: flagHasActionLink)
    }

    public func changeFilterByRadius(newFilterByRadius: String?) -> PXLAlbumFilterOptions {
        return PXLAlbumFilterOptions(minInstagramFollowers: minInstagramFollowers,
                                     minTwitterFollowers: minTwitterFollowers,
                                     contentSource: contentSource,
                                     contentType: contentType,
                                     inCategories: inCategories,
                                     filterBySubcaption: filterBySubcaption,
                                     filterByUserhandle: filterByUserhandle,
                                     submittedDateStart: submittedDateStart,
                                     submittedDateEnd: submittedDateEnd,
                                     computerVision: computerVision,
                                     filterByLocation: filterByLocation,
                                     filterByRadius: newFilterByRadius,
                                     deniedPhotos: deniedPhotos,
                                     starredPhotos: starredPhotos,
                                     deletedPhotos: deletedPhotos,
                                     flaggedPhotos: flaggedPhotos,
                                     hasPermission: hasPermission,
                                     hasProduct: hasProduct,
                                     inStockOnly: inStockOnly,
                                     hasActionLink: hasActionLink,
                                     flagDeniedPhotos: flagDeniedPhotos,
                                     flagStarredPhotos: flagStarredPhotos,
                                     flagDeletedPhotos: flagDeletedPhotos,
                                     flagFlaggedPhotos: flagFlaggedPhotos,
                                     flagHasPermission: flagHasPermission,
                                     flagHasProduct: flagHasProduct,
                                     flagInStockOnly: flagInStockOnly,
                                     flagHasActionLink: flagHasActionLink)
    }

    var urlParamString: String? {
        var options = [String: Any]()
        if let minInstagramFollowers = minInstagramFollowers {
            options["min_instagram_followers"] = "\(minInstagramFollowers)"
        }

        if let minTwitterFollowers = minTwitterFollowers {
            options["min_twitter_followers"] = "\(minTwitterFollowers)"
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

        if let contentSource = self.contentSource {
            var array:[String] = []
            var isInstagramAdded = false
            for source in contentSource{
                array.append(source.key)
                if !isInstagramAdded &&
                    (source.key=="instagram_feed" || source.key=="instagram_story") {
                    isInstagramAdded = true
                    array.append("instagram")
                }
            }
            
            options["content_source"] = array
        }

        if let contentType = self.contentType {
            options["content_type"] = contentType
        }

        if let filterBySubcaption = self.filterBySubcaption {
            options["filter_by_subcaption"] = "\(filterBySubcaption)"
        }

        if let submittedDateStart = submittedDateStart {
            options["submitted_date_start"] = "\(submittedDateStart.timeIntervalSince1970)"
        }

        if let submittedDateEnd = submittedDateEnd {
            options["submitted_date_end"] = "\(submittedDateEnd.timeIntervalSince1970)"
        }

        if let inCategories = inCategories {
            options["in_categories"] = "\(inCategories)"
        }

        if let computerVision = computerVision {
            options["computer_vision"] = "\(computerVision)"
        }
        if let filterByLocation = filterByLocation {
            options["filter_by_location"] = "\(filterByLocation)"
        }
        if let filterByUserhandle = filterByUserhandle {
            options["filter_by_userhandle"] = "\(filterByUserhandle)"
        }
        if let filterByRadius = filterByRadius {
            options["filter_by_radius"] = "\(filterByRadius)"
        }

        do {
            let jsonData = try JSONSerialization.data(withJSONObject: options, options: [])

            if let JSONString = String(data: jsonData, encoding: String.Encoding.utf8) {
                return JSONString
            }
        } catch {
            print("PixleeSDK Error during the serialization of the sort options: \(error)")
        }
        return nil
    }
}
