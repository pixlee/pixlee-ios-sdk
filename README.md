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

### Example

To run the example project, clone the repo, and run `pod install` from the Example directory first. Then in `PXLAppDelegate.m` set `PXLClientAPIKey` to your API key (available from the Pixlee dashboard). Then in `PXLExampleAlbumViewController.m` set the album id that you wish to display as `PXLAlbumIdentifier`. 



## License

pixlee-ios-sdk is available under the MIT license. See the LICENSE file for more info.
