//
//  PXLAlbumSortOptions.swift
//  pixlee_sdk
//
//  Created by Csaba Toth on 2020. 01. 07..
//  Copyright © 2020. BitRaptors. All rights reserved.
//

import Foundation

public enum PXLAlbumSortType: Int, Codable {
    case none
    case recency
    case random
    case pixleeShares
    case pixleeLikes
    case popularity
    case dynamic

    var key: String {
        switch self {
        case .recency:
            return "recency"
        case .random:
            return "random"
        case .pixleeShares:
            return "pixlee_shares"
        case .pixleeLikes:
            return "pixlee_likes"
        case .popularity:
            return "popularity"
        case .dynamic:
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
        if sortType != .none {
            options[sortType.key] = true
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
