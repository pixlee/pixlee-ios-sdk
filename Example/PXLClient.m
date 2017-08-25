//
//  PXLClient.m
//  pixlee-ios-sdk
//
//  Created by Tim Shi on 4/30/15.
//
//

#import "PXLClient.h"

@interface PXLClient ()

@property (nonatomic, copy) NSString *_apiKey;

@end

@implementation PXLClient

static NSString * const PXLClientBaseUrlString = @"https://distillery.pixlee.com/api/v2/";

+ (instancetype)sharedClient {
    static PXLClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[self alloc] initWithBaseURL:[NSURL URLWithString:PXLClientBaseUrlString]];
        _sharedClient.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    });
    
    return _sharedClient;
}

- (void)setApiKey:(NSString *)apiKey {
    self._apiKey = apiKey;
}

- (NSURLSessionDataTask *)GET:(NSString *)URLString parameters:(id)parameters success:(void (^)(NSURLSessionDataTask *, id))success failure:(void (^)(NSURLSessionDataTask *, NSError *))failure {
    NSAssert(self._apiKey != nil, @"Your Pixlee API Key must be set before making API calls.");
    if (parameters == nil || [parameters isKindOfClass:[NSDictionary class]]) {
        NSMutableDictionary *mutableParams = parameters ? ((NSDictionary *)parameters).mutableCopy : @{}.mutableCopy;
        mutableParams[@"api_key"] = self._apiKey;
        parameters = mutableParams;
    }
    return [super GET:URLString parameters:parameters success:success failure:failure];
}

@end
