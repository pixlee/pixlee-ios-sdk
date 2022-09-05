//
//  PXLAlbumViewModel.swift
//  Example
//
//  Created by Csaba Toth on 2020. 01. 17..
//  Copyright © 2020. Pixlee. All rights reserved.
//

import Foundation
public struct PXLAlbumViewModel {
    public var album: PXLAlbum

    public var photos: [PXLPhoto] {
        album.photos
    }

    public init(album: PXLAlbum) {
        self.album = album
    }

    func loadMore() {
        album.triggerEventLoadMoreTapped(completionHandler: { error in
            if let error = error {
                print("🛑 Error during analytics call:\(error)")
            }
            print("Logged")
        })
    }

    func openedWidget(_ widget: PXLWidgetType) {
        album.triggerEventOpenedWidget(widget: widget, completionHandler: { error in
            if let error = error {
                print("🛑 Error during analytics call:\(error)")
            }
        })
    }
}
