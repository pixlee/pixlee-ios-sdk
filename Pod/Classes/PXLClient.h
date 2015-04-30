//
//  PXLClient.h
//  Pods
//
//  Created by Tim Shi on 4/30/15.
//
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

@interface PXLClient : AFHTTPSessionManager

+ (instancetype)sharedClient;
- (void)setApiKey:(NSString *)apiKey;

@end
