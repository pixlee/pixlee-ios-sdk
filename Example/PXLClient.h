//
//  PXLClient.h
//  pixlee-ios-sdk
//
//  Created by Tim Shi on 4/30/15.
//
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

/**
 `PXLClient` wraps the Pixlee API and is used by `PXLAlbum` to load photos from the server. You must set the API Key before making any API calls.
 */

@interface PXLClient : AFHTTPSessionManager

/**
 Creates and returns the singleton `PXLClient` instance.
 */
+ (instancetype)sharedClient;

/**
 Sets the API Key for communicating with the Pixlee servers.
 
 @warning You must set the API Key before making calls to the Pixlee API.
 
 @param apiKey The API key used to access your albums.
 */
- (void)setApiKey:(NSString *)apiKey;

@end
