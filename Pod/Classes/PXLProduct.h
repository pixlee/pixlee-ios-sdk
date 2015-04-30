//
//  PXLProduct.h
//  Pods
//
//  Created by Tim Shi on 4/30/15.
//
//

#import <Foundation/Foundation.h>

@class PXLPhoto;

@interface PXLProduct : NSObject

@property (nonatomic, copy) NSString *identifier;
@property (nonatomic, strong) PXLPhoto *photo;
@property (nonatomic, copy) NSString *linkText;
@property (nonatomic, strong) NSURL *link;
@property (nonatomic, strong) NSURL *imageUrl;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *sku;
@property (nonatomic, copy) NSString *productDescription;

+ (NSArray *)productsFromArray:(NSArray *)array withPhoto:(PXLPhoto *)photo;
+ (instancetype)productFromDictionary:(NSDictionary *)dict withPhoto:(PXLPhoto *)photo;

@end
