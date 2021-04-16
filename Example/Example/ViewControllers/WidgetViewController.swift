//
//  WidgetViewController.swift
//  Example
//
//  Created by Sungjun Hong on 4/16/21.
//  Copyright © 2021 Pixlee. All rights reserved.
//

import Foundation
import PixleeSDK
import UIKit
class WidgetViewController: UIViewController {
    static func getInstance() -> WidgetViewController {
        let vc = WidgetViewController(nibName: "EmptyViewController", bundle: Bundle.main)
        return vc
    }
    
    var widgetView = PXLWidgetView()
    override func viewDidLoad() {
        super.viewDidLoad()
        widgetView.delegate = self
        view.addSubview(widgetView)
        
        do {
            let pixleeCredentials = try PixleeCredentials.create()
            if let albumId = pixleeCredentials.albumId {
                let album = PXLAlbum(identifier: albumId)
                var filterOptions = PXLAlbumFilterOptions(contentType: ["video", "image"])
                
                album.filterOptions = filterOptions
                
                album.sortOptions = PXLAlbumSortOptions(sortType: .approvedTime, ascending: false)
                widgetView.album = album
            }
        } catch{
            self.showPopup(message: error.localizedDescription)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        widgetView.frame = CGRect(x: 8, y: 8, width: view.frame.size.width - 16, height: view.frame.size.height - 8)
        
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    var videoCell: PXLGridViewCell?
}

extension WidgetViewController: PXLPhotoViewDelegate {
    public func onPhotoButtonClicked(photo: PXLPhoto) {
        print("Action tapped \(photo.id)")
    }
    
    public func onPhotoClicked(photo: PXLPhoto) {
        print("Photo Clicked \(photo.id)")
    }
}

extension WidgetViewController: PXLGridViewDelegate {
    func isVideoMutted() -> Bool {
        false
    }
    
    func cellsHighlighted(cells: [PXLGridViewCell]) {
        //        print("Highlighted cells: \(cells)")
    }
    
    func setupPhotoCell(cell: PXLGridViewCell, photo: PXLPhoto) {
        if photo.isVideo {
            videoCell = cell
        }
        cell.setupCell(photo: photo, title: "Title", subtitle: "subtitle", buttonTitle: "Button", configuration: PXLPhotoViewConfiguration(cropMode: .centerFill), delegate: self)
    }
    
    public func cellHeight() -> CGFloat {
        return 350
    }
    
    func cellPadding() -> CGFloat {
        return 8
    }
    
    func isMultipleColumnEnabled() -> Bool {
        return true
    }
    
    func isHighlightingEnabled() -> Bool {
        return false
    }
    
    func isInfiniteScrollEnabled() -> Bool {
        return false
    }
}
