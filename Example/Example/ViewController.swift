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
    var pixleeCredentials:PixleeCredentials = PixleeCredentials()
    var album: PXLAlbum?
    @IBOutlet var versionLabel: UILabel!

    var photos: [PXLPhoto] = []
    
    @IBOutlet var uiStackView: UIStackView!
    @IBOutlet var analyticsStackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    func addEmptySpace(to: UIStackView){
        to.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        to.isLayoutMarginsRelativeArrangement = true
        to.layer.cornerRadius = CGFloat(20)
        to.layer.masksToBounds = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        addEmptySpace(to: uiStackView)
        addEmptySpace(to: analyticsStackView)
                
        do {
            try pixleeCredentials = PixleeCredentials.create()
        } catch{
            showPopup(message: error.localizedDescription)
        }
        
        initClient()
        initAlbum()
        loadPhotos()
        //loadPhoto()
        testAnalyticsAPI()
    }


        
    func readCredentials() {
        if let url = Bundle.main.url(forResource:"PixleeCredentials", withExtension: "plist") {
            do {
                let data = try Data(contentsOf:url)
                let swiftDictionary = try PropertyListSerialization.propertyList(from: data, format: nil) as! [String:Any]
                // do something with the dictionary
                pixleeCredentials.apiKey = swiftDictionary["PIXLEE_API_KEY"] as? String
                pixleeCredentials.secretKey = swiftDictionary["PIXLEE_SECRET_KEY"] as? String
                pixleeCredentials.albumId = swiftDictionary["PIXLEE_ALBUM_ID"] as? String
                print("swiftDictionary: \(swiftDictionary)")
                
            } catch {
                let message = "can't read Example/PixleeCredentials.plist \(error)"
                showPopup(message: message)
                print(message)
            }
        }else{
            // todo: show alert
            let message = "can't run the demo. please add Example/PixleeCredentials.plist to this project and run it again"
            showPopup(message: message)
            print(message)
        }
    }
    
    func initClient(){
        if let apiKey = pixleeCredentials.apiKey {
            // Where to get Pixlee API credentials? visit here: https://app.pixlee.com/app#settings/pixlee_api
            //        #warning  Environment Variables, replace with your Pixlee API key.
            PXLClient.sharedClient.apiKey = apiKey
        }
        
        if let secretKey = pixleeCredentials.secretKey {
            //        #warning In Environment Variables, replace with your Secret Key if you are making POST requests.
            PXLClient.sharedClient.secretKey = secretKey
        }
    }
    
    func initAlbum(){
        //        let dateString = "20190101"
        //        let dateFormatter = DateFormatter()
        //        dateFormatter.dateFormat = "yyyyMMdd"
        //        let date = dateFormatter.date(from: dateString)
        
        //        var filterOptions = PXLAlbumFilterOptions(minInstagramFollowers: 1, contentSource: [PXLContentSource.instagram_feed, PXLContentSource.instagram_story])
        //        album.filterOptions = filterOptions
        
        if let albumId = pixleeCredentials.albumId {
            album = PXLAlbum(identifier: albumId)
        }
        
        if let album = album {
            let filterOptions = PXLAlbumFilterOptions(contentType: ["video"])
            album.filterOptions = filterOptions
            
            album.sortOptions = PXLAlbumSortOptions(sortType: .approvedTime, ascending: false)
        }
        
        
        // this is for multi-region products. if you don't have a set of region ids, please reach out your account manager to get it
        // album.regionId = 2469
    }
    
    func loadPhotos(){
        if let album = album {
            _ = PXLClient.sharedClient.loadNextPageOfPhotosForAlbum(album: album) { photos, _ in
                if let photos = photos {
                    self.photos = photos
                }
            }
        }
        
    }
    
    func testAnalyticsAPI(){
        if let album = album {
            _ = PXLAnalyticsService.sharedAnalytics.logEvent(event: PXLAnalyticsEventOpenedWidget(album: album, widget: .other(customValue: "customWidgetName"))) { _ in
                print("Example opened analytics logged")
            }
        }
        
    }
    
