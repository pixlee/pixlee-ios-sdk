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

class AutoUIImageListViewController: UIViewController {
    static func getInstance() -> AutoUIImageListViewController {
        return AutoUIImageListViewController(nibName: "EmptyViewController", bundle: Bundle.main)
    }
    
    var pixleeCredentials:PixleeCredentials = PixleeCredentials()
    var album: PXLAlbum?
    
    var pxlGridView = PXLGridView()
    override func viewDidLoad() {
        super.viewDidLoad()
        pxlGridView.delegate = self
        view.addSubview(pxlGridView)
        initAlbum()
        loadPhotos()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        pxlGridView.frame = CGRect(x: 8, y: 8, width: view.frame.size.width - 16, height: view.frame.size.height - 8)
    }
    
    func initAlbum(){
        do {
            try pixleeCredentials = PixleeCredentials.create()
        } catch{
            self.showPopup(message: error.localizedDescription)
        }
        
        if let albumId = pixleeCredentials.albumId {
            album = PXLAlbum(identifier: albumId)
        }
        
        if let album = album {
            var filterOptions = PXLAlbumFilterOptions(contentType: ["video", "image"], deletedPhotos: true)
            album.filterOptions = filterOptions
            album.sortOptions = PXLAlbumSortOptions(sortType: .approvedTime, ascending: false)
        }
    }
    
    var isFreezingNetworking = false
    func loadPhotos() {
        if let album = album {
            if isFreezingNetworking {
                return
            }
            
            isFreezingNetworking = true
            _ = PXLClient.sharedClient.loadNextPageOfPhotosForAlbum(album: album) { photos, error in
                guard error == nil else {
                    self.showPopup(message: "🛑 There was an error \(error?.localizedDescription ?? "")")
                    return
                }
                
                if let photos = photos {
                    self.isFreezingNetworking = false
                    self.pxlGridView.items.append(contentsOf: photos)
                }
            }
        }
    }
}

extension AutoUIImageListViewController: PXLPhotoViewDelegate {
    public func onPhotoButtonClicked(photo: PXLPhoto) {
        print("Action tapped \(photo.id)")
    }
    
    public func onPhotoClicked(photo: PXLPhoto) {
        print("Photo Clicked \(photo.id)")
    }
}

extension AutoUIImageListViewController: PXLGridViewDelegate {
    func isVideoMutted() -> Bool {
        false
    }
    
    func cellsHighlighted(cells: [PXLGridViewCell]) {
        //        print("Highlighted cells: \(cells)")
    }
    
    func setupPhotoCell(cell: PXLGridViewCell, photo: PXLPhoto) {
        if let index = pxlGridView.items.firstIndex(of: photo) {
            cell.setupCell(photo: photo, title: "Main \(photo.id)", subtitle: "Subtitle for \(photo.id)", buttonTitle: "Item #\(index)", configuration: PXLPhotoViewConfiguration(enableVideoPlayback: true, cropMode: .centerFit), delegate: self)
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == pxlGridView.collectionView && !pxlGridView.items.isEmpty {
            let unseenHeight = scrollView.contentSize.height - (scrollView.contentOffset.y + scrollView.frame.height)
            // this [single page's height * singlePageRatio] pixels of the remaining scrollable height is used for smooth scroll while retrieving photos from the server.
            let singlePageRatio = CGFloat(2.0)
            //print("singleH: \(scrollView.frame.height * singlePageRatio), unseenHeight: \(unseenHeight)")
            if unseenHeight < (scrollView.frame.height * singlePageRatio) {
                loadPhotos()
            }
        }
    }
}
