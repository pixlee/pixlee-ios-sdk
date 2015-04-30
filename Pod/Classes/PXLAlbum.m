//
//  PXLAlbum.m
//  Pods
//
//  Created by Tim Shi on 4/30/15.
//
//

#import "PXLAlbum.h"

#import "PXLClient.h"
#import "PXLPhoto.h"

@interface PXLAlbum ()

@property (nonatomic, strong) NSArray *photos;
@property (nonatomic) NSInteger lastPageFetched;
@property (nonatomic) BOOL hasNextPage;

@end

@implementation PXLAlbum

+ (instancetype)albumWithIdentifier:(NSString *)identifier {
    PXLAlbum *album = [self new];
    album.identifier = identifier;
    return album;
}

- (instancetype)init {
    self = [super init];
    self.perPage = NSNotFound;
    self.lastPageFetched = NSNotFound;
    self.hasNextPage = YES;
    self.photos = @[];
    return self;
}

- (void)setSortOptions:(PXLAlbumSortOptions *)sortOptions {
    _sortOptions = sortOptions;
    [self clearPhotosAndPages];
}

- (void)setFilterOptions:(PXLAlbumFilterOptions *)filterOptions {
    _filterOptions = filterOptions;
    [self clearPhotosAndPages];
}

- (void)clearPhotosAndPages {
    self.photos = @[];
    self.lastPageFetched = NSNotFound;
    self.hasNextPage = YES;
}

- (NSURLSessionDataTask *)loadNextPageOfPhotos:(void (^)(NSArray *photos, NSError *error))completionBlock {
    static NSString * const PXLAlbumGETRequestString = @"albums/%@/photos";
    if (self.hasNextPage) {
        NSString *requestString = [NSString stringWithFormat:PXLAlbumGETRequestString, self.identifier];
        NSMutableDictionary *params = @{}.mutableCopy;
        if (self.sortOptions) {
            params[@"sort"] = [self.sortOptions urlParamString];
        }
        if (self.filterOptions) {
            params[@"filter"] = [self.filterOptions urlParamString];
        }
        return [[PXLClient sharedClient] GET:requestString parameters:params success:^(NSURLSessionDataTask * __unused task, id responseObject) {
            NSArray *responsePhotos = responseObject[@"data"];
            NSArray *photos = [PXLPhoto photosFromArray:responsePhotos inAlbum:self];
            self.lastPageFetched = [responseObject[@"page"] integerValue];
            self.hasNextPage = [responseObject[@"next"] boolValue];
            if (photos) {
                NSMutableArray *mutablePhotos = self.photos.mutableCopy;
                [mutablePhotos addObjectsFromArray:photos];
                self.photos = mutablePhotos;
            }
            completionBlock(photos, nil);
        } failure:^(NSURLSessionDataTask * __unused task, NSError *error) {
            if (completionBlock) {
                completionBlock(nil, error);
            }
        }];
    } else {
        completionBlock(nil, nil);
        return nil;
    }
}

@end
