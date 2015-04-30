//
//  PXLClient.m
//  Pods
//
//  Created by Tim Shi on 4/30/15.
//
//

#import "PXLClient.h"

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

@end
