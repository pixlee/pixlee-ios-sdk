//
//  PXLAlbum.h
//  Pods
//
//  Created by Tim Shi on 4/30/15.
//
//

#import <Foundation/Foundation.h>

#import "PXLAlbumSortOptions.h"
#import "PXLAlbumFilterOptions.h"

@interface PXLAlbum : NSObject

@property (nonatomic, copy) NSString *identifier;
@property (nonatomic) NSInteger perPage;
@property (nonatomic, readonly) NSArray *photos;
@property (nonatomic, readonly) NSInteger lastPageFetched;
@property (nonatomic, readonly) BOOL hasNextPage;

// setting either of these properties clears the stored photos and the last page fetched.
@property (nonatomic, strong) PXLAlbumSortOptions *sortOptions;
@property (nonatomic, strong) PXLAlbumFilterOptions *filterOptions;

+ (instancetype)albumWithIdentifier:(NSString *)identifier;
- (NSURLSessionDataTask *)loadNextPageOfPhotos:(void (^)(NSArray *photos, NSError *error))completionBlock;

@end
