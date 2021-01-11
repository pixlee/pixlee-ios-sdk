//
//  PXLAnalyticsEventWidgetVisible.swift
//  PixleeSDK
//
//  Created by Csaba Toth on 2020. 03. 18..
//  Copyright © 2020. Pixlee. All rights reserved.
//


import UIKit

public struct PXLAnalyticsEventWidgetVisible: PXLAnalyticsEvent {
    let album: PXLAlbum

    let widget: PXLWidgetType

    public var eventName = "widgetVisible"

    public init(album: PXLAlbum, widget: PXLWidgetType) {
        self.album = album
        self.widget = widget
    }

    public var logParameters: [String: Any] {
        let udid = UIDevice.current.identifierForVendor?.uuidString ?? "Unknown udid"

        var parameters: [String: Any] = ["widget": widget.key,
                                         "platform": "ios",
                                         "uid": udid]
        if let identifier = album.identifier {
            parameters["album_id"] = identifier
        } else {
            parameters["album_id"] = ""
            print("PIXLEE SDK:⚠️ Warning you are sending the event without having an album_id. Please wait for the loadMore to return before triggering this event. refer to Readme ")
        }

        let photoIds = album.photos.compactMap({ (photo) -> String? in
            String(photo.albumPhotoId)
        })

        parameters["photos"] = photoIds.joined(separator: ",")

        if let regionId = album.regionId {
            parameters["region_id"] = String(regionId)
        }
        
        return parameters
    }
}
