//
//  PXLAlbumFilterOptions.m
//  pixlee-ios-sdk
//
//  Created by Tim Shi on 4/30/15.
//
//

#import "PXLAlbumFilterOptions.h"

@implementation PXLAlbumFilterOptions

- (NSString *)urlParamString {
    NSMutableDictionary *options = @{}.mutableCopy;
    
    options[@"min_instagram_followers"] = @(self.minInstagramFollowers);
    options[@"min_twitter_followers"] = @(self.minTwitterFollowers);
    options[@"denied_photos"] = @(self.deniedPhotos);
    options[@"starred_photos"] = @(self.starredPhotos);
    options[@"deleted_photos"] = @(self.deletedPhotos);
    options[@"flagged_photos"] = @(self.flaggedPhotos);
    if (self.contentSource) {
        options[@"content_source"] = self.contentSource;
    }
    if (self.contentType) {
        options[@"content_type"] = self.contentType;
    }
    if (self.filterBySubcaption) {
        options[@"filter_by_subcaption"] = self.filterBySubcaption;
    }
    options[@"has_action_link"] = @(self.hasActionLink);
    if (self.submittedDateStart) {
        options[@"submitted_date_start"] = @([self.submittedDateStart timeIntervalSince1970] * 1000);
    }
    if (self.submittedDateEnd) {
        options[@"submitted_date_end"] = @([self.submittedDateEnd timeIntervalSince1970] * 1000);
    }
    
    NSData *optionsData = [NSJSONSerialization dataWithJSONObject:options options:0 error:nil];
    NSString *optionsString = [[NSString alloc] initWithData:optionsData encoding:NSUTF8StringEncoding];
    return optionsString;
}

@end
