//
//  GetPhotoViewController.swift
//  Example
//
//  Created by Sungjun Hong on 12/16/20.
//  Copyright © 2020 Pixlee. All rights reserved.
//

import Foundation
import PixleeSDK
import UIKit

class GetPhotoViewController: UIViewController {
    static func getInstance() -> GetPhotoViewController {
        return GetPhotoViewController(nibName: "EmptyViewController", bundle: Bundle.main)
    }
    
    var pixleeCredentials:PixleeCredentials = PixleeCredentials()
    var album: PXLAlbum?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initAlbum()
        loadPhotos()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
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
            PXLClient.sharedClient.loadNextPageOfPhotosForAlbum(album: album) { photos, _ in
                if let photos = photos {
                    if let albumPhotoId = photos.shuffled().first?.albumPhotoId {
                        print("-----albumPhotoId: \(albumPhotoId)")
                        // alternative: PXLClient.sharedClient.getPhotoWithPhotoAlbumIdAndRegionId(photoAlbumId: String(albumPhotoId), regionId: album.regionId) { (pxlPhoto, error) in
                        PXLClient.sharedClient.getPhotoWithPhotoAlbumIdAndRegionId(photoAlbumId: String(albumPhotoId)) { (pxlPhoto, error) in
                            if let pxlPhoto = pxlPhoto {
                                print("a photo loaded, albumPhotoId: \(pxlPhoto.albumPhotoId)")
                                let widget = PXLPhotoProductView.widgetForPhoto(photo: pxlPhoto, cropMode: .centerFit, showHotspots: true, delegate: self, cellConfiguration: PXLProductCellConfiguration(bookmarkOnImage: nil, bookmarkOffImage: nil))
                                
                                widget.closeButtonBackgroundColor = .white
                                widget.closeButtonCornerRadius = 22
                                widget.closeButtonTintColor = UIColor.red.withAlphaComponent(0.6)

                                widget.muteButtonBackgroundColor = .white
                                widget.muteButtonTintColor = UIColor.red.withAlphaComponent(0.6)
                                
                                self.view.addSubview(widget.view)

                                widget.view.translatesAutoresizingMaskIntoConstraints = false
                                let constraints = [
                                    widget.view.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 1),
                                    widget.view.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: 0),
                                ]
                                NSLayoutConstraint.activate(constraints)
                            }
                        
                        }
                    }
                    
                    
                }
            }
        }
    }
    
}

// MARK: - PXLPhotoProductDelegate
extension GetPhotoViewController: PXLPhotoProductDelegate {
    public func onProductsLoaded(products: [PXLProduct]) -> [Int: Bool] {
        var bookmarks = [Int: Bool]()
        products.forEach { product in
            bookmarks[product.identifier] = true
        }
        return bookmarks
    }
    
    public func onBookmarkClicked(product: PXLProduct, isSelected: Bool) {
        print("Pruduct: \(product.identifier) is selected: \(isSelected)")
    }
    
    public func shouldOpenURL(url: URL) -> Bool {
        print("url: \(url)")
        return false
    }
    
    public func onProductClicked(product: PXLProduct) {
        print("Pruduct: \(product.identifier) clicked")
    }
}
