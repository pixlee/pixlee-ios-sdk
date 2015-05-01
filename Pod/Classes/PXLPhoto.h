//
//  PXLPhoto.h
//  Pods
//
//  Created by Tim Shi on 4/30/15.
//
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

typedef NS_ENUM(NSInteger, PXLPhotoSize) {
    PXLPhotoSizeThumbnail,
    PXLPhotoSizeMedium,
    PXLPhotoSizeBig
};

@class PXLAlbum;

@interface PXLPhoto : NSObject

@property (nonatomic, copy) NSString *identifier;
@property (nonatomic, copy) NSString *photoTitle;
@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic, strong) NSDate *taggedAt;
@property (nonatomic, copy) NSString *emailAddress;
@property (nonatomic) NSInteger instagramFollowers;
@property (nonatomic) NSInteger twitterFollowers;
@property (nonatomic, strong) NSURL *avatarUrl;
@property (nonatomic, copy) NSString *username;
@property (nonatomic) NSInteger connectedUserId;
@property (nonatomic, copy) NSString *source;
@property (nonatomic, copy) NSString *contentType;
@property (nonatomic, copy) NSString *dataFileName;
@property (nonatomic, strong) NSURL *mediumUrl;
@property (nonatomic, strong) NSURL *bigUrl;
@property (nonatomic, strong) NSURL *thumbnailUrl;
@property (nonatomic, strong) NSURL *sourceUrl;
@property (nonatomic, copy) NSString *mediaId;
@property (nonatomic) NSInteger existIn;
@property (nonatomic, copy) NSString *collectTerm;
@property (nonatomic, copy) NSString *albumPhotoId;
@property (nonatomic) NSInteger likeCount;
@property (nonatomic) NSInteger shareCount;
@property (nonatomic, strong) NSURL *actionLink;
@property (nonatomic, copy) NSString *actionLinkText;
@property (nonatomic, copy) NSString *actionLinkTitle;
@property (nonatomic, copy) NSString *actionLinkPhoto;
@property (nonatomic, strong) NSDate *updatedAt;
@property (nonatomic) BOOL isStarred;
@property (nonatomic) BOOL approved;
@property (nonatomic) BOOL archived;
@property (nonatomic) BOOL isFlagged;
@property (nonatomic, strong) PXLAlbum *album;
@property (nonatomic) NSInteger unreadCount;
@property (nonatomic, strong) NSURL *albumActionLink;
@property (nonatomic, copy) NSString *title;
@property (nonatomic) BOOL messaged;
@property (nonatomic) BOOL hasPermission;
@property (nonatomic) BOOL awaitingPermission;
@property (nonatomic) BOOL instUserHasLiked;
@property (nonatomic, strong) NSURL *platformLink;
@property (nonatomic, strong) NSArray *products;

+ (NSArray *)photosFromArray:(NSArray *)array inAlbum:(PXLAlbum *)album;
+ (instancetype)photoFromDict:(NSDictionary *)dict inAlbum:(PXLAlbum *)album;
- (NSURL *)photoUrlForSize:(PXLPhotoSize)photoSize;

@end
