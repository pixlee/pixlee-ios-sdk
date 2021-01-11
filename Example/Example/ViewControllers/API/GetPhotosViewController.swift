//
//  GetPhotosViewController.swift
//  Example
//
//  Created by Sungjun Hong on 12/16/20.
//  Copyright © 2020 Pixlee. All rights reserved.
//

import Foundation
import PixleeSDK
import UIKit

class GetPhotosViewController: UIViewController {
    static func getInstance() -> GetPhotosViewController {
        return GetPhotosViewController(nibName: "EmptyViewController", bundle: Bundle.main)
    }
    
    var pixleeCredentials:PixleeCredentials = PixleeCredentials()
    var album: PXLAlbum?
    
    var pxlGridView = PXLGridView()
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        pxlGridView.frame = CGRect(x: 8, y: 8, width: view.frame.size.width - 16, height: view.frame.size.height - 8)
        pxlGridView.delegate = self
        view.addSubview(pxlGridView)
        
        initAlbum()
        loadPhotos()
    }
    
    func initAlbum(){
        do {
            try pixleeCredentials = PixleeCredentials.create()
        } catch{
            self.showPopup(message: error.localizedDescription)
        }
        
        //        let dateString = "20190101"
        //        let dateFormatter = DateFormatter()
        //        dateFormatter.dateFormat = "yyyyMMdd"
        //        let date = dateFormatter.date(from: dateString)
        
        //        var filterOptions = PXLAlbumFilterOptions(minInstagramFollowers: 1, contentSource: [PXLContentSource.instagram_feed, PXLContentSource.instagram_story])
        //        album.filterOptions = filterOptions
        
        if let albumId = pixleeCredentials.albumId {
            album = PXLAlbum(identifier: albumId)
        }
        
        if let album = album {
            var filterOptions = PXLAlbumFilterOptions(contentType: ["video", "image"])
            
            album.filterOptions = filterOptions
            
            album.sortOptions = PXLAlbumSortOptions(sortType: .approvedTime, ascending: false)
        }
    }

    
    func loadPhotos(){
        if let album = album {
            _ = PXLClient.sharedClient.loadNextPageOfPhotosForAlbum(album: album) { photos, _ in
                if let photos = photos {
                    //self.photos = photos
                    self.pxlGridView.items = photos
                }
            }
        }
    }

}

extension GetPhotosViewController: PXLPhotoViewDelegate {
    public func onPhotoButtonClicked(photo: PXLPhoto) {
        print("Action tapped \(photo.id)")
    }
    
    public func onPhotoClicked(photo: PXLPhoto) {
        print("Photo Clicked \(photo.id)")
    }
}

extension GetPhotosViewController: PXLGridViewDelegate {
    func isVideoMutted() -> Bool {
        false
    }
    
    func cellsHighlighted(cells: [PXLGridViewCell]) {
        //        print("Highlighted cells: \(cells)")
    }
    
    func setupPhotoCell(cell: PXLGridViewCell, photo: PXLPhoto) {
        if let index = pxlGridView.items.firstIndex(of: photo) {
            cell.setupCell(photo: photo, title: photo.title ?? "Photo title", subtitle: "Subtitle for \(photo.id)", buttonTitle: "Item #\(index)", configuration: PXLPhotoViewConfiguration(enableVideoPlayback: true, cropMode: .centerFit), delegate: self)
        }
    }
    
    public func cellHeight() -> CGFloat {
        return 350
    }
    
    func cellPadding() -> CGFloat {
        return 8
    }
    
    func isMultipleColumnEnabled() -> Bool {
        return false
    }
    
    func isHighlightingEnabled() -> Bool {
        return false
    }
    
    func isInfiniteScrollEnabled() -> Bool {
        return false
    }
}
