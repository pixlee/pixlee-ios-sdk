//
//  PXLAppDelegate.m
//  pixlee-ios-sdk
//
//  Created by CocoaPods on 04/30/2015.
//  Copyright (c) 2014 Tim Shi. All rights reserved.
//

#import "PXLAppDelegate.h"

#import <pixlee-ios-sdk/PXLClient.h>
#import <pixlee-ios-sdk/PXLAlbum.h>

@implementation PXLAppDelegate

static NSString * const PXLClientAPIKey = @"ye52amOyfyrMtIPYIkE";

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[PXLClient sharedClient] setApiKey:PXLClientAPIKey];
    return YES;
}

@end
