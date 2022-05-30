---
layout: default
permalink: /ios-sdk
currentPage: iOS SDK
githubLink: https://github.com/pixlee/pixlee-ios-sdk
---

[![Version](https://img.shields.io/cocoapods/v/PixleeSDK.svg?style=flat)](https://cocoapods.org/pods/PixleeSDK)
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat-square)](https://github.com/Carthage/Carthage)
[![Swift Package Manager](https://img.shields.io/badge/Swift_Package_Manager-compatible-orange?style=flat-square)](https://img.shields.io/badge/Pixlee-iOS-SDK-compatible-orange?style=flat-square)

# pixlee-ios-sdk

This SDK makes it easy for Pixlee customers to easily include Pixlee albums in their native iOS apps. It includes a native wrapper to the Pixlee album API as well as some drop-in and customizable UI elements to quickly get you started. This repo includes both the Pixlee iOS SDK and an example project to show you how it's used.

### Notice: please be aware of these terms in the document.

- the word 'content' is used in the documentation. this means a photo or video.
- The PXLPhoto class represents a piece of content, which can be a photo or video

# Basic: Table of Content

- [About the SDK](#About-the-SDK)
- [Get Started with Demo App](#Get-Started-with-Demo-App)
- [Installation](#Installation)
  - [Cocoapods](#cocoapods)
  - [Carthage](#carthage)
  - [Swift Package Manager](#Swift-Package-Manager)
- [Initiate the SDK](#Initiate-the-SDK)
  - [API Key](#api-key)
  - [Secret Key (Optional)](#secret-key-optional)
  - [Disable Caching: Network API Caching (Optional)](#disable-caching-network-api-caching--optional)
  - [Multi-region (Optional)](#multi-region-optional)
  - [Automatic Analytics (Optional)](#automatic-analytics-optional)
- [Basic Development Guide](#basic-development-guide)

# Advanced: Table of Content

- [API: Filtering and Sorting](#api-filtering-and-sorting)
- [Getting a PXLPhoto](#getting-a-pxlphoto)
- [Analytics](#Analytics)
  - [Add to Cart](#Add-to-Cart)
  - [Conversion](#Conversion)
  - [Opended Widget](#Opended-Widget)
  - [Opened Lightbox](#Opened-Lightbox)
  - [Action Click](#Action-Click)
  - [Load More](#Load-More)
- [Uploading an Image to an album](#Uploading-an-Image-to-an-album)
- [UI components](#UI-components)
  - [List version 2 (recommended)](#list-version-2-recommended)
    - [PXLWidgetView (similar to Pixlee web Widget)](#pxlwidgetview-similar-to-pixlee-web-widget)
  - [List version 1](#list-version-1)
    - [PXLPhotoListView](#PXLPhotoListView)
    - [PXLGridView](#PXLGridView)
      - [Automatic analytics of pxlgridview](#automatic-analytics-of-pxlgridview)
  - [Detail](#detail)
    - [PXLPhotoProductView](#pxlphotoproductview)
      - [Show hotspots if available](#show-hotspots-if-available)
      - [Automatic Analytics of PXLPhotoProductView](#automatic-analytics-of-pxlphotoproductview)
  - [Advanced](#advanced)
    - [PXLPhotoView](#pxlphotoview)
- [Troubleshooting](#Troubleshooting)
- [License](#License)

# About the SDK

Before accessing the Pixlee API, you must initialize the `PXLClient`. To set the API key, what can be set with the `apiKey` property on `PXLClient.sharedClient`. You can then use that singleton instance to make calls against the Pixlee API.

To load PXLPhotos(content) in an album there are two methods https://developers.pixlee.com/reference#get-approved-content-from-album or https://developers.pixlee.com/reference#get-approved-content-for-product.

If you are retriving the content for one album you'll want to use the `PXLAlbum` class. Create an instance by calling `PXLAlbum(identifier: <ALBUM ID HERE>)`. You can then set `sortOptions` and `filterOptions` as necessary (see the header files for more details) before calling `loadNextPageOfPhotos:` to load photos.
You can load the PXLPhotos(content) via the `PXLClient`, You just have to use the `loadNextPageOfPhotosForAlbum(album, completionHandler)`. It will load the album's content as pages, and calling `loadNextPageOfPhotos:` successively will load each page in turn with returning the newly loaded content in the completion block, and updating the album's content array to get all of the content.

# Get Started with Demo App

1. open **Example** folder in terminal.

2. run this command. ( Don't have Pod installed on your computer? [Please look in to this link to install Pod before doing this](https://guides.cocoapods.org/using/getting-started.html) )
   ```
   pod install
   ```
3. open the Xcode project file depending on your needs:

   - [Option 1] Cocoapods: **Example/ExamplePod.xcworkspace**
   - [Option 2] Carthage: **Example/ExampleCarthage.xcodeproj**
   - [Option 3] Swift Package Manager: **Example/ExampleSPM.xcodeproj**

4. create **PixleeCredentials.plist** in Example/Example/PixleeCredentials.plist

   - add these 4 elements to **PixleeCredentials.plist**
     - PIXLEE_API_KEY:(String) "replace with your own value" (https://app.pixlee.com/app#settings/pixlee_api)
     - PIXLEE_SECRET_KEY:(String) "replace with your own value" (find here: https://app.pixlee.com/app#settings/pixlee_api)
     - PIXLEE_ALBUM_ID:(String) "replace with your own value" (find here: https://app.pixlee.com/app#albums)
     - PIXLEE_SKU:(String) "replace with your own value" (find here: https://app.pixlee.com/app#products)
     - PIXLEE_REGION_ID:(String) "replace with your own value" (find here: https://app.pixlee.com/app#products)
       <img src="doc/img/edit_pixlee_credentials.png" width="50%">

5. in Xcode, run the app by clicking **Product> Run** in the menu bar or by pressing **Command + R** on you keyboard.

# Installation

You can choose one of these two options to add the SDK to your app. Plase replace `PixleeSDK version` with [![Version](https://img.shields.io/cocoapods/v/PixleeSDK.svg?style=flat)](https://cocoapods.org/pods/PixleeSDK).

### Cocoapods

[CocoaPods](https://cocoapods.org) is a dependency manager for Cocoa projects. For usage and installation instructions, visit their website. To integrate Alamofire into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
target 'MyApp' do
  pod 'PixleeSDK', '~> <PixleeSDK version like 2.5.1>' (Replace with current version, you can find the current version at https://github.com/pixlee/pixlee-ios-sdk/releases)
end
```

### Carthage

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that builds your dependencies and provides you with binary frameworks. To integrate Alamofire into your Xcode project using Carthage, specify it in your `Cartfile`:

```ogdl
github "pixlee/pixlee-ios-sdk" ~> <PixleeSDK version like 2.5.1>
```

### Swift Package Manager

The [Swift Package Manager](https://swift.org/package-manager/) is a tool for automating the distribution of Swift code and is integrated into the `swift` compiler. It is in early development, but Alamofire does support its use on supported platforms.

Once you have your Swift package set up, adding Alamofire as a dependency is as easy as adding it to the `dependencies` value of your `Package.swift`.

```swift
dependencies: [
    .package(url: "https://github.com/pixlee/pixlee-ios-sdk.git", .upToNextMajor(from: "<PixleeSDK version like 2.5.1>"))
]
```

# Initiate the SDK

### Sample

```swift
#!swift
PXLClient.sharedClient.apiKey = your api key
PXLClient.sharedClient.secretKey = your secret key // (Optional) <----- use this if you use analytics or image-upload
PXLClient.sharedClient.disableCaching = true // (Optional) don't use cache
PXLClient.sharedClient.regionId = your region id // (Optional) <--- set it if you use multi-region.
PXLClient.sharedClient.autoAnalyticsEnabled = true // (Optional) <----- This activates this auto-analytics on PXLGridView and PXLPhotoProductView

```

### API key

- Where to get Pixlee API credentials? visit here: https://app.pixlee.com/app#settings/pixlee_api
- add your Pixlee API key.
  ```swift
  #!swift
  PXLClient.sharedClient.apiKey = apiKey
  ```

### Secret Key (Optional)

- add your Secret Key if you are making POST requests.
  ```swift
  #!swift
  PXLClient.sharedClient.secretKey = secretKey
  ```

### Disable Caching: Network API Caching (Optional)

- We've seen issues with the phones caching the requests. So if you want you can enable the network API caching by setting `PXLClient`'s `disableCaching` property to `false`. The default is disabled (disableCaching=true).
  ```swift
  #!swift
  PXLClient.sharedClient.disableCaching = true // don't use cache
  PXLClient.sharedClient.disableCaching = false // use cache
  ```

### Multi-region (Optional)

- if you use multi-region, you can set your region id here to get photos, a photo, and products available in the region.
  ```swift
  #!swift
  PXLClient.sharedClient.regionId = your region id <--- set it if you use multi-region.
  ```

### Automatic Analytics (Optional)

```swift
#!swift
PXLClient.sharedClient.autoAnalyticsEnabled = true // (Optional) <----- This activates this auto-analytics on PXLGridView and PXLPhotoProductView
```

- This is to delegate this SDK to fire necessary analytics events for you. If you don't want to use this, you can just ignore this part.
- if you use PXLGridView, you need an extra setting [Document: Automatic analytics of PXLGridView](#automatic-analytics-of-pxlgridview).
- Which analytics do we fire for you?:
  - `loadmore` event: when you use `PXLClient.sharedClient.loadNextPageOfPhotosForAlbum(album: album)` and load the second or the next pages, we fire `loadmore` events for you.
  - `openedWidget` event: if you implemente [Document: Automatic analytics of PXLGridView](#automatic-analytics-of-pxlgridview) and try to display the PXLGridView with a number of PXLPhotos on the screen we fire `openedWidget`.
  - `widgetVisible` event: if you implemente [Document: Automatic analytics of PXLGridView](#automatic-analytics-of-pxlgridview) and try to display the PXLGridView with a number of PXLPhotos on the screen we fire `widgetVisible`.
  - `openedLightbox` event: when you display [PXLPhotoProductView](#automatic-analytics-of-pxlphotoproductview) with a PXLPhoto on the screen, we fire `openedLightbox`.
- **Notice**: you can see the fired events on the console. If there's a problem of your setting, you can see error messages we display in the console.

# Basic Development Guide

- With this guide, you can use our UI Components and quickly implement most features of the SDK on your app.
- However, if you're looking for firing the APIs to get the content and present them into your own UI, please check out [API: Filtering and Sorting](#api-filtering-and-sorting).

### Step 1: Initiate the SDK and Auto Analytics

```swift
PXLClient.sharedClient.apiKey = your api key
PXLClient.sharedClient.secretKey = your secret key // (Optional) <----- use this if you use analytics or image-upload
PXLClient.sharedClient.regionId = your region id // (Optional) <--- set it if you use multi-region.
PXLClient.sharedClient.autoAnalyticsEnabled = true // make sure this is true
#!swift
```

### Step 2: Load List UI and its data

- implement this: [PXLWidgetView (similar to Pixlee web Widget)](#pxlwidgetview-similar-to-pixlee-web-widget)

### Step 3: Load Detail UI

- implement this: [PXLPhotoProductView](#pxlphotoproductview)
- Not that you need to make sure that PXLPhotoProductView should be loaded when a cell of PXLWidgetView is clicked. You can get examples in the demo app in this project.

# API: Filtering and Sorting

Information on the filters and sorts available are here: https://developers.pixlee.com/reference#consuming-content

As of now, the following filters are supported by SDK:

```swift
min_instagram_followers
min_twitter_followers
denied_photos
starred_photos
flagged_photos (Note: false is equivalent to null here.)
deleted_photos
has_permission (Note: false is equivalent to null here.)
has_product
in_stock_only (Note: false is equivalent to null here.)
content_source
content_type
filter_by_subcaption
has_action_link
submitted_date_start
submitted_date_end
in_categories
computer_vision
filter_by_location
filter_by_radius
```

The following sorts are supported by SDK:

```swift
recency - The date the content was collected.
random - Randomized.
pixlee_shares - Number of times the content was shared from a Pixlee widget.
pixlee_likes - Number of likes the content received from a Pixlee widget.
popularity - Popularity of the content on its native platform.
dynamic - Our "secret sauce" -- a special sort that highlights high performance content and updates according to the continued performance of live content.
```

#### Example

```swift

//=========================================================
//These parameters are examples. Please adjust, add or remove them during implementation.
//=========================================================

PXLClient.sharedClient.apiKey = <your api key>
PXLClient.sharedClient.secretKey = <your secret key>

// Added regionId to get the currency of the specific region when searching for photos of an album. Here's how you can use it.
// note: - note: you can get the right currencies of your products by adding regionId here
PXLClient.sharedClient.regionId = <your region id> <--- set it if you use multi-region.

//Create an Instance of Album with the Identifier
let album = PXLAlbum(identifier: PXLAlbumIdentifier)

// Create and set filter options on the album.
album.filterOptions = PXLAlbumFilterOptions(minInstagramFollowers: 1)

let dateString = "20190101"
let dateFormatter = DateFormatter()
dateFormatter.dateFormat = "yyyyMMdd"
let date = dateFormatter.date(from: dateString)
filterOptions = filterOptions.changeSubmittedDateStart(newSubmittedDateStart: date)

//These parameters are examples. Please adjust, add or remove them during implementation.
album.filterOptions = filterOptions;

// Create and set sort options on the album.
album.sortOptions = PXLAlbumSortOptions(sortType: .Recency, ascending: false)
album.perPage = 100;

PXLClient.sharedClient.loadNextPageOfPhotosForAlbum(album: album) { photos, error in
    guard error == nil else {
        print("There was an error during the loading \(String(describing: error))")
        return
    }
    //Use your content array here
    print("New content loaded: \(photos)")
}

```

If you are retriving the content for a sku you'll want to use the `PXLAlbum` class. Create an instance by calling `PXLAlbum(sku:<SKU ID HERE>)`. As the same as with identifier, you can then set `sortOptions` and `filterOptions` as necessary (see the header files for more details) before calling `loadNextPageOfPhotos:` to load photos.
You can load the content via the `PXLClient`, You just have to use the `loadNextPageOfPhotosForAlbum(album, completionHandler)`. It will load the album's content as pages, and calling `loadNextPageOfPhotos:` successively will load each page in turn with returning the newly loaded content in the completion block, and updating the album's content array to get all of the photos.

#### Example

```swift

//=========================================================
//These parameters are examples. Please adjust, add or remove them during implementation.
//=========================================================

PXLClient.sharedClient.apiKey = <your api key>
PXLClient.sharedClient.secretKey = <your secret key>

// Added regionId to get the currency of the specific region when searching for photos of an album. Here's how you can use it.
// note: - note: you can get the right currencies of your products by adding regionId here
PXLClient.sharedClient.regionId = <your region id> <--- set it if you use multi-region.

//Create an Instance of Album with the SKU Identifier
let album = PXLAlbum(identifier: PXLSkuAlbumIdentifier)

// Create and set filter options on the album.
let dateString = "20190101"
let dateFormatter = DateFormatter()
dateFormatter.dateFormat = "yyyyMMdd"
let date = dateFormatter.date(from: dateString)
filterOptions = PXLAlbumFilterOptions(submittedDateStart: date)

//These parameters are examples. Please adjust, add or remove them during implementation.
album.filterOptions = filterOptions;

// Create and set sort options on the album.
album.sortOptions = PXLAlbumSortOptions(sortType: .random, ascending: false)
album.perPage = 100;

PXLClient.sharedClient.loadNextPageOfPhotosForAlbum(album: album) { photos, error in
    guard error == nil else {
        print("There was an error during the loading \(String(describing: error))")
        return
    }
    //Use your content array here
    print("New content loaded: \(photos)")
}

```

#### Notes

Additionally, you can control how an album loads its data using `PXLAlbumFilterOptions` and `PXLAlbumSortOptions`. To use these, create a new instance with `PXLAlbumFilterOptions()` or `PXLAlbumSortOptions(sortType:SortType, ascending:Boolean)`, set the necessary properties, and then set those objects to the `filterOptions` and `sortOptions` properties on your album. Make sure to set these before calling `loadNextPageOfPhotosForAlbum:`.

Once an album has loaded content from the server, it will instantiate `PXLPhoto` objects that can be consumed by your UI. `PXLPhoto` exposes all of the data for a content available through the Pixlee API and offers several image url sizes depending on your needs.

To help you quickly get started, we've also built an album view controller and content detail view controller that can be used and customized in your app. `PXLAlbumViewController` uses a `UICollectionView` to display the content in an album and includes a toggle to switch between a grid and list view. You can use the `viewControllerForAlbum` method of the class to instantiate a new view controller with the provided album object.
Example of showing the ViewController

```swift
let albumVC = PXLAlbumViewController.viewControllerForAlbum(album:album)
showViewController(VC: albumVC)
```

The album view controller is set up to automatically load more pages of content as the user scrolls, giving it an infinite scroll effect.

If a user taps on a content in the `PXLAlbumViewController`, we present a detail view with `PXLPhotoDetailViewController`. You may present a detail view yourself by instantiating an instance of `PXLPhotoDetailViewController.viewControllerForPhot` and providing the `PXLPhoto` instance property. The content detail view is configured to display:

- the large content
- the username of the poster
- a timestamp showing when the content was posted
- the platform source of the content (e.g. Instagram)
- the content's caption (if one is available)
- any products associated with that content (displayed as a horizontal list of products)
  Example of loading the detailViewController

```swift
    let photoDetailVC = PXLPhotoDetailViewController.viewControllerForPhoto(photo: photo)
    let navController = UINavigationController(rootViewController: photoDetailVC)
    present(navController, animated: true, completion: nil)
```

# Getting a PXLPhoto

If you want to make a PXLPhoto using an album photo id, you can get it using our API in the SDK like below.

```swift
var photoAlbumId = <one of you photo album ids>
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
    }
}
```

If you want to make a PXLPhoto using an album photo id and a region id, you can get it using our API in the SDK like below.

```swift
var photoAlbumId = <one of you photo album ids>
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
    }
}
```

# Analytics

If you would like to make analytics calls you can use our analytics service `PXLAnalyticsService`. What is a singleton, you can reach it as `PXLAnalyticsService.sharedAnalytics`.
To log an event. You need to instantiate the event's class what is inherited from the `PXLAnalyticsEvent` (listed available types bellow). And pass it to the analytics service's `logEvent` method.
The following events are supported by the sdk:

```swift
Add to Cart (PXLAnalyticsEventActionClicked): Call this whenever and wherever an add to cart event happens
User Completes Checkout (PXLAnalyticsEventConvertedPhoto): Call this whenever a user completes a checkout and makes a purchase
User Visits a Page with a Pixlee Widget (PXLAnalyticsEventOpenedLightBox): Call this whenever a user visits a page which as a Pixlee Widget on it
User Clicks on the Pixlee Widget (PXLAnalyticsEventOpenedWidget): Call this whenever a user clicks on an item in the Pixlee widget
PXLAlbums:  Load More (PXLAnalyticsEventLoadMoreClicked): Call this whenever a user clicks 'Load More' button on the widget

PXLPhoto: Action Link Clicked (PXLAnalyticsEventActionClicked): Call this whenever a user make an action after clicking on an item in the Pixlee widget

```

### Add to Cart

```swift
    let currency = "USD"
    let productSKU = "SL-BENJ"
    let quantity = 2
    let price = "13.0"
    let event = PXLAnalyticsEventAddCart(sku: productSKU,
        quantity: quantity,
        price: price,
        currency: currency)

     //EVENT add:cart refer to pixlee_sdk/PXLAbum.h or The Readme or https://developers.pixlee.com/docs/analytics-events-tracking-pixel-guide
    PXLAnalyticsService.sharedAnalytics.logEvent(event: event) { error in
        guard error == nil else {
            print("There was an error \(error)")
            return
        }
        print("Logged")
    }
```

### Conversion

```swift
    // Setup some constants
    let currency = "USD"
    // Product 1 example
    let productSKU = "SL-BENJ"
    let price = "13.0"
    let quantity = 2
    // product 2 example
    let productSKU2 = "AD-1324S"
    let price2 = "5.0"
    let quantity2 = 5

    let cart1 = PXLAnalyticsCartContents(price: price, productSKU: productSKU, quantity: quantity)
    let cart2 = PXLAnalyticsCartContents(price: price2, productSKU: productSKU2, quantity: quantity2)
    let quantityTotal = 7
    let orderId = 234232
    let cartTotal = "18.0"

    let cartContents = [cart1, cart2]

    //EVENT converted: refers to pixlee_sdk/PXLAbum.h or The Readme or https://developers.pixlee.com/docs/analytics-events-tracking-pixel-guide
    let event = PXLAnalyticsEventConvertedPhoto(cartContents: cartContents, cartTotal: cartTotal, cartTotalQuantity: quantityTotal, orderId: orderId, currency: currency)

    PXLAnalyticsService.sharedAnalytics.logEvent(event: event) { error in
        guard error == nil else {
            print("There was an error \(error)")
            return
        }
        print("Logged")
    }
```

### Opended Widget

It's important to trigger this event after the LoadNextPage event

```swift
    let album = PXLAlbum(sku: PXLSkuAlbumIdentifier)
    // If you are using  https://developers.pixlee.com/reference#get-approved-content-from-album // api/v2/album/@album_id/Photos
    // If you are using api/v2/album/sku_from
    // Refer to pixlee_sdk PXLAbum.h
    PXLClient.sharedClient.loadNextPageOfPhotosForAlbum(album: album) { _, _ in
        //It's important to trigger these events after the LoadNextPage event

        //EVENT opened:widget refer to pixlee_sdk/PXLAbum.h or The Readme or https://developers.pixlee.com/docs/analytics-events-tracking-pixel-guide
        album.triggerEventOpenedWidget(widget: .horizontal) { _ in
            print("Logged")
        }
    }
```

### Opened Lightbox

```swift
    // fire this when a PXLPhoto is displayed from your List View containing a list of PXLPhotos
    let pxlPhoto:PXLPhoto = photoFromSomewhere

    //EVENT opened:lightbox refer to pixlee_sdk/PXLAbum.h or The Readme or https://developers.pixlee.com/docs/analytics-events-tracking-pixel-guide
    pxlPhoto.triggerEventOpenedLightbox() { (error) in
        print("Logged")
    }

```

### Action Click

```swift
    PXLClient.sharedClient.getPhotoWithPhotoAlbumId(photoAlbumId: "299469263") { newPxlPhoto, error in
        guard error == nil else {
            print("Error during load of image with Id \(String(describing: error))")
            return
        }
        guard let pxlPhoto = newPxlPhoto else {
            print("cannot find pxlPhoto")
            return
        }
        print("New Photo: \(pxlPhoto.albumPhotoId)")
        if let product = pxlPhoto.products?.first, let url = product.link?.absoluteString {
            pxlPhoto.triggerEventActionClicked(actionLink: url) { _ in
                print("triggered")
            }
        }
    }
```

### Load More

```swift
    let album = PXLAlbum(sku: PXLSkuAlbumIdentifier)
    // If you are using  https://developers.pixlee.com/reference#get-approved-content-from-album // api/v2/album/@album_id/Photos
    // If you are using api/v2/album/sku_from
    // Refer to pixlee_sdk PXLAbum.h
    PXLClient.sharedClient.loadNextPageOfPhotosForAlbum(album: album) { _, _ in
        /
        album.triggerEventLoadMoreTapped { (error) in
            print("logged")
        }
    }

```

# Uploading an Image to an album

```swift
// Example
public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
    guard let image = info[.editedImage] as? UIImage else {
        print("No image found")
        return
    }

    if let albumIdentifier = viewModel?.album.identifier, let albumID = Int(albumIdentifier) {
        let pxlNewImage = PXLNewImage(image: image, albumId: albumID, title: "Sample image name", email: "will.smith@gmail.com", username: "Will", approved: true, connectedUserId: nil, productSKUs: nil, connectedUser: nil)

        PXLClient.sharedClient.uploadPhoto(photo: pxlNewImage,
            progress: { percentage in
                self.applyUploadPercentage(percentage)
            },
            uploadRequest: { uploadReqest in

                let doYouWantToCancelTheRequest = false
                if doYouWantToCancelTheRequest {
                    uploadReqest?.cancel()
                }
            },
            completion: { photoId, connectedUserId, error in
                guard error == nil else {
                    print("🛑 Error while uploading image :\(error?.localizedDescription)")
                    return
                }

                guard let photoId = photoId, let connectedUserId = connectedUserId else {
                    print("🛑 Don't have photo or connectedUserID")
                    return
                }
                print("⭐️ Upload completed: photoID:\(photoId), connectedUserID:\(connectedUserId)")
            }
        )
    }
}
```

# UI components

## List Version 2 (Recommended)

### PXLWidgetView (similar to Pixlee web Widget)

- automatically fire APIs[api/v2/albums/from_sku, api/v2/albums/{album_id}/photos] to get and display photos
- automatically fire Analytics[openedWidget, widgetVisible]
- provide grid (2 columns) and list layouts

#### UI Options

For both Grid and List: load more UI (customizable color, font, text, height of the cell, padding)

- List

  - turn auto video playing on/off: play a video located at the top of the list

- Grid
  - Line Size between items
  - Header
    - Image URL
    - Customizable text

| Grid Mode | List Mode | Horizontal |
| ------ | ------ |
| <img src="https://i.ibb.co/YWxZfJ7/ezgif-com-gif-maker.gif" width="100%" /> | <img src="https://i.ibb.co/ZWjVyJp/ezgif-com-gif-maker-1.gif" width="100%" /> | <img src="https://i.ibb.co/L98KQp2/horizontal.gif" width="100%" />

| Mosaic with mosaicSpan=.three | Mosaic with mosaicSpan=.four) | Mosaic with mosaicSpan=.five |
| ------ | ------ || ------ |
| <img src="https://i.ibb.co/HGtNHjB/mosaic3.gif" width="100%" /> | <img src="https://i.ibb.co/xXZPYfw/mosaic4.gif" width="100%" /> | <img src="https://i.ibb.co/F0zG6QC/mosaic5.gif" width="100%" /> |
#### Example

```swift
#!swift Your View controller
class WidgetExampleViewController: UIViewController {
    static func getInstance() -> WidgetExampleViewController {
        let vc = WidgetExampleViewController(nibName: "EmptyViewController", bundle: Bundle.main)
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
            album.filterOptions = PXLAlbumFilterOptions(hasPermission: true, hasProduct: true)
            album.sortOptions = PXLAlbumSortOptions(sortType: .approvedTime, ascending: false)
            album.perPage = 30
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
        // A example of List
        /*WidgetSpec.list(.init(cellHeight: 350,
                isVideoMutted: true,
                autoVideoPlayEnabled: true,
                loadMore: .init(cellHeight: 100.0,
                        cellPadding: 10.0,
                        text: "LoadMore",
                        textColor: UIColor.darkGray,
                        textFont: UIFont.systemFont(ofSize: UIFont.buttonFontSize),
                        loadingStyle: .gray)))*/
        // A example of Grid
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
                mosaicSpan: .five,
                cellPadding: 1,
                loadMore: .init(cellHeight: 100.0,
                                cellPadding: 10.0,
                                text: "LoadMore",
                                textColor: UIColor.darkGray,
                                textFont: UIFont.systemFont(ofSize: UIFont.buttonFontSize),
                                loadingStyle: .gray)))

      // An example of Horizontal
//      WidgetSpec.horizontal(
//              .init(
//                      cellPadding: 1,
//                      loadMore: .init(cellHeight: 100.0,
//                              cellPadding: 10.0,
//                              text: "LoadMore",
//                              textColor: UIColor.darkGray,
//                              textFont: UIFont.systemFont(ofSize: UIFont.buttonFontSize),
//                              loadingStyle: .gray)))
    }

    func setWidgetType() -> String {
        "replace_this_with_yours"
    }

    func setupPhotoCell(cell: PXLGridViewCell, photo: PXLPhoto) {
        if photo.isVideo {
            videoCell = cell
        }
        // Example(all elements) : cell.setupCell(photo: photo, title: "Title", subtitle: "subtitle", buttonTitle: "Button", configuration: PXLPhotoViewConfiguration(cropMode: .centerFill), delegate: self)
        cell.setupCell(photo: photo, title: nil, subtitle: nil, buttonTitle: nil, configuration: PXLPhotoViewConfiguration(cropMode: .centerFill), delegate: self)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {

    }
}
```

## List Version 1

### PXLPhotoListView

- Infinite scrolling list from the given PXLPhoto objects. It create PXLPhotoView views with an infinite scrolling UITableView. You have to add an array of PXLPhoto objects.
  ```swift
  //Basic Example
  ...
      var photoView = PXLPhotoListView()
      photoView.delegate = self
      photoView.frame = view.frame
      view.addSubview(photoView)
      photoView.items = [Array Of Photos]
  }
  ```

### PXLGridView

| one photo in a row                              | two photos in a row                                  |
| ----------------------------------------------- | ---------------------------------------------------- |
| <img src="doc/gif/PXLGridView.gif" width="50%"> | <img src="doc/gif/PXLGridViewMulti.gif" width="50%"> |

Grid view with lots of customizable features, where the cells are PXLPhotoViews. You have to implement the `PXLGridViewDelegate` to customize the grid.

#### Customization options

- `cellHeight`: Height of the cells
- `cellPadding`: Padding between the cells and rows
- `isMultipleColumnsEnabled`: Two columns if true, if false then only one column
- `isHighlightingEnabled`: Should change the opacity of the view highlighting the top element in the view
- `isInfiniteScrollingEnabled`: If we want to have infinite scrolling
- `setupPhtoCell(cellPXLGridViewCell: photo:PXLPhoto)`: Here, you can customize your cell like in the basic example of `PXLPhotoView`.

#### Optional options

- `headerTitle`: Title of the header
- `headerGifName`: Name of header gif image bundled in the application
- `headerGifUrl`: Url of the header gif image
- `headerHeight`: Height of the header
- `headerGifContentMode`: Content mode of the header gif images
- `headerTitleFont`: Font of the header title
- `headerTitleColor`: Color of the header title

#### Example of PXLGridView

```swift
//Basic Example
override func viewDidLoad() {
    PXLClient.sharedClient.apiKey = your api key
    PXLClient.sharedClient.secretKey = your secret key
    PXLClient.sharedClient.autoAnalyticsEnabled = false
    PXLClient.sharedClient.regionId = your region id <--- set it if you use multi-region.

    var gridView = PXLGridView()
    photoView.delegate = self
    gridView.frame = self.view.bounds
    gridView.delegate = self
    view.addSubview(gridView)
    gridView.items = [Array Of Photos]
}

extension AutoUIImageListViewController: PXLPhotoViewDelegate {
    public func onPhotoButtonClicked(photo: PXLPhoto) {
        print("Action tapped \(photo.id)")
        openPDP(photo: photo)
    }

    public func onPhotoClicked(photo: PXLPhoto) {
        print("Photo Clicked \(photo.id)")
        openPDP(photo: photo)
    }

    func openPDP(photo: PXLPhoto) {
        present(PhotoProductListDemoViewController.getInstance(photo), animated: false, completion: nil)
    }
}

extension AutoUIImageListViewController: PXLGridViewDelegate {
    func isVideoMutted() -> Bool {
        false
    }

    func cellsHighlighted(cells: [PXLGridViewCell]) {
        //        print("Highlighted cells: \(cells)")
    }

    func setupPhotoCell(cell: PXLGridViewCell, photo: PXLPhoto) {
        if let index = pxlGridView.items.firstIndex(of: photo) {
            cell.setupCell(photo: photo, title: "[album photo id: \(photo.albumPhotoId)]\n[album id: \(photo.albumId)] in", subtitle: "Click to Open", buttonTitle: "PXLPhotoProductView", configuration: PXLPhotoViewConfiguration(enableVideoPlayback: true, cropMode: .centerFit), delegate: self)
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
        return false
    }

    func isInfiniteScrollEnabled() -> Bool {
        return false
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // This is an example of how to load more photos as you swipe up to go to the bottom of the scroll. You can use our own way of doing this.
        if scrollView == pxlGridView.collectionView && !pxlGridView.items.isEmpty {
            let unseenHeight = scrollView.contentSize.height - (scrollView.contentOffset.y + scrollView.frame.height)
            // this [single page's height * singlePageRatio] pixels of the remaining scrollable height is used for smooth scroll while retrieving photos from the server.
            let singlePageRatio = CGFloat(2.0)
            if unseenHeight < (scrollView.frame.height * singlePageRatio) {
                loadPhotos()
            }
        }
    }
}

```

#### Automatic Analytics of PXLGridView

- If you want to delegate firing 'VisibleWidget' and 'OpenedWidget' analytics event to PXLGridView, use this code. On the other hand, if you want to manually fire the two events, you don't use this and do need to implement our own analytics codes. Please check out AutoUIImageListViewController.swift to get the sample codes.
- **[Important] Please be aware of giving the same instance of PXLAlbum that you created to retrieve the list of PXLPhotos to send the correct album information to the analytics server.**

```swift
#!swift
let album: PXLAlbum
override func viewDidLoad() {
    PXLClient.sharedClient.apiKey = your api key
    PXLClient.sharedClient.secretKey = your secret key
    PXLClient.sharedClient.autoAnalyticsEnabled = true <----- This activates this feature
    PXLClient.sharedClient.regionId = your region id <--- set it if you use multi-region.

    var gridView = PXLGridView()
    ...
    pxlGridView.autoAnalyticsDelegate = self <-- MUST be implemented
    ...
}

// this must be implemented to use this feature
extension AutoUIImageListViewController: PXLGridViewAutoAnalyticsDelegate {
    func setupAlbumForAutoAnalytics() -> (album: PXLAlbum, widgetType: String) {
        (album, "customized_widget_type")
    }
}
```

## Detail

### PXLPhotoProductView

<img src="doc/gif/PXLPhotoProductView.gif" width="20%">

- You can load this view with a specific `PXLPhoto` object. It is capable of playing a video or showing an image, with the products provided with the image. It also has a delegate (`PXLPhotoProductDelegate`), what can tell you if the users tapped on the product, or they would like to buy the product, it has a bookmarking feature included. With the delegate you can provide witch products are already bookmarked and keep the list updated after the bookmark button taps.
- To start playing video use the `playVideo()` and to stop playing use the `stopVideo()` methods, to mute / unmute the playbacks volume use the `mutePlayer(muted:Bool)` method.
- You can use and customize the **_close button_** on the view with the following methods:

  - `closeButtonImage` : Sets the image for the close button. Default is an close x image
  - `closeButtonBackgroundColor`: Background color of the close button. Default is clear color.
  - `closeButtonTintColor`: Tint color of the close button, the image will get this tint color. Default: white
  - `closeButtonCornerRadius`: Corner radius of the close button. Default is 22, what is the perfect circle.
  - `hideCloseButton`: Set to true if you don't need the close button on the view

- You can use and customize the **_mute button_** on the view with the following methods:

  - `muteButtonOnImage` : Sets the on image for the mute button.
  - `muteButtonOffImage` : Sets the off image for the mute button.
  - `muteButtonBackgroundColor`: Background color of the mute button. Default is clear color.
  - `muteButtonTintColor`: Tint color of the mute button, the image will get this tint color. Default: white
  - `muteButtonCornerRadius`: Corner radius of the mute button. Default is 22, what is the perfect circle.
  - `hideMuteButton`: Set to true if you don't need the mute button on the view

    ```swift
    //Basic Example
    ...
        let widget = PXLPhotoProductView.widgetForPhoto(photo: photo, delegate: self, ...)
        widget.frame = self.view.frame
        self.view.addSubview(widget.view)
    }
    //Show modally with animation example
    ...
        let widget = PXLPhotoProductView.widgetForPhoto(photo: photo, delegate: self, ...)
        widget.showModally(hostView: self.view, animated:true)
    }
    ```

#### Show hotspots if available

- If a certain content has hotspots data in PXLPhoto.boundingBoxProducts, you can display the hotspots on the UI with this option.

```swift
#!swift
let widget = PXLPhotoProductView.widgetForPhoto(
    ...
    showHotspots: true,
    ...)
```

#### Automatic Analytics of PXLPhotoProductView

- If you want to delegate firing `OpenLightbox` analytics event to PXLPhotoProductView, use this code. On the other hand, if you want to manually fire the event, you don't use this and implement our own analytics codes. Please check out PhotoProductListDemoViewController.swift to get the sample codes.

  ```swift
  #!swift
  PXLClient.sharedClient.apiKey = your api key
  PXLClient.sharedClient.secretKey = your secret key
  PXLClient.sharedClient.autoAnalyticsEnabled = true <----- This activates this feature
  PXLClient.sharedClient.regionId = your region id <--- set it if you use multi-region.

  let widget = PXLPhotoProductView.widgetForPhoto(photo: photo, delegate: self)

  ...
  ```

## Advanced

### PXLPhotoView

- Showing a content with a title, subtitle, and an action button. You can customize the look of the PXLPhotoView, with setting up the `PXLPhotoViewConfiguration`. Implement the delegate (`PXLPhotoViewDelegate`) to know about the content clicked and the action button click events.
- To start playing video use the `playVideo()` and to stop playing use the `stopVideo()` methods, to mute / unmute the playbacks volume use the `mutePlayer(muted:Bool)` method.
  ```swift
  //Basic Example
  ...
      let photoView = PXLPhotoView(frame:CGRectMake(0,0,200,80), photo:PXLPhoto, title:"Photo Title", subtitle:"Subtitle for it", buttonTitle:"Open it", buttonImage:UIImage(named:"Open button"))
      self.view.addSubview(photoView)
  }
  ```

#### PXLPhotoViewConfiguration

Configurator class for the PXLPhotoView.
Configuration options:

- `textColor:UIColor` : Color of the texts
- `titleFont:UIFont`: Font for the title
- `subtitleFont:UIFont`: Font for the subtitle
- `buttonFont:UIFont`: Font for the button
- `buttonImage:UIImage`: Image for the button
- `buttonBorderWidth:CGFloat`: Border width for the button
- `enableVideoPlayback:Bool`: Should play videos or not
- `delegate:PXLPhotoViewDelegate`: Delegate
- `cropMode:PXLPhotoCropMode`: Image/ Video crop mode

# Troubleshooting

#### If you get an error running `carthage update` on osx please clear your carthage cache by doing
`rm -rf ~/Library/Caches/org.carthage.CarthageKit`.

### Re-Authorization of Cocoapods: If there's an error when deploying this SDK on CircleCI deploy. The error message is 'Authentication token is invalid or unverified. Either verify it with the email that was sent or register a new session.'.
- Step 1: Open a terminal-> move to this directory and enter this command -> pod trunk register sungjun@pixleeteam.com 'Sungjun Hong'
- Step 2: An email will be sent to sungjun@pixleeteam.com-> click the link to authorize it
- Step 3: In the terminal , Enter this to get the password ->  grep -A2 'trunk.cocoapods.org' ~/.netrc
  - (reference: https://fuller.li/posts/automated-cocoapods-releases-with-ci/)
- Step 4: Copy the value of the password from **Step 4** and paste into [circle ci environment variable](https://app.circleci.com/settings/project/github/pixlee/pixlee-ios-sdk/environment-variables) with the key of COCOAPODS_TRUNK_TOKEN.
- Step 5: go to [circle ci's failed deployment](https://app.circleci.com/pipelines/github/pixlee/pixlee-ios-sdk?filter=all) and rerun the failed `deploy`.

# Libraries

- [InfiniteLayout](https://github.com/arnauddorgans/InfiniteLayout) is used to implement the infinite scroll in the SDK.
  - you can enable and disable the feature with **PXLGridViewDelegate.isInfiniteScrollEnabled: true / false**

# License

- pixlee-ios-sdk is available under the MIT license.
- [InfiniteLayout](https://github.com/arnauddorgans/InfiniteLayout) is available under the MIT license.
