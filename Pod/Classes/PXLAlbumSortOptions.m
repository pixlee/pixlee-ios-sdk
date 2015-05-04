//
//  PXLAlbumSortOptions.m
//  pixlee-ios-sdk
//
//  Created by Tim Shi on 4/30/15.
//
//

#import "PXLAlbumSortOptions.h"

@implementation PXLAlbumSortOptions

- (instancetype)init {
    self = [super init];
    if (self) {
        self.sortType = PXLAlbumSortTypeNone;
        self.ascending = YES;
    }
    return self;
}

- (NSArray *)sortTypeKeys {
    static NSArray *sortTypeKeys = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sortTypeKeys = @[
                         @"recency",
                         @"random",
                         @"pixlee_shares",
                         @"pixlee_likes",
                         @"popularity",
                         @"photorank"
                         ];
    });
    return sortTypeKeys;
}

- (NSString *)urlParamString {
    NSMutableDictionary *options = @{}.mutableCopy;
    if (!self.ascending) {
        options[@"desc"] = @YES;
    }
    if (self.sortType != PXLAlbumSortTypeNone) {
        NSString *key = [self sortTypeKeys][self.sortType];
        options[key] = @YES;
    }
    NSData *optionsData = [NSJSONSerialization dataWithJSONObject:options options:0 error:nil];
    NSString *optionsString = [[NSString alloc] initWithData:optionsData encoding:NSUTF8StringEncoding];
    return optionsString;
}

@end
