//
//  PXLPhotoConverter.swift
//  Example
//
//  Created by Csaba Toth on 2020. 01. 15..
//  Copyright © 2020. Pixlee. All rights reserved.
//

import Foundation

class PXLPhotoConverter {
    let productConverter: PXLProductConverter
    let timeBasedProductConverter: PXLTimeBasedProductConverter

    init(productConverter: PXLProductConverter, timeBasedProductConverter: PXLTimeBasedProductConverter) {
        self.productConverter = productConverter
        self.timeBasedProductConverter = timeBasedProductConverter
    }

    func convertPhotoDTOsToPhotos(photoDtos: [PXLPhotoDTO]) -> [PXLPhoto] {
        return photoDtos.map { (dto) -> PXLPhoto in
            self.convertPhotoDTOToPhoto(dto: dto)
        }
    }

    func convertPhotoDTOToPhoto(dto: PXLPhotoDTO) -> PXLPhoto {
        var taggedAt: Date?
        if let tagged = dto.taggedAt {
            taggedAt = Date(timeIntervalSince1970: TimeInterval(tagged / 1000))
        }
        var sourceURL: URL?
        if let sourceUrl = dto.sourceURL {
            sourceURL = URL(string: sourceUrl)
        }
        var updatedAt: Date?
        if let updated = dto.updatedAt {
            updatedAt = Date(timeIntervalSince1970: TimeInterval(updated / 1000))
        }
        var platformLink: URL?
        if let platform = dto.platformLink {
            platformLink = URL(string: platform)
        }
        
        let timeBasedProducts = dto.timeBasedProducts.map({ (timeBasedProductDto) -> PXLTimeBasedProduct in
            timeBasedProductConverter.convert(dto: timeBasedProductDto)
        })
        
        var productTimestampMap = [Int: PXLTimeBasedProduct]() // [productId: timestamp]
        timeBasedProducts.forEach{ timeBasedProduct in
            productTimestampMap[timeBasedProduct.productId] = timeBasedProduct
        }
        
        return PXLPhoto(id: dto.id,
                        photoTitle: dto.photoTitle ?? "",
                        latitude: dto.latitude,
                        longitude: dto.longitude,
                        taggedAt: taggedAt,
                        emailAddress: dto.emailAddress,
                        instagramFollowers: dto.instagramFollowers,
                        twitterFollowers: dto.twitterFollowers,
                        avatarUrl: dto.avatarURL != nil ? URL(string: dto.avatarURL!) : nil,
                        username: dto.userName,
                        connectedUserId: dto.connectedUserID,
                        source: dto.source,
                        contentType: dto.contentType,
                        dataFileName: dto.dataFileName,
                        mediumUrl: dto.mediumURL != nil ? URL(string: dto.mediumURL!) : nil,
                        bigUrl: dto.bigURL != nil ? URL(string: dto.bigURL!) : nil,
                        thumbnailUrl: dto.thumbnailURL != nil ? URL(string: dto.thumbnailURL!) : nil,
                        sourceUrl: sourceURL,
                        mediaId: dto.mediaID,
                        existIn: dto.existIn,
                        collectTerm: dto.collectTerm,
                        albumPhotoId: dto.albumPhotoID,
                        albumId: dto.albumID,
                        likeCount: dto.likeCount,
                        shareCount: dto.shareCount,
                        actionLink: dto.actionLink != nil ? URL(string: dto.actionLink!) : nil,
                        actionLinkText: dto.actionLinkText,
                        actionLinkTitle: dto.actionLinkText,
                        actionLinkPhoto: dto.actionLinkPhoto,
                        updatedAt: updatedAt,
                        isStarred: dto.isStarred,
                        approved: dto.approved,
                        archived: dto.archived,
                        isFlagged: dto.isFlagged,
                        unreadCount: dto.unreadCount,
                        albumActionLink: nil,
                        title: dto.title,
                        messaged: dto.messaged,
                        hasPermission: dto.hasPermission,
                        awaitingPermission: dto.awaitingPermission,
                        instUserHasLiked: dto.socialUserHasLiked,
                        platformLink: platformLink,
                        products: dto.products.map({ (productDto) -> PXLProduct in
                            return productConverter.convertProductDTOtoProduct(dto: productDto, timeBasedProduct:  productTimestampMap[productDto.id])
                        }),
                        timeBasedProducts: timeBasedProducts,
                        cdnSmallUrl: URL(string: dto.pixleeCDNPhotos.smallURL),
                        cdnMediumUrl: URL(string: dto.pixleeCDNPhotos.mediumURL),
                        cdnLargeUrl: URL(string: dto.pixleeCDNPhotos.largeURL),
                        cdnOriginalUrl: URL(string: dto.pixleeCDNPhotos.originalURL))
    }
}
