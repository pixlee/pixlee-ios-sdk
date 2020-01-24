# pixlee-ios-sdk-carthage

This SDK makes it easy for Pixlee customers to easily include Pixlee albums in their native iOS apps. It includes a native wrapper to the Pixlee album API as well as some drop-in and customizable UI elements to quickly get you started.

## Getting Started

This repo includes both the Pixlee iOS SDK and an example project to show you how it's used.

### SDK

Before accessing the Pixlee API, you must initialize the `PXLClient`. To set the API key, what can be set with the  `apiKey` property on `PXLClient.sharedClient`. You can then use that singleton instance to make calls against the Pixlee API.

To load the photos in an album there are two methods https://developers.pixlee.com/reference#get-approved-content-from-album or https://developers.pixlee.com/reference#get-approved-content-for-product. 

If you are retriving the content for one album you'll want to use the `PXLAlbum` class. Create an instance by calling `PXLAlbum(identifier: <ALBUM ID HERE>)`. You can then set `sortOptions` and `filterOptions` as necessary (see the header files for more details) before calling `loadNextPageOfPhotos:` to load photos.
You can load the photos via the `PXLClient`, You just have to use the `loadNextPageOfPhotosForAlbum(album, completionHandler)`. It will load the album's photos as pages, and calling `loadNextPageOfPhotos:` successively will load each page in turn with returning the newly loaded photos in the completion block, and updating the album's photos array to get all of the photos.


### Including Pixlee SDK with Cocoapods
1. install and setup cocoapods with your projects https://guides.cocoapods.org/using/getting-started.html
1. Add https://cocoapods.org/pods/PixleeSDK to your Podfile by adding 
```

target 'MyApp' do
  pod 'PixleeSDK', '~> 2.0.0' (Replace with current version, you can find the current version at https://github.com/pixlee/pixlee-ios-sdk/releases)
end

```
1. Run Pod install

If you are using Objective-C in your porject and don't want to add a framework based on swift you can use our deprecated library: https://github.com/pixlee/ios-sdk-carthage/releases 

### Including Pixlee SDK With Carthage 
##### If you're building for iOS, tvOS, or watchOS
1. Create a Cartfile that lists the frameworks you’d like to use in your project.
1. Run `carthage update`. This will fetch dependencies into a Carthage/Checkouts folder, then build each one or download a pre-compiled framework.
1. On your application targets’ “General” settings tab, in the “Linked Frameworks and Libraries” section, drag and drop each framework you want to use from the Carthage/Build folder on disk.
1. On your application targets’ “Build Phases” settings tab, click the “+” icon and choose “New Run Script Phase”. Create a Run Script in which you specify your shell (ex: `/bin/sh`), add the following contents to the script area below the shell:

  ```sh
  /usr/local/bin/carthage copy-frameworks
  ```

  and add the paths to the frameworks you want to use under “Input Files”, e.g.:

  ```
  $(SRCROOT)/Carthage/Build/iOS/Box.framework
  $(SRCROOT)/Carthage/Build/iOS/Result.framework
  $(SRCROOT)/Carthage/Build/iOS/ReactiveCocoa.framework
  ```
  This script works around an [App Store submission bug](http://www.openradar.me/radar?id=6409498411401216) triggered by universal binaries and ensures that necessary bitcode-related files and dSYMs are copied when archiving.

With the debug information copied into the built products directory, Xcode will be able to symbolicate the stack trace whenever you stop at a breakpoint. This will also enable you to step through third-party code in the debugger.

When archiving your application for submission to the App Store or TestFlight, Xcode will also copy these files into the dSYMs subdirectory of your application’s `.xcarchive` bundle.


### Filtering and Sorting
Information on the filters and sorts available are here: https://developers.pixlee.com/reference#consuming-content

As of now, the following filters are supported by SDK:

```
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

```
recency - The date the content was collected.
random - Randomized.
pixlee_shares - Number of times the content was shared from a Pixlee widget.
pixlee_likes - Number of likes the content received from a Pixlee widget.
popularity - Popularity of the content on its native platform.
dynamic - Our "secret sauce" -- a special sort that highlights high performance content and updates according to the continued performance of live content.
```

### Example

```

//=========================================================
//These parameters are examples. Please adjust, add or remove them during implementation.
//=========================================================

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
    //Use your photos array here
    print("New photos loaded: \(photos)")
}

