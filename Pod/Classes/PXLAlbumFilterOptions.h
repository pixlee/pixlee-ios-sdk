//
//  PXLAlbumFilterOptions.h
//  pixlee-ios-sdk
//
//  Created by Tim Shi on 4/30/15.
//
//

#import <Foundation/Foundation.h>

/**
 `PXLAlbumFilterOptions` is used to control how an album filters the photos it loads. Create an instance of this class and set it to an album to control the options available as properties of this class.
 */

@interface PXLAlbumFilterOptions : NSObject

@property (nonatomic) NSUInteger minInstagramFollowers;
@property (nonatomic) NSUInteger minTwitterFollowers;
@property (nonatomic) BOOL deniedPhotos;
@property (nonatomic) BOOL starredPhotos;
@property (nonatomic) BOOL deletedPhotos;
@property (nonatomic) BOOL flaggedPhotos;
@property (nonatomic, strong) NSMutableArray *contentSource;
@property (nonatomic, strong) NSMutableArray *contentType;
@property (nonatomic, copy) NSString *filterBySubcaption;
@property (nonatomic) BOOL hasActionLink;
@property (nonatomic, strong) NSDate *submittedDateStart;
@property (nonatomic, strong) NSDate *submittedDateEnd;

- (NSString *)urlParamString;

@end
