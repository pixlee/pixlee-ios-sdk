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

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [[PXLClient sharedClient] setApiKey:@"ye52amOyfyrMtIPYIkE"];
    PXLAlbum *album = [PXLAlbum albumWithIdentifier:@"123254"];
    PXLAlbumSortOptions *sortOptions = [PXLAlbumSortOptions new];
    sortOptions.ascending = NO;
    sortOptions.sortType = PXLAlbumSortTypePhotoRank;
    PXLAlbumFilterOptions *filterOptions = [PXLAlbumFilterOptions new];
    filterOptions.minInstagramFollowers = 0;
    album.sortOptions = sortOptions;
    album.filterOptions = filterOptions;
    [album loadNextPageOfPhotos:^(NSArray *photos, NSError *error) {
        NSLog(@"%@", photos);
    }];
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
