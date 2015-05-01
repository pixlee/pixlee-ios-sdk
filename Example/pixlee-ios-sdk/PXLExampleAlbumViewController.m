//
//  PXLViewController.m
//  pixlee-ios-sdk
//
//  Created by Tim Shi on 04/30/2015.
//  Copyright (c) 2014 Tim Shi. All rights reserved.
//

#import "PXLExampleAlbumViewController.h"
#import <pixlee-ios-sdk/PXLClient.h>
#import <pixlee-ios-sdk/PXLAlbum.h>

@interface PXLExampleAlbumViewController ()

@end

@implementation PXLExampleAlbumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    PXLAlbum *album = [PXLAlbum new];
    album.identifier = @"123254";
    self.album = album;
    [self loadNextPageOfPhotos];
}

@end
