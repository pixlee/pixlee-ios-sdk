//
//  PXLImageUploadResponseDTO.swift
//  PixleeSDK
//
//  Created by Csaba Toth on 2020. 03. 12..
//

import Foundation
public struct PXLImageUploadResponseDTO: Codable {
    let albumPhotoId: Int
    let connectedUserId: Int

    enum CodingKeys: String, CodingKey {
        case albumPhotoId = "album_photo_id"
        case connectedUserId = "connected_user_id"
    }
}
