//
//  PXLAlbumSortOptions.swift
//  pixlee_sdk
//
//  Created by Csaba Toth on 2020. 01. 07..
//  Copyright © 2020. BitRaptors. All rights reserved.
//

import Foundation

public enum PXLAlbumSortType: Int, Codable {
    case None
    case Recency
    case Random
    case PixleeShares
    case PixleeLikes
    case Popularity
    case Dynamic

    var key: String {
        switch self {
        case .Recency:
            return "recency"
        case .Random:
            return "random"
        case .PixleeShares:
            return "pixlee_shares"
        case .PixleeLikes:
            return "pixlee_likes"
        case .Popularity:
            return "popularity"
        case .Dynamic:
            return "dynamic"
        default:
            return ""
        }
    }
}

public struct PXLAlbumSortOptions: Codable {
    public let sortType: PXLAlbumSortType
    public let ascending: Bool

    public init(sortType: PXLAlbumSortType, ascending: Bool) {
        self.sortType = sortType
        self.ascending = ascending
    }

    var urlParamString: String? {
        var options = [String: Any]()
        if ascending {
            options["asc"] = true
        } else {
            options["desc"] = true
        }
        if sortType != .None {
            options[sortType.key] = true
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
