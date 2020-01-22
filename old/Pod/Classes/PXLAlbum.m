//
//  PXLAlbum.m
//  pixlee-ios-sdk
//
//  Created by Tim Shi on 4/30/15.
//
//

#import "PXLAlbum.h"

#import "PXLClient.h"
#import "PXLPhoto.h"

@interface PXLAlbum ()

@property (nonatomic, copy) NSString *identifier;
@property (nonatomic, strong) NSArray *photos;
@property (nonatomic) NSInteger lastPageFetched;
@property (nonatomic) BOOL hasNextPage;
@property (nonatomic, strong) NSMutableDictionary *loadingOperations;

@end

@implementation PXLAlbum

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

- (void)setPerPage:(NSInteger)perPage {
    _perPage = perPage;
    [self clearPhotosAndPages];
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
    // make sure there's more content to load
    if (self.hasNextPage) {
        NSInteger nextPage = self.lastPageFetched == NSNotFound ? 1 : self.lastPageFetched + 1;
        // make sure we aren't already loading that page
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
                    // add filler photos if necessary (in the case that page 2 loads before page 1)
                    if (mutablePhotos.count != self.perPage * (nextPage - 1)) {
                        NSInteger numPhotosToAdd = (self.perPage * (nextPage - 1)) - mutablePhotos.count;
                        for (int i = 0; i < numPhotosToAdd; i++) {
                            [mutablePhotos addObject:[PXLPhoto new]];
                        }
                    }
                    [mutablePhotos addObjectsFromArray:photos];
                    self.photos = mutablePhotos;
                }
                // release the data task by replacing it with a BOOL
                self.loadingOperations[@(nextPage)] = @YES;
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
