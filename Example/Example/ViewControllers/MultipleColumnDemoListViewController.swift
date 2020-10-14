//
//  MultipleColumnDemoListViewController.swift
//  Example
//
//  Created by Csaba Toth on 2020. 10. 11..
//  Copyright © 2020. Pixlee. All rights reserved.
//
import PixleeSDK
import UIKit

class MultipleColumnDemoListViewController: UIViewController {
    public var photos = [PXLPhoto]() {
        didSet {
            gridView.items = photos
        }
    }

    var gridView = PXLGridView()
    override func viewDidLoad() {
        super.viewDidLoad()

        gridView.frame = CGRect(x: 8, y: 8, width: view.frame.size.width - 16, height: view.frame.size.height - 8)
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
}

extension MultipleColumnDemoListViewController: PXLPhotoViewDelegate {
    public func onPhotoButtonClicked(photo: PXLPhoto) {
        print("Action tapped \(photo.id)")
    }

    public func onPhotoClicked(photo: PXLPhoto) {
        print("Photo Clicked \(photo.id)")
    }
}

extension MultipleColumnDemoListViewController: PXLGridViewDelegate {
    func setupPhotoCell(cell: PXLGridViewCell, photo: PXLPhoto) {
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
        return true
    }
}