```

If you are retriving the content for a sku you'll want to use the `PXLAlbum` class. Create an instance by calling `PXLAlbum(sku:<SKU ID HERE>)`.  As the same as with identifier, you can then set `sortOptions` and `filterOptions` as necessary (see the header files for more details) before calling `loadNextPageOfPhotos:` to load photos.
You can load the photos via the `PXLClient`, You just have to use the `loadNextPageOfPhotosForAlbum(album, completionHandler)`. It will load the album's photos as pages, and calling `loadNextPageOfPhotos:` successively will load each page in turn with returning the newly loaded photos in the completion block, and updating the album's photos array to get all of the photos.

### Example
```

//=========================================================
//These parameters are examples. Please adjust, add or remove them during implementation.
//=========================================================


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
    //Use your photos array here
    print("New photos loaded: \(photos)")
}

```
### Notes

Additionally, you can control how an album loads its data using `PXLAlbumFilterOptions` and `PXLAlbumSortOptions`. To use these, create a new instance with `PXLAlbumFilterOptions()` or `PXLAlbumSortOptions(sortType:SortType, ascending:Boolean)`, set the necessary properties, and then set those objects to the `filterOptions` and `sortOptions` properties on your album. Make sure to set these before calling `loadNextPageOfPhotosForAlbum:`.

Once an album has loaded photos from the server, it will instantiate `PXLPhoto` objects that can be consumed by your UI. `PXLPhoto` exposes all of the data for a photo available through the Pixlee API and offers several image url sizes depending on your needs.

To help you quickly get started, we've also built an album view controller and photo detail view controller that can be used and customized in your app. `PXLAlbumViewController` uses a `UICollectionView` to display the photos in an album and includes a toggle to switch between a grid and list view. Create a `PXLAlbumViewModel` object with your using your `PXLAlbum`.
Example of showing the ViewController
```
let albumVC = PXLAlbumViewController(nibName: "PXLAlbumViewController", bundle: nil)
albumVC.viewModel = PXLAlbumViewModel(album: album)
showViewController(VC: albumVC)
```
The album view controller is set up to automatically load more pages of photos as the user scrolls, giving it an infinite scroll effect.

If a user taps on a photo in the `PXLAlbumViewController`, we present a detail view with `PXLPhotoDetailViewController`. You may present a detail view yourself by instantiating an instance of `PXLPhotoDetailViewController` and setting its `viewModel` property. The photo detail view is configured to display:
* the large photo
* the username of the poster
* a timestamp showing when the photo was posted
* the platform source of the photo (e.g. Instagram)
* the photo's caption (if one is available)
* any products associated with that photo (displayed as a horizontal list of products)
Example of loading the detailViewController
```
let imageDetailsVC = PXLPhotoDetailViewController(nibName: "ImageDetailsViewController", bundle: nil)
let navController = UINavigationController(rootViewController: imageDetailsVC)

imageDetailsVC.viewModel = viewModel?.album.photos[indexPath.row]

