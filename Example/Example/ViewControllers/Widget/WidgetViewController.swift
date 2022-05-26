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

        if let pixleeCredentials = try? PixleeCredentials.create() {
            let albumId = pixleeCredentials.albumId
            let album = PXLAlbum(identifier: albumId)
            album.filterOptions = PXLAlbumFilterOptions()
            album.sortOptions = PXLAlbumSortOptions(sortType: .approvedTime, ascending: false)
            album.perPage = 18
            widgetView.searchingAlbum = album
        }
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

// MARK: - Photo's click-event listeners
extension WidgetViewController: PXLPhotoViewDelegate {
    public func onPhotoButtonClicked(photo: PXLPhoto) {
        print("Action tapped \(photo.id)")
        openPhotoProduct(photo: photo)
    }

    public func onPhotoClicked(photo: PXLPhoto) {
        print("Photo Clicked \(photo.id)")
        openPhotoProduct(photo: photo)
    }

    func openPhotoProduct(photo: PXLPhoto) {
        present(PhotoProductListDemoViewController.getInstance(photo), animated: false, completion: nil)
    }
}

// MARK: Widget's UI settings and scroll events
extension WidgetViewController: PXLWidgetViewDelegate {
    func setWidgetSpec() -> WidgetSpec {
        // An example of List
//        WidgetSpec.list(.init(cellHeight: 350,
//                              isVideoMutted: true,
//                              autoVideoPlayEnabled: true,
//                              loadMore: .init(cellHeight: 100.0,
//                                              cellPadding: 10.0,
//                                              text: "LoadMore",
//                                              textColor: UIColor.darkGray,
//                                              textFont: UIFont.systemFont(ofSize: UIFont.buttonFontSize),
//                                              loadingStyle: .gray)))
        // An example of Grid
//        WidgetSpec.grid(
//                .init(
//                        cellHeight: 350,
//                        cellPadding: 4,
//                        loadMore: .init(cellHeight: 100.0,
//                                cellPadding: 10.0,
//                                text: "LoadMore",
//                                textColor: UIColor.darkGray,
//                                textFont: UIFont.systemFont(ofSize: UIFont.buttonFontSize),
//                                loadingStyle: .gray),
//                        header: .image(.remotePath(.init(headerHeight: 200,
//                                headerContentMode: .scaleAspectFill,
//                                headerGifUrl: "https://media0.giphy.com/media/CxQw7Rc4Fx4OBNBLa8/giphy.webp")))))
        
        // An example of Mosaic
        WidgetSpec.mosaic(
            .init(
                mosaicSpan: .three,
                cellPadding: 1,
                loadMore: .init(cellHeight: 100.0,
                                cellPadding: 10.0,
                                text: "LoadMore",
                                textColor: UIColor.darkGray,
                                textFont: UIFont.systemFont(ofSize: UIFont.buttonFontSize),
                                loadingStyle: .gray)))
        
        // An example of Mosaic
//        WidgetSpec.horizontal(
//            .init(
//                cellPadding: 1,
//                loadMore: .init(cellHeight: 100.0,
//                                cellPadding: 10.0,
//                                text: "LoadMore",
//                                textColor: UIColor.darkGray,
//                                textFont: UIFont.systemFont(ofSize: UIFont.buttonFontSize),
//                                loadingStyle: .gray)))
    }

    func setWidgetType() -> String {
        "replace_this_with_yours"
    }

    func setupPhotoCell(cell: PXLGridViewCell, photo: PXLPhoto) {
        if photo.isVideo {
            videoCell = cell
        }
        // Example(all elements) : cell.setupCell(photo: photo, title: "Title", subtitle: "subtitle", buttonTitle: "Button", configuration: PXLPhotoViewConfiguration(cropMode: .centerFill), delegate: self)

//        cell.setupCell(photo: photo, title: "\(photo.id)", subtitle: "\(photo.id)", buttonTitle: "\(photo.id)", configuration: PXLPhotoViewConfiguration(cropMode: .centerFill), delegate: self)
        cell.setupCell(photo: photo, title: nil, subtitle: nil, buttonTitle: nil, configuration: PXLPhotoViewConfiguration(cropMode: .centerFill), delegate: self)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // print("scrollViewDidScroll \(scrollView)")
    }
}
