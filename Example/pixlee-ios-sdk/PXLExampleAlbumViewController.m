//
//  PXLViewController.m
//  pixlee-ios-sdk
//
//  Created by Tim Shi on 04/30/2015.
//

#import "PXLExampleAlbumViewController.h"
#import "pixlee-ios-sdk/PXLAlbum.h"
#import "pixlee-ios-sdk/PXLAlbumFilterOptions.h"
#import "pixlee-ios-sdk/PXLAlbumSortOptions.h"
#import "pixlee-ios-sdk/PXLClient.h"

@interface PXLExampleAlbumViewController ()

@end

@implementation PXLExampleAlbumViewController

#warning Replace with your Pixlee album identifier.

static NSString * const PXLAlbumIdentifier = @"<YOUR ALBUM IDENTIFIER HERE>";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Create a new album instance.
    PXLAlbum *album = [PXLAlbum albumWithIdentifier:PXLAlbumIdentifier];
    
    // Create and set filter options on the album.
    PXLAlbumFilterOptions *filterOptions = [PXLAlbumFilterOptions new];
    filterOptions.submittedDateStart = [[NSDate date] dateByAddingTimeInterval:-60 * 60 * 24 * 20]; // submitted within the last 20 days
    album.filterOptions = filterOptions;
    
    // Create and set sort options on the album.
    PXLAlbumSortOptions *sortOptions = [PXLAlbumSortOptions new];
    sortOptions.sortType = PXLAlbumSortTypePhotoRank;
    album.sortOptions = sortOptions;
    
    // Set the album to load.
    self.album = album;
    [self loadNextPageOfPhotos];
}

@end