//    func loadPhoto(){
//        // Where to get an albumId Pixlee? Visit here: https://app.pixlee.com/app#albums
//        // Get one photo example
//        let photoAlbumId = ProcessInfo.processInfo.environment["PIXLEE_PHOTO_ALBUM_ID"]
//        let regionId: Int = 2469 // add a region id if you have one
//
//        if let photoExample = photoAlbumId {
//            _ = PXLClient.sharedClient.getPhotoWithPhotoAlbumId(photoAlbumId: photoExample) { newPhoto, error in
//                guard error == nil else {
//                    print("Error during load of image with Id \(String(describing: error))")
//                    return
//                }
//                guard let photo = newPhoto else {
//                    print("cannot find photo")
//                    return
//                }
//                print("New Photo: \(photo.albumPhotoId)")
//                _ = photo.triggerEventOpenedLightbox { _ in
//                    print("Opened lightbox logged")
//                }
//                _ = photo.triggerEventActionClicked(actionLink: "actionLink", completionHandler: { _ in
//                    print("Action link click logged")
//                })
//            }
//        }
//    }

    func getSamplePhotos() -> [PXLPhoto]? {
        if let album = album {
//            return [photos[0], photos[1], photos[2], photos[0], photos[1], photos[2], photos[1], photos[0], photos[1], photos[2], photos[2], photos[0], photos[1], photos[2], photos[2], photos[0], photos[1], photos[2], photos[1], photos[0], photos[1], photos[2], photos[2], photos[0], photos[1], photos[2], photos[2], photos[0], photos[1], photos[2], photos[1], photos[0], photos[1], photos[2], photos[1], photos[0], photos[1], photos[2], photos[2], photos[0], photos[1], photos[2], photos[1], photos[0], photos[1], photos[2], photos[2], photos[0], photos[1], photos[2], photos[2], photos[0], photos[1], photos[2], photos[1]]
            
            guard album.photos.count < 1 else {
                return album.photos
            }
            guard photos.count < 1 else {
                return photos
            }
            
            _ = PXLClient.sharedClient.loadNextPageOfPhotosForAlbum(album: album) { photos, _ in
                if let photos = photos {
                    self.photos = photos
                }
            }
            return [PXLPhoto]()
        } else {
            showPopup(message: "no album is loaded")
            return nil
        }
        
    }

    @IBAction func loadAlbum(_ sender: Any) {
        if let album = album {
            present(PXLAlbumViewController.viewControllerForAlbum(album: album), animated: true, completion: nil)
        }
        
    }

    // MARK: - APIs
    
    @IBAction func showAPIGetPhotos(_ sender: Any) {
        present(GetPhotosViewController.getInstance(), animated: true, completion: nil)
    }
    
    @IBAction func showAPIGetPhoto(_ sender: Any) {
        present(GetPhotoViewController.getInstance(), animated: true, completion: nil)
    }
    
    @IBAction func showAnalytics(_ sender: Any) {
        present(AnalyticsViewController.getInstance(), animated: true, completion: nil)
    }
    
    // MARK: - UI Components

    @IBAction func loadOneColumn(_ sender: Any) {
        if let photos = getSamplePhotos() {
            present(OneColumnViewController.getInstance(photos), animated: true, completion: nil)
        }
    }

    @IBAction func loadOneColumnAutoplay(_ sender: Any) {
        if let photos = getSamplePhotos() {
            present(AutoPlayViewController.getInstance(photos), animated: true, completion: nil)
        }
    }
    
    @IBAction func loadOneColumnInfiniteScroll(_ sender: Any) {
        if let photos = getSamplePhotos() {
            present(InfiniteScrollViewController.getInstance(photos), animated: true, completion: nil)
        }
    }
    
    @IBAction func loadTwoColumn(_ sender: Any) {
        if let photos = getSamplePhotos() {
            present(TwoColumnDemoListViewController.getInstance(photos), animated: true, completion: nil)
        }
    }

    @IBAction func loadGifFileHeader(_ sender: Any) {
        if let photos = getSamplePhotos() {
            present(ListWithGifFileViewController.getInstance(photos), animated: true, completion: nil)
        }
    }
    @IBAction func loadGifURLHeader(_ sender: Any) {
        if let photos = getSamplePhotos() {
            present(ListWithGifURLViewController.getInstance(photos), animated: true, completion: nil)
        }
    }
    
    @IBAction func loadTextHeader(_ sender: Any) {
        if let photos = getSamplePhotos() {
            present(ListWithTextViewController.getInstance(photos), animated: true, completion: nil)
        }
    }
    @IBAction func loadPhotoProductsView(_ sender: Any) {
        if let photos = getSamplePhotos() {
            present(PhotoProductListDemoViewController.getInstance([photos[0]]), animated: true, completion: nil)
        }
        
    }
}

extension ViewController: PXLPhotoProductDelegate {
    public func onProductsLoaded(products: [PXLProduct]) -> [Int: Bool] {
        var bookmarks = [Int: Bool]()
        products.forEach { product in
            bookmarks[product.identifier] = true
        }
        return bookmarks
    }
    
    public func onBookmarkClicked(product: PXLProduct, isSelected: Bool) {
        print("Pruduct: \(product.identifier) is selected: \(isSelected)")
    }
    
    public func shouldOpenURL(url: URL) -> Bool {
        print("url: \(url)")
        return false
    }
    
    public func onProductClicked(product: PXLProduct) {
        print("Pruduct: \(product.identifier) clicked")
    }
}


// MARK: - Show Popup
extension ViewController {
    func showPopup(message:String) {
        let alert = UIAlertController(title: "No credential file", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
}
