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

    init(productConverter: PXLProductConverter) {
        self.productConverter = productConverter
    }

    func convertPhotoDTOsToPhotos(photoDtos: [PXLPhotoDTO]) -> [PXLPhoto] {
        return photoDtos.map { (dto) -> PXLPhoto in
            self.convertPhotoDTOToPhoto(dto: dto)
        }
    }

    func convertPhotoDTOToPhoto(dto: PXLPhotoDTO) -> PXLPhoto {
        return PXLPhoto(id: dto.id,
                        photoTitle: dto.photoTitle ?? "",
                        latitude: dto.latitude,
                        longitude: dto.longitude,
                        taggedAt: Date(timeIntervalSince1970: TimeInterval(dto.taggedAt / 1000)),
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
                        sourceUrl: URL(string: dto.sourceURL),
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
                        updatedAt: Date(timeIntervalSince1970: TimeInterval(dto.updatedAt / 1000)),
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
                        platformLink: URL(string: dto.platformLink),
                        products: dto.products.map({ (productDto) -> PXLProduct in
                            productConverter.convertProductDTOtoProduct(dto: productDto)
                        }),
                        cdnSmallUrl: URL(string: dto.pixleeCDNPhotos.smallURL),
                        cdnMediumUrl: URL(string: dto.pixleeCDNPhotos.mediumURL),
                        cdnLargeUrl: URL(string: dto.pixleeCDNPhotos.largeURL),
                        cdnOriginalUrl: URL(string: dto.pixleeCDNPhotos.originalURL))
    }
}
