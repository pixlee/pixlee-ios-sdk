//
//  PXLAlbumFilterOptions.swift
//  pixlee_sdk
//
//  Created by Csaba Toth on 2020. 01. 07..
//  Copyright © 2020. BitRaptors. All rights reserved.
//

import Foundation

public enum PXLContentSource :String, Codable{
    case instagram_feed = "instagram_feed"
    case instagram_story = "instagram_story"
    case twitter = "twitter"
    case facebook = "facebook"
    case api = "api"
    case desktop = "desktop"
    case email = "email"
}


public struct PXLAlbumFilterOptions :Codable{
    public var minInstagramFollowers: Int?
    public var minTwitterFollowers: Int?
    public var contentSource: [PXLContentSource]?
    public var contentType: [String]?
    public var inCategories: [Int]?
    public var filterBySubcaption: String?
    public var filterByUserhandle: [String: String]?
    public var submittedDateStart: Date?
    public var submittedDateEnd: Date?
    public var computerVision: [String: String]?
    public var filterByLocation: [String: String]?
    public var filterByRadius: String?

    public var deniedPhotos: Bool?
    public var starredPhotos: Bool?
    public var deletedPhotos: Bool?
    public var flaggedPhotos: Bool?
    public var hasPermission: Bool?
    public var hasProduct: Bool?
    public var inStockOnly: Bool?
    public var hasActionLink: Bool?


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
                deniedPhotos: Bool? = nil,
                starredPhotos: Bool? = nil,
                deletedPhotos: Bool? = nil,
                flaggedPhotos: Bool? = nil,
                hasPermission: Bool? = nil,
                hasProduct: Bool? = nil,
                inStockOnly: Bool? = nil,
                hasActionLink: Bool? = nil) {
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
    }

    var urlParamString: String? {
        var options = [String: Any]()
        if let minInstagramFollowers = minInstagramFollowers {
            options["min_instagram_followers"] = "\(minInstagramFollowers)"
        }

        if let minTwitterFollowers = minTwitterFollowers {
            options["min_twitter_followers"] = "\(minTwitterFollowers)"
        }

        if let deniedPhotos = deniedPhotos {
            options["denied_photos"] = deniedPhotos
        }

        if let starredPhotos = starredPhotos {
            options["starred_photos"] = starredPhotos
        }

        if let deletedPhotos = deletedPhotos {
            options["deleted_photos"] = deletedPhotos
        }

        if let flaggedPhotos = flaggedPhotos {
            options["flagged_photos"] = flaggedPhotos
        }

        if let hasPermission = hasPermission {
            options["has_permission"] = hasPermission
        }

        if let hasProduct = hasProduct {
            options["has_product"] = hasProduct
        }

        if let inStockOnly = inStockOnly {
            options["has_product"] = inStockOnly
        }

        if let hasActionLink = hasActionLink {
            options["has_action_link"] = hasActionLink
        }

        if let contentSource = self.contentSource {
            var array:[String] = []
            var isInstagramAdded = false
            for source in contentSource{
                array.append(source.rawValue)
                if !isInstagramAdded &&
                    (source == PXLContentSource.instagram_feed || source == PXLContentSource.instagram_story) {
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
