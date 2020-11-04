//
//  SingleColumnViewController.swift
//  Example
//
//  Created by Csaba Toth on 2020. 09. 21..
//  Copyright © 2020. Pixlee. All rights reserved.
//

import PixleeSDK
import UIKit

class SingleColumnViewController: UIViewController {
    public var photos = [PXLPhoto]() {
        didSet {
            photoView.items = photos
        }
    }

    var photoView = PXLGridView()
    override func viewDidLoad() {
        super.viewDidLoad()

        photoView.frame = CGRect(x: 8, y: 8, width: view.frame.size.width - 16, height: view.frame.size.height - 8)
        photoView.delegate = self
        view.addSubview(photoView)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        photoView.frame = CGRect(x: 8, y: 8, width: view.frame.size.width - 16, height: view.frame.size.height - 8)
    }

    /*
     // MARK: - Navigation

     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         // Get the new view controller using segue.destination.
         // Pass the selected object to the new view controller.
     }
     */
}

extension SingleColumnViewController: PXLPhotoViewDelegate {
    public func onPhotoButtonClicked(photo: PXLPhoto) {
        print("Action tapped \(photo.id)")
    }

    public func onPhotoClicked(photo: PXLPhoto) {
        print("Photo Clicked \(photo.id)")
    }
}

extension SingleColumnViewController: PXLGridViewDelegate {
    func cellsHighlighted(cells: [PXLGridViewCell]) {
        print("Highlighted cells: \(cells)")
    }

    func headerGifUrl() -> String? {
        return "https://media.giphy.com/media/dzaUX7CAG0Ihi/giphy.gif"
    }

    func headerGifContentMode() -> UIView.ContentMode {
        .scaleAspectFill
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
