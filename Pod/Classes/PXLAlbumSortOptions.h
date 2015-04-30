//
//  PXLAlbumSortOptions.h
//  Pods
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

@interface PXLAlbumSortOptions : NSObject

@property (nonatomic) PXLAlbumSortType sortType;
@property (nonatomic) BOOL ascending;

- (NSString *)urlParamString;

@end
