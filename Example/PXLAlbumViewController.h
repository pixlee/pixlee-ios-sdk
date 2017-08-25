//
//  PXLAlbumViewController.h
//  pixlee-ios-sdk
//
//  Created by Tim Shi on 4/30/15.
//
//

#import <UIKit/UIKit.h>

#import "PXLAlbum.h"

@interface PXLAlbumViewController : UIViewController

@property (nonatomic, readonly) UICollectionView *albumCollectionView;
@property (nonatomic, strong) PXLAlbum *album;

+ (instancetype)albumViewControllerWithAlbumId:(NSString *)albumId;
- (void)loadNextPageOfPhotos;

@end
