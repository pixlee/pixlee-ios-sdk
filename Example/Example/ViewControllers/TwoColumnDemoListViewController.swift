//
//  MultipleColumnDemoListViewController.swift
//  Example
//
//  Created by Csaba Toth on 2020. 10. 11..
//  Copyright © 2020. Pixlee. All rights reserved.
//
import PixleeSDK
import UIKit

class TwoColumnDemoListViewController: UIViewController {
    static func getInstance(_ list: [PXLPhoto]) -> TwoColumnDemoListViewController {
        let vc = TwoColumnDemoListViewController(nibName: "EmptyViewController", bundle: Bundle.main)
        vc.photos = list
        return vc
    }
    
    public var photos = [PXLPhoto]() {
        didSet {
            gridView.items = photos
        }
    }

    var gridView = PXLGridView()
    override func viewDidLoad() {
        super.viewDidLoad()
        gridView.delegate = self
        view.addSubview(gridView)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gridView.frame = CGRect(x: 8, y: 8, width: view.frame.size.width - 16, height: view.frame.size.height - 8)
        
    }

    /*
     // MARK: - Navigation

     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         // Get the new view controller using segue.destination.
         // Pass the selected object to the new view controller.
     }
     */
    var videoCell: PXLGridViewCell? {
        didSet {
//            guard let videoCell = videoCell else { return }
//            Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { _ in
//                videoCell.stopVideo()
//                Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { _ in
//                    videoCell.playVideo(muted: self.isVideoMutted())
//                }
//            }
        }
    }
}

extension TwoColumnDemoListViewController: PXLPhotoViewDelegate {
    public func onPhotoButtonClicked(photo: PXLPhoto) {
        print("Action tapped \(photo.id)")
    }

    public func onPhotoClicked(photo: PXLPhoto) {
        print("Photo Clicked \(photo.id)")
    }
}

extension TwoColumnDemoListViewController: PXLGridViewDelegate {
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
