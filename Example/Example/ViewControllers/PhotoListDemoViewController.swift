//
//  PhotoListDemoViewController.swift
//  Example
//
//  Created by Csaba Toth on 2020. 09. 21..
//  Copyright © 2020. Pixlee. All rights reserved.
//

import PixleeSDK
import UIKit

class PhotoListDemoViewController: UIViewController {
    public var photos = [PXLPhoto]() {
        didSet {
            photoView.items = photos
        }
    }

    var photoView = PXLPhotoListView()
    override func viewDidLoad() {
        super.viewDidLoad()

        photoView.delegate = self
        photoView.frame = view.frame
        view.addSubview(photoView)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        photoView.frame = view.frame
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

extension PhotoListDemoViewController: PXLPhotoViewDelegate {
    public func onPhotoButtonClicked(photo: PXLPhoto) {
        print("Action tapped \(photo.id)")
    }

    public func onPhotoClicked(photo: PXLPhoto) {
        print("Photo Clicked \(photo.id)")
    }
}

extension PhotoListDemoViewController: PXLPhotoListViewDelegate {
    public func setupPhotoCell(cell: PXLPhotoListViewCell, photo: PXLPhoto) {
        cell.setupCell(photo: photo, title: "Title", subtitle: "subtitle", buttonTitle: "Button", configuration: PXLPhotoViewConfiguration(cropMode: .centerFill), delegate: self)
    }

    public func cellHeight() -> CGFloat {
        return 350
    }
}
