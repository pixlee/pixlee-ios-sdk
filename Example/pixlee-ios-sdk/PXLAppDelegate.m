//
//  PXLAppDelegate.m
//  pixlee-ios-sdk
//
//  Created by CocoaPods on 04/30/2015.
//

#import "PXLAppDelegate.h"

#import "pixlee-ios-sdk/PXLClient.h"
#import "pixlee-ios-sdk/PXLAlbum.h"

@implementation PXLAppDelegate

#warning Replace with your Pixlee API key.
static NSString * const PXLClientAPIKey = @"<YOUR PIXLEE CLIENT KEY HERE>";

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[PXLClient sharedClient] setApiKey:PXLClientAPIKey];
    return YES;
}

@end
