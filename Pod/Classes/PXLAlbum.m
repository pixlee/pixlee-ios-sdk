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
    return self;
}

- (NSURLSessionDataTask *)loadNextPageOfPhotos:(void (^)(NSArray *photos, NSError *error))completionBlock {
    static NSString * const PXLAlbumGETRequestString = @"albums/%@/photos";
    NSString *requestString = [NSString stringWithFormat:PXLAlbumGETRequestString, self.identifier];
    return [[PXLClient sharedClient] GET:requestString parameters:nil success:^(NSURLSessionDataTask * __unused task, id responseObject) {
        NSArray *responsePhotos = responseObject[@"data"];
        NSArray *photos = [PXLPhoto photosFromArray:responsePhotos inAlbum:self];
        completionBlock(photos, nil);
    } failure:^(NSURLSessionDataTask * __unused task, NSError *error) {
        if (completionBlock) {
            completionBlock(nil, error);
        }
    }];
}

@end