present(navController, animated: true) {
```

### Analytics
If you would like to make analyitcs calls you can use our analyitcs service `PXLAnalyitcsService`. What is a singleton, you can reach it as `PXLAnalyitcsService.sharedAnalytics`.
To log an event. You need to instantiate the event's class what is inherited from the `PXLAnalyticsEvent` (listed available types bellow). And pass it to the analyitcs service's `logEvent` method. 
The following events are supported by the sdk:
```
Add to Cart (PXLAnalyticsEventActionClicked): Call this whenever and wherever an add to cart event happens
User Completes Checkout (PXLAnalyticsEventConvertedPhoto): Call this whenever a user completes a checkout and makes a purchase
User Visits a Page with a Pixlee Widget (PXLAnalyticsEventOpenedLightBox): Call this whenever a user visits a page which as a Pixlee Widget on it
User Clicks on the Pixlee Widget (PXLAnalyticsEventOpenedWidget): Call this whenever a user clicks on an item in the Pixlee widget
PXLAlbums:  Load More (PXLAnalyticsEventLoadMoreClicked): Call this whenever a user clicks 'Load More' button on the widget

PXLPhoto: Action Link Clicked (PXLAnalyticsEventActionClicked): Call this whenever a user make an action after clicking on an item in the Pixlee widget

```
#### Example Add to Cart
```
    let currency = "USD"
    let productSKU = "SL-BENJ"
    let quantity = 2
    let price = "13.0"
    let event = PXLAnalyticsEventAddCart(sku: productSKU,
                                         quantity: quantity,
                                         price: price,
                                         currency: currency)
                                         
     //EVENT add:cart refer to pixlee_sdk/PXLAbum.h or The Readme or https://developers.pixlee.com/docs/analytics-events-tracking-pixel-guide
    PXLAnalyitcsService.sharedAnalyitcs.logEvent(event: event) { error in
        guard error == nil else {
            print("There was an error \(error)")
            return
        }
        print("Logged")
    }
```
#### User Completes Checkout
```
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

    let cart1 = PXLAnalyitcsCartContents(price: price, productSKU: productSKU, quantity: quantity)
    let cart2 = PXLAnalyitcsCartContents(price: price2, productSKU: productSKU2, quantity: quantity2)
    let quantityTotal = 7
    let orderId = 234232
    let cartTotal = 18.0

    let cartContents = [cart1, cart2]

    //EVENT converted:photo refer to pixlee_sdk/PXLAbum.h or The Readme or https://developers.pixlee.com/docs/analytics-events-tracking-pixel-guide
    let event = PXLAnalyticsEventConvertedPhoto(cartContents: cartContents, cartTotal: cartTotal, cartTotalQuantity: quantityTotal, orderId: orderId, currency: currency)

    PXLAnalyitcsService.sharedAnalyitcs.logEvent(event: event) { error in
        guard error == nil else {
            print("There was an error \(error)")
            return
        }
        print("Logged")
    }
```
#### Example User Visits a Page with a Pixlee Widget
#### Notes
It's important to trigger this event after the LoadNextPage event
```
    PXLAlbum *album = [PXLAlbum albumWithSkuIdentifier:PXLSkuAlbumIdentifier];
    
    
    // If you are using  https://developers.pixlee.com/reference#get-approved-content-from-album // api/v2/album/@album_id/Photos
    // If you are using api/v2/album/sku_from
    // Refer to pixlee_sdk PXLAbum.h
    [self.album loadNextPageOfPhotosFromSku:^(NSArray *photos, NSError *error){
    //It's important to trigger these events after the LoadNextPage event
        
        //EVENT opened:widget refer to pixlee_sdk/PXLAbum.h or The Readme or https://developers.pixlee.com/docs/analytics-events-tracking-pixel-guide
        [self.album triggerEventOpenedWidget:@"horizontal" callback:^(NSError *error) {
            NSLog(@"logged");
        }];

    }];


```
#### Example User Clicks on the Pixlee Widget
```
       // photo being the PXLPhoto that been clicked 
    PXLPhoto *photo = photo
    
       //EVENT opened:lightbox refer to pixlee_sdk/PXLAbum.h or The Readme or https://developers.pixlee.com/docs/analytics-events-tracking-pixel-guide

     [photo triggerEventOpenedLightbox:^(NSError *error) {
            NSLog(@"logged");
     }];


```

#### Example User make an action after clicking on an Item 
```
[PXLPhoto getPhotoWithId:@"299469263" callback:^(PXLPhoto *photo, NSError *error) {
    

    PXLProduct *p = [photo.products objectAtIndex:0];
    NSString *url = [p.link.absoluteString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"%@",url);

    [photo triggerEventActionClicked:url callback:^(NSError *error) {
    NSLog(@"triggered");
    }];

}];

```

#### Example User click Load more
```
[self.album loadNextPageOfPhotosFromSku:^(NSArray *photos, NSError *error){
NSLog(@"%@",error);
if (photos.count) {
    NSMutableArray *indexPaths = @[].mutableCopy;
    NSInteger firstIndex = [self.album.photos indexOfObject:[photos firstObject]];
    NSLog(@"%@", [self.album.photos objectAtIndex:0]);
    [photos enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSInteger itemNum = firstIndex + idx;
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:itemNum inSection:0];
        [indexPaths addObject:indexPath];
    }];
    [self.albumCollectionView insertItemsAtIndexPaths:indexPaths];
}


[self.album triggerEventLoadMoreClicked:^(NSError *error) {
NSLog(@"logged");
}];




}];

```
#### Uploading an Image to an album

To upload an Image to an album use the class function uploadImage available on PXLALbum class. Do not forget to set your PXLCLIENTSECRETKEY. 

```

///---------------------
/// @name Initialization
///---------------------

/**
 Creates and returns an album with the specified sku identifier.
 
 @param photo_uri image url.albumId is the Pixlee id to upload the image. email the user email. Username of the user uploading the email. approved photo state. connected_user_id optional. callback function.
 
 @return A new `PXLAlbum` object.
 */
