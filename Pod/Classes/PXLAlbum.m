//
//  PXLAlbum.m
//  Pods
//
//  Created by Tim Shi on 4/30/15.
//
//

#import "PXLAlbum.h"

@interface PXLAlbum ()

@property (nonatomic, strong) NSArray *photos;
@property (nonatomic) NSInteger lastPageFetched;

@end

@implementation PXLAlbum

+ (instancetype)albumWithIdentifier:(NSString *)identifier {
    PXLAlbum *album = [self new];
    album.identifier = identifier;
    return album;
}

@end
