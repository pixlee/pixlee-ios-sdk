//
//  PXLProduct.m
//  Pods
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
    product.title = [self valueOrNilFromDict:dict forKey:@"title"];
    product.sku = [self valueOrNilFromDict:dict forKey:@"sku"];
    product.productDescription = [self valueOrNilFromDict:dict forKey:@"description"];
    return product;
}

+ (id)valueOrNilFromDict:(NSDictionary *)dict forKey:(NSString *)key {
    id value = dict[key];
    if ([value isKindOfClass:[NSNull class]]) {
        value = nil;
    }
    return value;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<Product:%@ %@>", self.identifier, self.title];
}

@end
