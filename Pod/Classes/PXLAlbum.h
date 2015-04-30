//
//  PXLAlbum.h
//  Pods
//
//  Created by Tim Shi on 4/30/15.
//
//

#import <Foundation/Foundation.h>

@interface PXLAlbum : NSObject

@property (nonatomic, copy) NSString *identifier;
@property (nonatomic) NSInteger perPage;
@property (nonatomic, readonly) NSArray *photos;
@property (nonatomic, readonly) NSInteger lastPageFetched;

+ (instancetype)albumWithIdentifier:(NSString *)identifier;

@end
