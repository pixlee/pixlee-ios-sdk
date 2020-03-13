//
//  ViewController.swift
//  Example
//
//  Created by Csaba Toth on 2020. 01. 08..
//  Copyright © 2020. Pixlee. All rights reserved.
//

import PixleeSDK
import UIKit

class ViewController: UIViewController {
    let album = PXLAlbum(identifier: ProcessInfo.processInfo.environment["PIXLEE_ALBUM_ID"])

    override func viewDidLoad() {
        super.viewDidLoad()
        // Where to get Pixlee API credentials? visit here: https://app.pixlee.com/app#settings/pixlee_api
        //        #warning  Environment Variables, replace with your Pixlee API key.
        PXLClient.sharedClient.apiKey = ProcessInfo.processInfo.environment["PIXLEE_API_KEY"]
        //        #warning In Environment Variables, replace with your Secret Key if you are making POST requests.
        PXLClient.sharedClient.secretKey = ProcessInfo.processInfo.environment["PIXLEE_SECRET_KEY"]

        var filterOptions = PXLAlbumFilterOptions(minInstagramFollowers: 1, contentSource: [PXLContentSource.instagram_feed])
//        let dateString = "20190101"
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyyMMdd"
//        let date = dateFormatter.date(from: dateString)
//
//        filterOptions = filterOptions.changeSubmittedDateStart(newSubmittedDateStart: date)
//
//        PXLAlbumFilterOptions(submittedDateStart: date)
        album.filterOptions = filterOptions
        album.sortOptions = PXLAlbumSortOptions(sortType: .popularity, ascending: false)

        // Where to get an albumId Pixlee? Visit here: https://app.pixlee.com/app#albums
        // Get one photo example
        var photoAlbumId = ProcessInfo.processInfo.environment["PIXLEE_PHOTO_ALBUM_ID"]
        if let photoAlbumId = photoAlbumId {
            _ = PXLClient.sharedClient.getPhotoWithPhotoAlbumId(photoAlbumId: photoAlbumId) { newPhoto, error in
                guard error == nil else {
                    print("Error during load of image with Id \(String(describing: error))")
                    return
                }
                guard let photo = newPhoto else {
                    print("cannot find photo")
                    return
                }
                print("New Photo: \(photo.albumPhotoId)")

                _ = photo.triggerEventOpenedLightbox { _ in
                    print("Opened lightbox logged")
                }
                _ = photo.triggerEventActionClicked(actionLink: "actionLink", completionHandler: { _ in
                    print("Action link click logged")
                })
            }
        }

        _ = PXLAnalyticsService.sharedAnalytics.logEvent(event: PXLAnalyticsEventOpenedWidget(album: album, widget: .other(customValue: "customWidgetName"))) { _ in
            print("Example opened analytics logged")
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        let albumVC = PXLAlbumViewController.viewControllerForAlbum(album: album)
        showViewController(VC: albumVC)
    }

    func showViewController(VC: UIViewController) {
        VC.willMove(toParent: self)
        addChild(VC)
        VC.view.frame = view.bounds
        view.addSubview(VC.view)
        VC.didMove(toParent: self)
    }
}
