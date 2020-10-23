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
    @IBOutlet var versionLabel: UILabel!

    var photos: [PXLPhoto] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        if let ver = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String, let buildNumber = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
            versionLabel.text = "\(ver) (\(buildNumber))"
        }

        // Where to get Pixlee API credentials? visit here: https://app.pixlee.com/app#settings/pixlee_api
        //        #warning  Environment Variables, replace with your Pixlee API key.
        PXLClient.sharedClient.apiKey = ProcessInfo.processInfo.environment["PIXLEE_API_KEY"]
        //        #warning In Environment Variables, replace with your Secret Key if you are making POST requests.
        PXLClient.sharedClient.secretKey = ProcessInfo.processInfo.environment["PIXLEE_SECRET_KEY"]

        //        let dateString = "20190101"
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyyMMdd"
//        let date = dateFormatter.date(from: dateString)

//        var filterOptions = PXLAlbumFilterOptions(minInstagramFollowers: 1, contentSource: [PXLContentSource.instagram_feed, PXLContentSource.instagram_story])
//        album.filterOptions = filterOptions

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

        _ = PXLClient.sharedClient.loadNextPageOfPhotosForAlbum(album: album) { photos, _ in
            if let photos = photos {
                self.photos = photos
            }
        }

        _ = PXLAnalyticsService.sharedAnalytics.logEvent(event: PXLAnalyticsEventOpenedWidget(album: album, widget: .other(customValue: "customWidgetName"))) { _ in
            print("Example opened analytics logged")
        }
    }

    func getSamplePhotos() -> [PXLPhoto] {
        guard album.photos.count < 4 else {
            return album.photos
        }
        guard photos.count < 4 else {
            return photos
        }

        _ = PXLClient.sharedClient.loadNextPageOfPhotosForAlbum(album: album) { photos, _ in
            if let photos = photos {
                self.photos = photos
            }
        }
        return [PXLPhoto]()
    }

    override func viewDidAppear(_ animated: Bool) {
    }

    @IBAction func loadAlbum(_ sender: Any) {
        let albumVC = PXLAlbumViewController.viewControllerForAlbum(album: album)
        present(albumVC, animated: true, completion: nil)
    }

    @IBAction func showListWithGifURL(_ sender: Any) {
        let listVC = ListWithTitleViewController(nibName: "ListWithTitleViewController", bundle: Bundle.main)

        let photos = getSamplePhotos()
        listVC.photos = [photos[0], photos[1], photos[2]]
        listVC.titleGifURL = "https://media.giphy.com/media/dzaUX7CAG0Ihi/giphy.gif"

        present(listVC, animated: true, completion: nil)
    }

    @IBAction func showListWithGif(_ sender: Any) {
        let listVC = ListWithTitleViewController(nibName: "ListWithTitleViewController", bundle: Bundle.main)

        let photos = getSamplePhotos()
        listVC.photos = [photos[0], photos[1], photos[2]]
        listVC.titleGifName = "wavingBear"

        present(listVC, animated: true, completion: nil)
    }

    @IBAction func showListWithTitle(_ sender: Any) {
        let listVC = ListWithTitleViewController(nibName: "ListWithTitleViewController", bundle: Bundle.main)

        let photos = getSamplePhotos()
        listVC.photos = [photos[0], photos[1], photos[2]]
        listVC.listTitle = "Photo list title"

        present(listVC, animated: true, completion: nil)
    }

    @IBAction func loadPhotoList(_ sender: Any) {
        let listVC = SingleColumnViewController(nibName: "SingleColumnViewController", bundle: Bundle.main)

        let photos = getSamplePhotos()
        if photos.count >= 4 {
            listVC.photos = [photos[0], photos[1], photos[2], photos[3]]
        }

        present(listVC, animated: true, completion: nil)
    }

    @IBAction func loadVideoList(_ sender: Any) {
        let listVC = MultipleColumnDemoListViewController(nibName: "MultipleColumnDemoListViewController", bundle: Bundle.main)
        let photos = getSamplePhotos()
        listVC.photos = [photos[0], photos[1], photos[2], photos[3]]
        present(listVC, animated: true, completion: nil)
    }

    @IBAction func loadPhotoProductsView(_ sender: Any) {
        let listVC = PhotoProductListDemoViewController(nibName: "PhotoProductListDemoViewController", bundle: Bundle.main)
        let photos = getSamplePhotos()
        listVC.photos = [photos[0], photos[1], photos[2], photos[3]]

        present(listVC, animated: true, completion: nil)
    }

    @IBAction func showAnalytics(_ sender: Any) {
        let analyticsVC = AnalyticsViewController(nibName: "AnalyticsViewController", bundle: Bundle.main)
        present(analyticsVC, animated: true, completion: nil)
    }
}
