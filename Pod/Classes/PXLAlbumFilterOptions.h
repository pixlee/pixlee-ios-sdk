//
//  PXLAlbumFilterOptions.h
//  Pods
//
//  Created by Tim Shi on 4/30/15.
//
//

#import <Foundation/Foundation.h>

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
