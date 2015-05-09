# pixlee-ios-sdk

[![Version](https://img.shields.io/cocoapods/v/pixlee-ios-sdk.svg?style=flat)](http://cocoapods.org/pods/pixlee-ios-sdk)
[![License](https://img.shields.io/cocoapods/l/pixlee-ios-sdk.svg?style=flat)](http://cocoapods.org/pods/pixlee-ios-sdk)
[![Platform](https://img.shields.io/cocoapods/p/pixlee-ios-sdk.svg?style=flat)](http://cocoapods.org/pods/pixlee-ios-sdk)

This SDK makes it easy for Pixlee customers to easily include Pixlee albums in their native iOS apps. It includes a native wrapper to the Pixlee album API as well as some drop-in and customizable UI elements to quickly get you started.

## Getting Started

This repo includes both the Pixlee iOS SDK and an example project to show you how it's used.

### Installation

pixlee-ios-sdk is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "pixlee-ios-sdk"
```

### SDK

Before accessing the Pixlee API, you must initialize the `PXLClient`. To set the API key, call `setApiKey:` on `[PXLClient sharedClient]`. You can then use that singleton instance to make calls against the Pixlee API.

To load the photos in an album, you'll want to use the `PXLAlbum` class. Create an instance by calling `[PXLAlbum albumWithIdentifier:<ALBUM ID HERE>]`. You can then set `sortOptions` and `filterOptions` as necessary (see the header files for more details) before calling `loadNextPageOfPhotos:` to load photos. An album will load its photos as pages, and calling `loadNextPageOfPhotos:` successively will load each page in turn.

Additionally, you can control how an album loads its data using `PXLAlbumFilterOptions` and `PXLAlbumSortOptions`. To use these, create a new instance with `[PXLAlbumFilterOptions new]` or `[PXLAlbumSortOptions new]`, set the necessary properties, and then set those objects to the `filterOptions` and `sortOptions` properties on your album. Make sure to set these before calling `loadNextPageOfPhotos:`.

Once an album has loaded photos from the server, it will instantiate `PXLPhoto` objects that can be consumed by your UI. `PXLPhoto` exposes all of the data for a photo available through the Pixlee API and offers several image url sizes depending on your needs.

To help you quickly get started, we've also built an album view controller and photo detail view controller that can be used and customized in your app. `PXLAlbumViewController` uses a `UICollectionView` to display the photos in an album and includes a toggle to switch between a grid and list view. Use `albumViewControllerWithAlbumId:` to create an instance or set the `album` property if you need to create an instance through other means. Once the album has been set, you can call `loadNextPageOfPhotos` to start the loading process. The album view controller is set up to automatically load more pages of photos as the user scrolls, giving it an infinite scroll effect.

If a user taps on a photo in the `PXLAlbumViewController`, we present a detail view with `PXLPhotoDetailViewController`. You may present a detail view yourself by instantiating an instance of `PXLPhotoDetailViewController` and setting its `photo` property. The photo detail view is configured to display:
* the large photo
* the username of the poster
* a timestamp showing when the photo was posted
* the platform source of the photo (e.g. Instagram)
* the photo's caption (if one is available)
* any products associated with that photo (displayed as a horizontal list of products)

### Example

To run the example project, clone the repo, and run `pod install` from the Example directory first. Then in `PXLAppDelegate.m` set `PXLClientAPIKey` to your API key (available from the Pixlee dashboard). Then in `PXLExampleAlbumViewController.m` set the album id that you wish to display as `PXLAlbumIdentifier`. Run the project and you should see a grid of photos from that album.

## License

pixlee-ios-sdk is available under the MIT license. See the LICENSE file for more info.
