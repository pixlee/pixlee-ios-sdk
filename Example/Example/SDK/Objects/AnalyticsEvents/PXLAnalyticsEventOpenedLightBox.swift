//
//  PXLOpenedLightBoxAnalyitcsEvent.swift
//  Example
//
//  Created by Csaba Toth on 2020. 01. 20..
//  Copyright © 2020. Pixlee. All rights reserved.
//

import UIKit

struct PXLAnalyticsEventOpenedLightBox: PXLAnalyticsEvent {
    let photo: PXLPhoto

    var eventName = "openedLightbox"

    var logParameters: [String: Any] {
        let udid = UIDevice.current.identifierForVendor?.uuidString ?? "Unknown udid"

        let parameters: [String: Any] = [
            "album_photo_id": photo.albumPhotoId,
            "album_id": photo.albumId,
            "platform": "ios",
            "uid": udid]

        return parameters
    }
}
