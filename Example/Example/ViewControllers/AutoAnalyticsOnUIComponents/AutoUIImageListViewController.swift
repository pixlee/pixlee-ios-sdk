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
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    var lable:UILabel?
    var pixleeCredentials:PixleeCredentials = PixleeCredentials()
    var album: PXLAlbum?
    
    var pxlGridView = PXLGridView()
    override func viewDidLoad() {
        super.viewDidLoad()
        pxlGridView.delegate = self
        view.addSubview(pxlGridView)
        
        lable = UILabel()
        if let lable = lable{
            lable.accessibilityIdentifier = PXLAnalyticsService.TAG
            lable.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            lable.textColor = UIColor.white
            view.addSubview(lable)
            
            if let simulatorName = ProcessInfo.processInfo.environment["SIMULATOR_DEVICE_NAME"] {
                print("Running on \(simulatorName) simulator")
            } else {
                print("Running on device")
            }

            
            if ProcessInfo.processInfo.arguments.contains("IS_UI_TESTING"){
                lable.alpha = 1 // show test label
            } else {
                lable.alpha = 1 // hide test label
            }
        }
        
        initAlbum()
        enableAutoAnalytics()
        monitorAnalyticsForUITests()
        loadPhotos()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        pxlGridView.frame = CGRect(x: 8, y: 8, width: view.frame.size.width - 16, height: view.frame.size.height - 8)
        if let lable = lable{
            lable.frame = CGRect(x:0, y: view.frame.size.height - 100, width: view.frame.size.width, height: 100)
        }
    }
    
    func initAlbum() {
        do {
            try pixleeCredentials = PixleeCredentials.create()
        } catch {
            self.showPopup(message: error.localizedDescription)
        }
        
        if let albumId = pixleeCredentials.albumId {
            album = PXLAlbum(identifier: albumId)
        }
        
        if let album = album {
            var filterOptions = PXLAlbumFilterOptions(contentType: ["video", "image"], hasProduct: true)
            album.filterOptions = filterOptions
            album.sortOptions = PXLAlbumSortOptions(sortType: .approvedTime, ascending: false)
        }
    }
    
    func enableAutoAnalytics() {
        // to use this feature you need to declare PXLGridViewAutoAnalyticsDelegate to let the SDK know about album:PXLAlbum and widgetType:String. There is example codes for PXLGridViewAutoAnalyticsDelegate in this file below
        // this will delegate the SDK to read your PXLGridViewAutoAnalyticsDelegate implementation.
        pxlGridView.autoAnalyticsDelegate = self
    }
    
    
    // for UI Tests: start capturing notifications of all succeeded analytics APIs
    func monitorAnalyticsForUITests() {
        NotificationCenter.default.addObserver(self, selector: #selector(listenAnalytics), name: NSNotification.Name(rawValue: PXLAnalyticsService.TAG), object: nil)
    }
    
    var analyticsStrings = [String]()
    
    // for UI Tests: receive succeeded analytics API one at a time
    @objc func listenAnalytics(_ noti: Notification) {
        if let name:String = noti.object as? String{
            self.analyticsStrings.append(name)
            self.lable?.text = self.analyticsStrings.joined(separator: ",")
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

extension AutoUIImageListViewController: PXLGridViewAutoAnalyticsDelegate {
    func setupAlbumForAutoAnalytics() -> (album: PXLAlbum, widgetType: String)? {
        if let album = album {
            return (album, "customized_widget_type")
        }else{
            return nil
        }
    }
}

extension AutoUIImageListViewController: PXLPhotoViewDelegate {
    public func onPhotoButtonClicked(photo: PXLPhoto) {
        print("Action tapped \(photo.id)")
        openPDP(photo: photo)
    }
    
    public func onPhotoClicked(photo: PXLPhoto) {
        print("Photo Clicked \(photo.id)")
        openPDP(photo: photo)
    }
    
    func openPDP(photo: PXLPhoto) {
        present(PhotoProductListDemoViewController.getInstance(photo), animated: false, completion: nil)
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
            cell.setupCell(photo: photo, title: "[album photo id: \(photo.albumPhotoId)]\n[album id: \(photo.albumId)] in", subtitle: "Click to Open", buttonTitle: "PXLPhotoProductView", configuration: PXLPhotoViewConfiguration(enableVideoPlayback: true, cropMode: .centerFit), delegate: self)
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
        // This is an example of how to load more photos as you swipe up to go to the bottom of the scroll. You can use our own way of doing this.
        if scrollView == pxlGridView.collectionView && !pxlGridView.items.isEmpty {
            let unseenHeight = scrollView.contentSize.height - (scrollView.contentOffset.y + scrollView.frame.height)
            // this [single page's height * singlePageRatio] pixels of the remaining scrollable height is used for smooth scroll while retrieving photos from the server.
            let singlePageRatio = CGFloat(2.0)
            if unseenHeight < (scrollView.frame.height * singlePageRatio) {
                loadPhotos()
            }
        }
    }
}
