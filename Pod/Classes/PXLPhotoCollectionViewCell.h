//
//  PXLPhotoCollectionViewCell.h
//  pixlee-ios-sdk
//
//  Created by Tim Shi on 4/30/15.
//
//

#import <UIKit/UIKit.h>

#import "PXLPhoto.h"

@interface PXLPhotoCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) PXLPhoto *photo;
@property (nonatomic) PXLPhotoSize photoSize;

+ (NSString *)defaultIdentifier;
+ (void)registerWithCollectionView:(UICollectionView *)collectionView;

@end
