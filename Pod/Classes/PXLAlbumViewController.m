//
//  PXLAlbumViewController.m
//  Pods
//
//  Created by Tim Shi on 4/30/15.
//
//

#import "PXLAlbumViewController.h"

#import "PXLAlbum.h"
#import "PXLPhoto.h"
#import "PXLPhotoCollectionViewCell.h"
#import <Masonry/Masonry.h>

@interface PXLAlbumViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *albumCollectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *gridLayout, *listLayout;

@end

@implementation PXLAlbumViewController

const CGFloat PXLAlbumViewControllerDefaultMargin = 15;

+ (instancetype)albumViewControllerWithAlbumId:(NSString *)albumId {
    PXLAlbumViewController *albumVC = [self new];
    PXLAlbum *album = [PXLAlbum albumWithIdentifier:albumId];
    albumVC.album = album;
    return albumVC;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.gridLayout = [UICollectionViewFlowLayout new];
    CGFloat cellWidth = CGRectGetWidth(self.view.bounds);
    cellWidth = floor((cellWidth - 3 * PXLAlbumViewControllerDefaultMargin) / 2);
    self.gridLayout.itemSize = CGSizeMake(cellWidth, cellWidth);
    self.listLayout = [UICollectionViewFlowLayout new];
    self.listLayout.itemSize = CGSizeMake(CGRectGetWidth(self.view.bounds), CGRectGetWidth(self.view.bounds));
    self.albumCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.listLayout];
    self.albumCollectionView.dataSource = self;
    self.albumCollectionView.delegate = self;
    self.albumCollectionView.contentInset = UIEdgeInsetsMake(PXLAlbumViewControllerDefaultMargin,
                                                             PXLAlbumViewControllerDefaultMargin,
                                                             PXLAlbumViewControllerDefaultMargin,
                                                             PXLAlbumViewControllerDefaultMargin);
    [self.view addSubview:self.albumCollectionView];
    [self.albumCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [PXLPhotoCollectionViewCell registerWithCollectionView:self.albumCollectionView];
    [self loadNextPageOfPhotos];
}

- (void)loadNextPageOfPhotos {
    [self.album loadNextPageOfPhotos:^(NSArray *photos, NSError *error) {
        if (photos.count) {
            NSMutableArray *indexPaths = @[].mutableCopy;
            NSInteger firstIndex = [self.album.photos indexOfObject:[photos firstObject]];
            [photos enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                NSInteger itemNum = firstIndex + idx;
                NSIndexPath *indexPath = [NSIndexPath indexPathForItem:itemNum inSection:0];
                [indexPaths addObject:indexPath];
            }];
            [self.albumCollectionView insertItemsAtIndexPaths:indexPaths];
        }
    }];
}

- (PXLPhoto *)photoAtIndexPath:(NSIndexPath *)indexPath {
    return self.album.photos[indexPath.item];
}

#pragma mark - UICollectionViewDataSource Methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.album.photos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PXLPhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[PXLPhotoCollectionViewCell defaultIdentifier] forIndexPath:indexPath];
    cell.photoSize = PXLPhotoSizeMedium;
    cell.photo = [self photoAtIndexPath:indexPath];
    return cell;
}

//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
//    CGFloat width = CGRectGetWidth(collectionView.bounds);
//    width = floor((width - 3 * PXLAlbumViewControllerDefaultMargin) / 2);
//    return CGSizeMake(width, width);
//}

#pragma mark - UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.albumCollectionView) {
        CGFloat offsetY = scrollView.contentOffset.y;
        if (offsetY >= scrollView.contentSize.height * 0.7) {
            [self loadNextPageOfPhotos];
        }
    }
}

@end
