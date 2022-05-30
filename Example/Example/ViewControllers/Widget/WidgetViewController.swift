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
    var label:UILabel?
    var analyticsStrings = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        widgetView.delegate = self
        view.addSubview(widgetView)
        
        label = UILabel()
        if let label = label{
            label.accessibilityIdentifier = PXLAnalyticsService.TAG
            label.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            label.lineBreakMode = .byWordWrapping
            label.numberOfLines = 0
            label.textColor = UIColor.white
            label.text = "no events yet"
            view.addSubview(label)
            
            if let simulatorName = ProcessInfo.processInfo.environment["SIMULATOR_DEVICE_NAME"] {
                print("Running on \(simulatorName) simulator")
            } else {
                print("Running on device")
            }
            
            
            if ProcessInfo.processInfo.arguments.contains("IS_UI_TESTING"){
                label.alpha = 1 // show test label
            } else {
                label.alpha = 0 // hide test label. If you want to see the events in the demo, make it label.alpha = 1.
            }
        }

        monitorAnalyticsForUITests()
        initAlbum()
    }
    
    func initAlbum() {
        if let pixleeCredentials = try? PixleeCredentials.create() {
            let albumId = pixleeCredentials.albumId
            let album = PXLAlbum(identifier: albumId)
            album.filterOptions = PXLAlbumFilterOptions(hasPermission: true)
            album.sortOptions = PXLAlbumSortOptions(sortType: .approvedTime, ascending: false)
            album.perPage = 18
            widgetView.searchingAlbum = album
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let widgetViewHeight:CGFloat = {
            if ProcessInfo.processInfo.arguments.contains("UI_TESTING_HORIZONTAL_WIDGET") {
                return view.frame.size.height / CGFloat(5)
            } else {
                return view.frame.size.height
            }
        }()
        widgetView.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: widgetViewHeight)
        
        if let lable = label{
            lable.frame = CGRect(x:0, y: view.frame.size.height - 100, width: view.frame.size.width, height: 100)
        }
    }

    // for UI Tests: start capturing notifications of all succeeded analytics APIs
    func monitorAnalyticsForUITests() {
        NotificationCenter.default.addObserver(self, selector: #selector(listenAnalytics), name: NSNotification.Name(rawValue: PXLAnalyticsService.TAG), object: nil)
    }
    
    @objc func listenAnalytics(_ noti: Notification) {
        if let name:String = noti.object as? String{
            self.analyticsStrings.append(name)
            self.label?.text = self.analyticsStrings.joined(separator: " ,")
        }
    }
    
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
        
        {
            if ProcessInfo.processInfo.arguments.contains("UI_TESTING_LIST_WIDGET") {
                // An example of List
                return WidgetSpec.list(.init(cellHeight: 350,
                                      isVideoMutted: true,
                                      autoVideoPlayEnabled: true,
                                      loadMore: .init(cellHeight: 100.0,
                                                      cellPadding: 10.0,
                                                      text: "LoadMore",
                                                      textColor: UIColor.darkGray,
                                                      textFont: UIFont.systemFont(ofSize: UIFont.buttonFontSize),
                                                      loadingStyle: .gray)))
            } else if ProcessInfo.processInfo.arguments.contains("UI_TESTING_GRID_WIDGET") {
                // An example of Grid
                return WidgetSpec.grid(
                                .init(
                                        cellHeight: 350,
                                        cellPadding: 4,
                                        loadMore: .init(cellHeight: 100.0,
                                                cellPadding: 10.0,
                                                text: "LoadMore",
                                                textColor: UIColor.darkGray,
                                                textFont: UIFont.systemFont(ofSize: UIFont.buttonFontSize),
                                                loadingStyle: .gray),
                                        header: .image(.remotePath(.init(headerHeight: 200,
                                                headerContentMode: .scaleAspectFill,
                                                headerGifUrl: "https://media0.giphy.com/media/CxQw7Rc4Fx4OBNBLa8/giphy.webp")))))
            } else if ProcessInfo.processInfo.arguments.contains("UI_TESTING_HORIZONTAL_WIDGET") {
                // An example of Horizontal
                return WidgetSpec.horizontal(
                    .init(
                        cellPadding: 1,
                        loadMore: .init(cellHeight: 100.0,
                                        cellPadding: 10.0,
                                        text: "LoadMore",
                                        textColor: UIColor.darkGray,
                                        textFont: UIFont.systemFont(ofSize: UIFont.buttonFontSize),
                                        loadingStyle: .gray)))
            } else if ProcessInfo.processInfo.arguments.contains("UI_TESTING_3SPANS_MOSAIC_WIDGET") {
                return WidgetSpec.mosaic(
                    .init(
                        mosaicSpan: .three,
                        cellPadding: 1,
                        loadMore: .init(cellHeight: 100.0,
                                        cellPadding: 10.0,
                                        text: "LoadMore",
                                        textColor: UIColor.darkGray,
                                        textFont: UIFont.systemFont(ofSize: UIFont.buttonFontSize),
                                        loadingStyle: .gray)))
            } else if ProcessInfo.processInfo.arguments.contains("UI_TESTING_4SPANS_MOSAIC_WIDGET") {
                return WidgetSpec.mosaic(
                    .init(
                        mosaicSpan: .four,
                        cellPadding: 1,
                        loadMore: .init(cellHeight: 100.0,
                                        cellPadding: 10.0,
                                        text: "LoadMore",
                                        textColor: UIColor.darkGray,
                                        textFont: UIFont.systemFont(ofSize: UIFont.buttonFontSize),
                                        loadingStyle: .gray)))
            } else {
                return WidgetSpec.mosaic(
                    .init(
                        mosaicSpan: .five,
                        cellPadding: 1,
                        loadMore: .init(cellHeight: 100.0,
                                        cellPadding: 10.0,
                                        text: "LoadMore",
                                        textColor: UIColor.darkGray,
                                        textFont: UIFont.systemFont(ofSize: UIFont.buttonFontSize),
                                        loadingStyle: .gray)))
            
            }
        }()

    }

    func setWidgetType() -> String {
        "replace_this_with_yours"
    }

    func setupPhotoCell(cell: PXLGridViewCell, photo: PXLPhoto) {
        // Example(all elements) : cell.setupCell(photo: photo, title: "Title", subtitle: "subtitle", buttonTitle: "Button", configuration: PXLPhotoViewConfiguration(cropMode: .centerFill), delegate: self)

//        cell.setupCell(photo: photo, title: "\(photo.id)", subtitle: "\(photo.id)", buttonTitle: "\(photo.id)", configuration: PXLPhotoViewConfiguration(cropMode: .centerFill), delegate: self)
        
        let buttonTitle: String? = {
            if ProcessInfo.processInfo.arguments.contains("IS_UI_TESTING") {
                return "Detail"
            } else {
                return nil
            }
        }()
        
        cell.setupCell(photo: photo, title: nil, subtitle: nil, buttonTitle: buttonTitle, configuration: PXLPhotoViewConfiguration(cropMode: .centerFill), delegate: self)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
         print("scrollViewDidScroll \(scrollView)")
    }
}
