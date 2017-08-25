//
//  PXLProductCollectionViewCell.h
//  pixlee-ios-sdk
//
//  Created by Tim Shi on 5/4/15.
//
//

#import <UIKit/UIKit.h>

@class PXLProduct;

@interface PXLProductCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) PXLProduct *product;
@property (nonatomic, copy) void (^actionButtonPressedForProduct)(PXLProduct *product);

+ (NSString *)defaultIdentifier;
+ (void)registerWithCollectionView:(UICollectionView *)collectionView;

@end
