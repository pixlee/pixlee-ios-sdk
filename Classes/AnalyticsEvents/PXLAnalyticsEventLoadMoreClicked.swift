//
//  PXLLoadMoreClickedAnalyticsEvent.swift
//  Example
//
//  Created by Csaba Toth on 2020. 01. 20..
//  Copyright © 2020. Pixlee. All rights reserved.
//

import UIKit

public struct PXLAnalyticsEventLoadMoreClicked: PXLAnalyticsEvent {
    let album: PXLAlbum

    public var eventName = "loadMore"
    
    public init(album:PXLAlbum){
        self.album = album
    }

    public var logParameters: [String: Any] {
        let udid = UIDevice.current.identifierForVendor?.uuidString ?? "Unknown udid"

        var parameters: [String: Any] = [
            "page": album.lastPageFetched,
            "per_page": album.perPage,
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

        return parameters
    }
}
