//
//  PXLAlbum.swift
//  pixlee_sdk
//
//  Created by Csaba Toth on 2020. 01. 07..
//  Copyright © 2020. BitRaptors. All rights reserved.
//

import Alamofire
import Foundation

public class PXLAlbum {
    public static let PXLAlbumDefaultPerPage: Int = 20

    public let identifier: String?
    public let sku: Int?

    public var photos: [PXLPhoto]
    public var lastPageFetched: Int
    public var hasNextPage: Bool

    public var perPage: Int {
        didSet {
            clearPhotosAndPages()
        }
    }

    public var sortOptions: PXLAlbumSortOptions? {
        didSet {
            clearPhotosAndPages()
        }
    }

    public var filterOptions: PXLAlbumFilterOptions? {
        didSet {
            clearPhotosAndPages()
        }
    }

    func clearPhotosAndPages() {
        photos = []
        lastPageFetched = NSNotFound
        hasNextPage = true
    }

    public init(identifier: String? = nil, sku: Int? = nil, perPage: Int = PXLAlbum.PXLAlbumDefaultPerPage, photos: [PXLPhoto] = [PXLPhoto](), lastPageFetched: Int = 0, hasNextPage: Bool = true, sortOptions: PXLAlbumSortOptions? = nil, filterOptions: PXLAlbumFilterOptions? = nil) {
        self.identifier = identifier
        self.sku = sku
        self.perPage = perPage
        self.photos = photos
        self.lastPageFetched = lastPageFetched
        self.hasNextPage = hasNextPage
        self.sortOptions = sortOptions
        self.filterOptions = filterOptions
    }

    public func changeIdentifier(newIdentifier: String) -> PXLAlbum {
        return PXLAlbum(identifier: newIdentifier,
                        sku: sku,
                        perPage: PXLAlbum.PXLAlbumDefaultPerPage,
                        photos: [],
                        lastPageFetched: 0,
                        hasNextPage: true,
                        sortOptions: sortOptions,
                        filterOptions: filterOptions)
    }

    public func changeSKU(newSKU: Int) -> PXLAlbum {
        return PXLAlbum(identifier: identifier,
                        sku: newSKU,
                        perPage: PXLAlbum.PXLAlbumDefaultPerPage,
                        photos: [],
                        lastPageFetched: NSNotFound,
                        hasNextPage: true,
                        sortOptions: sortOptions,
                        filterOptions: filterOptions)
    }
}
