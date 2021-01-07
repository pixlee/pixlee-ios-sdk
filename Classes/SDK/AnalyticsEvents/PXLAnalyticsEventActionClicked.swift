//
//  PXLActionClickedAnalyticsEvent.swift
//  Example
//
//  Created by Csaba Toth on 2020. 01. 20..
//  Copyright © 2020. Pixlee. All rights reserved.
//

import UIKit

public struct PXLAnalyticsEventActionClicked: PXLAnalyticsEvent {
    let photo: PXLPhoto
    let actionLink: String
    let regionId: Int?

    public var eventName = "actionClicked"

    public init(photo: PXLPhoto, actionLink: String, regionId: Int?) {
        self.photo = photo
        self.actionLink = actionLink
        self.regionId = regionId
    }

    public var logParameters: [String: Any] {
        let udid = UIDevice.current.identifierForVendor?.uuidString ?? "Unknown udid"

        var parameters: [String: Any] = [
            "action_link_url": actionLink,
            "album_photo_id": photo.albumPhotoId,
            "album_id": photo.albumId,
            "platform": "ios",
            "uid": udid]

        if let regionId = regionId {
            parameters["region_id"] = regionId
        }
        
        return parameters
    }
}
