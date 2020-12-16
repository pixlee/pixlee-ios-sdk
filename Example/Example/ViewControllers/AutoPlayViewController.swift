//
//  AutoPlayViewController.swift
//  Example
//
//  Created by Sungjun Hong on 12/16/20.
//  Copyright © 2020 Pixlee. All rights reserved.
//

import PixleeSDK
import UIKit

class AutoPlayViewController: UIViewController {
    static func getInstance(_ list: [PXLPhoto]) -> AutoPlayViewController {
        let vc = AutoPlayViewController(nibName: "EmptyViewController", bundle: Bundle.main)
        vc.photos = list
        return vc
    }
    
    public var photos = [PXLPhoto]() {
        didSet {
            photoView.items = photos
        }
    }
    
    var photoView = PXLGridView()
    override func viewDidLoad() {
        super.viewDidLoad()
        photoView.delegate = self
        view.addSubview(photoView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        photoView.frame = CGRect(x: 8, y: 8, width: view.frame.size.width - 16, height: view.frame.size.height - 8)
        
    }
}

extension AutoPlayViewController: PXLPhotoViewDelegate {
    public func onPhotoButtonClicked(photo: PXLPhoto) {
        print("Action tapped \(photo.id)")
    }
    
    public func onPhotoClicked(photo: PXLPhoto) {
        print("Photo Clicked \(photo.id)")
    }
}

extension AutoPlayViewController: PXLGridViewDelegate {
    func isVideoMutted() -> Bool {
        false
    }
    
    func cellsHighlighted(cells: [PXLGridViewCell]) {
        //        print("Highlighted cells: \(cells)")
    }
    
    func setupPhotoCell(cell: PXLGridViewCell, photo: PXLPhoto) {
        if let index = photos.firstIndex(of: photo) {
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
        return true
    }
    
    func isInfiniteScrollEnabled() -> Bool {
        return false
    }
}

