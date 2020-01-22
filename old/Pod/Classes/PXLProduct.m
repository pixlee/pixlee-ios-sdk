//
//  PXLProduct.m
//  pixlee-ios-sdk
//
//  Created by Tim Shi on 4/30/15.
//
//

#import "PXLProduct.h"

@implementation PXLProduct

+ (NSArray *)productsFromArray:(NSArray *)array withPhoto:(PXLPhoto *)photo {
    NSMutableArray *products = @[].mutableCopy;
    for (NSDictionary *dict in array) {
        PXLProduct *product = [self productFromDictionary:dict withPhoto:photo];
        [products addObject:product];
    }
    return products;
}

+ (instancetype)productFromDictionary:(NSDictionary *)dict withPhoto:(PXLPhoto *)photo {
    NSMutableDictionary *filteredDict = dict.mutableCopy;
    [dict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if ([obj isKindOfClass:[NSNull class]]) {
            [filteredDict removeObjectForKey:key];
        }
    }];
    dict = filteredDict;
    PXLProduct *product = [self new];
    product.identifier = dict[@"id"];
    product.photo = photo;
    product.linkText = dict[@"link_text"];
    if (dict[@"link"]) {
        product.link = [NSURL URLWithString:dict[@"link"]];
    }
    if (dict[@"image"]) {
        product.imageUrl = [NSURL URLWithString:dict[@"image"]];
    }
    product.title = dict[@"title"];
    product.sku = dict[@"sku"];
    product.productDescription = dict[@"description"];
    return product;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<PXLProduct:%@ %@>", self.identifier, self.title];
}

@end