+ (NSURLSessionDataTask *)uploadImage:(NSNumber *)albumId :(NSString *)title :(NSString *)email :(NSString *)username  :(NSString *)photo_uri :(BOOL *)approved :(NSString *)connected_user_id callback:(void (^)(NSError *))completionBlock;
```




### Setup Swift Project with Carthage

If you are trying to use the Objective-C Pixlee API with a Swift project please follow these steps, you can also view the sample project available at ~example_swift/:

1. Create a Cartfile that lists the frameworks you’d like to use in your project.
1. Run `carthage update`. This will fetch dependencies into a Carthage/Checkouts folder, then build each one or download a pre-compiled framework.
1. On your application targets’ “General” settings tab, in the “Linked Frameworks and Libraries” section, drag and drop each framework you want to use from the Carthage/Build folder on disk.
1. On your application targets’ “Build Phases” settings tab, click the “+” icon and choose “New Run Script Phase”. Create a Run Script in which you specify your shell (ex: `/bin/sh`), add the following contents to the script area below the shell:




### Adding Pixlee_SDK headers to Swift 
1. Add a bridging_header.h to your current project, follow these steps to create one https://developer.apple.com/documentation/swift/imported_c_and_objective-c_apis/importing_objective-c_into_swift
1. Import the Pixlee sdk header files like this

```
//
//  Use this file to import your target's public headers that you would like to expose to Swift.
//

#import <pixlee_sdk/PXLPhoto.h>
#import <pixlee_sdk/PXLAlbumFilterOptions.h>
#import <pixlee_sdk/PXLAlbumSortOptions.h>
#import <pixlee_sdk/PXLClient.h>
#import <pixlee_sdk/PXLAlbum.h>

```

1. These files are now accessible across all your Swift code and can be use the same way as before.

### Swift example

To load an album from a sku number you can run the following Swift code, please check the example_swift project directory:
```
let album: PXLAlbum = PXLAlbum(skuIdentifier: PXLSkuAlbumIdentifier)
let filterOptions:PXLAlbumFilterOptions = PXLAlbumFilterOptions()
album.filterOptions = filterOptions

// Create and set sort options on the album.
let sortOptions = PXLAlbumSortOptions()
sortOptions.sortType = PXLAlbumSortType.random
sortOptions.ascending = true
album.sortOptions = sortOptions
album.perPage = 1

album.loadNextPageOfPhotos(fromSku:  { photos, error in
if let error = error {
print("\(error)")
}
print(type(of: photos))
if photos?.count != nil {
//                var indexPaths: [AnyHashable] = []
//                var firstIndex: Int? = nil
if let arr = photos as? Array<PXLPhoto> {
for p in arr{
print(p.cdnLargeUrl)

}
print(arr)
}

}

})
```
### Swift Unit tests

To run the tests please go the swift_example project and run the tests on xcode.
Note: Do not forget to set the secret_key and api_key before running the tests.

#### Swift type casting 

Unfortunately the type casting is not fully working when using Objective-C libraries. You will have to cast the return object from the Pixlee API manually like so ``` let arr = photos as? Array<PXLPhoto>```

Check the snipet of code for a full version: 

```
album.loadNextPageOfPhotos(fromSku:  { photos, error in
if let error = error {
print("\(error)")
}
print(type(of: photos)) # Optional<Array<Any>>
if let arr = photos as? Array<PXLPhoto> {

}
})

```


### Important 
If you are using Xcode 10, the new build system doesn't work with the example project. A temporary workaround seems to be switching to the legacy build system by going to (in Xcode) File -> Workspace Settings -> Build System -> Legacy Build System. But compiling with the CLI still doesnt work.


### Example

To run the example project, clone the repo, and run `carthage update` from the Example directory first. Then in `PXLAppDelegate.m` set `PXLClientAPIKey` to your API key (available from the Pixlee dashboard). Then in `PXLExampleAlbumViewController.m` set the album id that you wish to display as `PXLAlbumIdentifier`.

To run the project, open example.xcodeproj in Xcode.

Run the project and you should see a grid of photos from that album.

## Troubleshooting

If you get an error running `carthage update` on osx please clear your carthage cache by doing 
`rm -rf ~/Library/Caches/org.carthage.CarthageKit`. 

## License

pixlee-ios-sdk is available under the MIT license.
