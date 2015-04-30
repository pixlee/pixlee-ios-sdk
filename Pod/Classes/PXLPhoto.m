//
//  PXLPhoto.m
//  Pods
//
//  Created by Tim Shi on 4/30/15.
//
//

#import "PXLPhoto.h"

#import "PXLProduct.h"

@implementation PXLPhoto

+ (instancetype)photoFromDict:(NSDictionary *)dict inAlbum:(PXLAlbum *)album {
    PXLPhoto *photo = [self new];
    photo.identifier = dict[@"id"];
    photo.photoTitle = dict[@"photo_title"];
    if ([dict[@"latitude"] isKindOfClass:[NSNumber class]] && [dict[@"longitude"] isKindOfClass:[NSNumber class]]) {
        CLLocationDegrees latitude = [dict[@"latitude"] doubleValue];
        CLLocationDegrees longitude = [dict[@"longitude"] doubleValue];
        photo.coordinate = CLLocationCoordinate2DMake(latitude, longitude);
    }
    photo.taggedAt = [NSDate dateWithTimeIntervalSince1970:([dict[@"tagged_at"] doubleValue] / 1000)];
    photo.emailAddress = [self valueOrNilFromDict:dict forKey:@"email_address"];
    photo.instagramFollowers = [dict[@"instagram_followers"] integerValue];
    photo.twitterFollowers = [dict[@"twitter_followers"] integerValue];
    photo.avatarUrl = [self nilSafeUrlFromDict:dict forKey:@"avatar_url"];
    photo.username = dict[@"user_name"];
    photo.connectedUserId = [dict[@"connected_user_id"] integerValue];
    photo.source = dict[@"source"];
    photo.contentType = dict[@"content_type"];
    photo.dataFileName = dict[@"data_file_name"];
    photo.mediumUrl = [self nilSafeUrlFromDict:dict forKey:@"medium_url"];
    photo.bigUrl = [self nilSafeUrlFromDict:dict forKey:@"big_url"];
    photo.thumbnailUrl = [self nilSafeUrlFromDict:dict forKey:@"thumbnail_url"];
    photo.sourceUrl = [self nilSafeUrlFromDict:dict forKey:@"source_url"];
    photo.mediaId = dict[@"media_id"];
    photo.existIn = [dict[@"exist_in"] integerValue];
    photo.collectTerm = dict[@"collect_term"];
    photo.albumPhotoId = dict[@"album_photo_id"];
    photo.likeCount = [dict[@"like_count"] integerValue];
    photo.shareCount = [dict[@"share_count"] integerValue];
    photo.actionLink = [self nilSafeUrlFromDict:dict forKey:@"action_link"];
    photo.actionLinkText = [self valueOrNilFromDict:dict forKey:@"action_link_text"];
    photo.actionLinkTitle = [self valueOrNilFromDict:dict forKey:@"action_link_title"];
    photo.actionLinkPhoto = [self valueOrNilFromDict:dict forKey:@"action_link_photo"];
    photo.updatedAt = [NSDate dateWithTimeIntervalSince1970:([dict[@"updated_at"] doubleValue] / 1000)];
    photo.isStarred = [dict[@"is_starred"] boolValue];
    photo.approved = [dict[@"approved"] boolValue];
    photo.archived = [dict[@"archived"] boolValue];
    photo.isFlagged = [dict[@"is_flagged"] boolValue];
    photo.album = album;
    photo.unreadCount = [dict[@"unread_count"] integerValue];
    photo.albumActionLink = [self nilSafeUrlFromDict:dict forKey:@"album_action_link"];
    photo.title = dict[@"title"];
    photo.messaged = [dict[@"messaged"] boolValue];
    photo.hasPermission = [dict[@"has_permission"] boolValue];
    photo.awaitingPermission = [dict[@"awaiting_permission"] boolValue];
    photo.instUserHasLiked = [dict[@"inst_user_has_liked"] boolValue];
    photo.platformLink = [self nilSafeUrlFromDict:dict forKey:@"platform_link"];
    photo.products = [PXLProduct productsFromArray:dict[@"products"] withPhoto:photo];
    return photo;
}

+ (id)valueOrNilFromDict:(NSDictionary *)dict forKey:(NSString *)key {
    id value = dict[key];
    if ([value isKindOfClass:[NSNull class]]) {
        value = nil;
    }
    return value;
}

+ (NSURL *)nilSafeUrlFromDict:(NSDictionary *)dict forKey:(NSString *)key {
    NSString *urlString = dict[@"key"];
    if (urlString) {
        return [NSURL URLWithString:urlString];
    }
    return nil;
}

@end
