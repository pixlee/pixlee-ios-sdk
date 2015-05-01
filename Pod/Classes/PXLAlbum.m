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
@property (nonatomic, strong) NSMutableDictionary *loadingOperations;

@end

@implementation PXLAlbum

// HOW TO DEAL WITH PAGING
// 1. keep a dictionary of the loading operations keyed by page num
// 2. when a loading op completes, fill in index gaps with blank PXLPhoto objects if necessary
// 3. add photos to their correct indices
// 4. keep track of loaded pages to prevent reloads

const NSInteger PXLAlbumDefaultPerPage = 30;

+ (instancetype)albumWithIdentifier:(NSString *)identifier {
    PXLAlbum *album = [self new];
    album.identifier = identifier;
    return album;
}

- (instancetype)init {
    self = [super init];
    self.perPage = PXLAlbumDefaultPerPage;
    self.lastPageFetched = NSNotFound;
    self.hasNextPage = YES;
    self.photos = @[];
    self.loadingOperations = @{}.mutableCopy;
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
    [self.loadingOperations removeAllObjects];
}

- (NSURLSessionDataTask *)loadNextPageOfPhotos:(void (^)(NSArray *photos, NSError *error))completionBlock {
    static NSString * const PXLAlbumGETRequestString = @"albums/%@/photos";
    if (self.hasNextPage) {
        NSInteger nextPage = self.lastPageFetched == NSNotFound ? 1 : self.lastPageFetched + 1;
        if (!self.loadingOperations[@(nextPage)]) {
            NSString *requestString = [NSString stringWithFormat:PXLAlbumGETRequestString, self.identifier];
            NSMutableDictionary *params = @{}.mutableCopy;
            if (self.sortOptions) {
                params[@"sort"] = [self.sortOptions urlParamString];
            }
            if (self.filterOptions) {
                params[@"filter"] = [self.filterOptions urlParamString];
            }
            if (self.lastPageFetched != NSNotFound) {
                params[@"page"] = @(self.lastPageFetched + 1);
            }
            NSURLSessionDataTask *dataTask = [[PXLClient sharedClient] GET:requestString parameters:params success:^(NSURLSessionDataTask * __unused task, id responseObject) {
                NSArray *responsePhotos = responseObject[@"data"];
                NSArray *photos = [PXLPhoto photosFromArray:responsePhotos inAlbum:self];
                if (self.lastPageFetched == NSNotFound) {
                    self.lastPageFetched = [responseObject[@"page"] integerValue];
                } else {
                    self.lastPageFetched = MAX(self.lastPageFetched, [responseObject[@"page"] integerValue]);
                }
                self.hasNextPage = [responseObject[@"next"] boolValue];
                if (photos) {
                    NSMutableArray *mutablePhotos = self.photos.mutableCopy;
                    if (mutablePhotos.count != self.perPage * (nextPage - 1)) {
                        NSInteger numPhotosToAdd = (self.perPage * (nextPage - 1)) - mutablePhotos.count;
                        for (int i = 0; i < numPhotosToAdd; i++) {
                            [mutablePhotos addObject:[PXLPhoto new]];
                        }
                    }
                    [mutablePhotos addObjectsFromArray:photos];
                    self.photos = mutablePhotos;
                }
                completionBlock(photos, nil);
            } failure:^(NSURLSessionDataTask * __unused task, NSError *error) {
                if (completionBlock) {
                    completionBlock(nil, error);
                }
            }];
            self.loadingOperations[@(nextPage)] = dataTask;
            return dataTask;
        } else {
            completionBlock(nil, nil);
            return nil;
        }
    } else {
        completionBlock(nil, nil);
        return nil;
    }
}

@end
