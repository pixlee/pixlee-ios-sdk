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
#import <Masonry/Masonry.h>

@interface PXLAlbumViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *albumCollectionView;
@property (nonatomic, strong) PXLAlbum *album;

@end

@implementation PXLAlbumViewController

+ (instancetype)albumViewControllerWithAlbumId:(NSString *)albumId {
    PXLAlbumViewController *albumVC = [self new];
    PXLAlbum *album = [PXLAlbum new];
    album.identifier = albumId;
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
    
    UICollectionViewFlowLayout *flowLayout = [UICollectionViewFlowLayout new];
    self.albumCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    [self.view addSubview:self.albumCollectionView];
    [self.albumCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
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

#pragma mark - UICollectionViewDataSource Methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.album.photos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(100, 100);
}

@end
