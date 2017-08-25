//
//  PXLAlbumSortOptions.h
//  pixlee-ios-sdk
//
//  Created by Tim Shi on 4/30/15.
//
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, PXLAlbumSortType) {
    PXLAlbumSortTypeRecency,
    PXLAlbumSortTypeRandom,
    PXLAlbumSortTypePixleeShares,
    PXLAlbumSortTypePixleeLikes,
    PXLAlbumSortTypePopularity,
    PXLAlbumSortTypePhotoRank,
    PXLAlbumSortTypeNone
};

/**
 `PXLAlbumSortOptions` is used to control how an album sorts the photos it loads. Create an instance of this class and set it to an album to control the options available as properties of this class.
 */

@interface PXLAlbumSortOptions : NSObject

@property (nonatomic) PXLAlbumSortType sortType;
@property (nonatomic) BOOL ascending;

- (NSString *)urlParamString;

@end
