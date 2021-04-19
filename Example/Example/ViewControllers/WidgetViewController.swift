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

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        widgetView.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height)
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

extension WidgetViewController: PXLWidgetViewDelegate {
    func setWidgetSpec() -> WidgetSpec {
        WidgetSpec.grid(WidgetSpec.Grid(cellHeight: 350, header: nil, cellPadding: 4))
    }

    func setWidgetType() -> String {
        "replace_this_with_yours"
    }

    func setPXLAlbum() -> PXLAlbum {
        if let pixleeCredentials = try? PixleeCredentials.create() {
            let albumId = pixleeCredentials.albumId
            let album = PXLAlbum(identifier: albumId)
            var filterOptions = PXLAlbumFilterOptions(contentType: ["video", "image"])
            album.filterOptions = filterOptions
            album.sortOptions = PXLAlbumSortOptions(sortType: .approvedTime, ascending: false)
            return album
        }
        fatalError("no album set")
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
}
