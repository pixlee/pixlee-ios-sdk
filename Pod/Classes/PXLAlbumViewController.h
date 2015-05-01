//
//  PXLAlbumViewController.h
//  Pods
//
//  Created by Tim Shi on 4/30/15.
//
//

#import <UIKit/UIKit.h>

@interface PXLAlbumViewController : UIViewController

@property (nonatomic, readonly) UICollectionView *albumCollectionView;

+ (instancetype)albumViewControllerWithAlbumId:(NSString *)albumId;

@end
