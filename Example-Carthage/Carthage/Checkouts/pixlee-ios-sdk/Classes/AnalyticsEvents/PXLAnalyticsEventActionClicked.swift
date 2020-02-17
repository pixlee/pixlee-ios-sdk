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

    public var eventName = "actionClicked"

    public init(photo: PXLPhoto, actionLink: String) {
        self.photo = photo
        self.actionLink = actionLink
    }

    public var logParameters: [String: Any] {
        let udid = UIDevice.current.identifierForVendor?.uuidString ?? "Unknown udid"

        let parameters: [String: Any] = [
            "action_link_url": actionLink,
            "album_photo_id": photo.albumPhotoId,
            "album_id": photo.albumId,
            "platform": "ios",
            "uid": udid]

        return parameters
    }
}
