//
//  PXLAlbumViewModel.swift
//  Example
//
//  Created by Csaba Toth on 2020. 01. 17..
//  Copyright © 2020. Pixlee. All rights reserved.
//

import Foundation
import pixlee_api
struct PXLAlbumViewModel {
    var album: PXLAlbum

    var photos: [PXLPhoto] {
        album.photos
    }

    func loadMore() {
        _ = PXLAnalyitcsService.sharedAnalyitcs.logEvent(event: PXLAnalyticsEventLoadMoreClicked(album: album)) { error in
            if let error = error {
                print("🛑 Error during analyitcs call:\(error)")
            }
        }
    }

    func openedWidget(_ widget: String) {
        _ = PXLAnalyitcsService.sharedAnalyitcs.logEvent(event: PXLAnalyticsEventOpenedWidget(album: album, widget: widget)) { error in
            if let error = error {
                print("🛑 Error during analyitcs call:\(error)")
            }
        }
    }
}
