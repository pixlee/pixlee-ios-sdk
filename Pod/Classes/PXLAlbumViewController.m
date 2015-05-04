//
//  PXLAlbumViewController.m
//  pixlee-ios-sdk
//
//  Created by Tim Shi on 4/30/15.
//
//

#import "PXLAlbumViewController.h"

#import "PXLAlbum.h"
#import "PXLPhoto.h"
#import "PXLPhotoCollectionViewCell.h"
#import "PXLPhotoDetailViewController.h"
#import <Masonry/Masonry.h>

typedef NS_ENUM(NSInteger, PXLAlbumViewControllerDisplayMode) {
    PXLAlbumViewControllerDisplayModeGrid,
    PXLAlbumViewControllerDisplayModeList
};

@interface PXLAlbumViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *albumCollectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *gridLayout, *listLayout;
@property (nonatomic) PXLAlbumViewControllerDisplayMode albumDisplayMode;
@property (nonatomic, strong) UIButton *gridButton, *listButton;

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
        _albumDisplayMode = PXLAlbumViewControllerDisplayModeGrid;
    }
    return self;
}

- (void)setAlbumDisplayMode:(PXLAlbumViewControllerDisplayMode)albumDisplayMode {
    if (albumDisplayMode != _albumDisplayMode) {
        _albumDisplayMode = albumDisplayMode;
        UICollectionViewFlowLayout *layoutToUse = self.albumDisplayMode == PXLAlbumViewControllerDisplayModeGrid ? self.gridLayout : self.listLayout;
        [self.albumCollectionView setCollectionViewLayout:layoutToUse animated:YES];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupDisplayButtons];
    [self setupCollectionView];
    [self loadNextPageOfPhotos];
}

- (void)setupDisplayButtons {
    
    const CGFloat kButtonTopMargin = 20;
    const CGFloat kButtonHeight = 44;
    
    self.gridButton = [self displayButtonWithImageName:@"pixlee-ios-sdk.bundle/grid" selector:@selector(displayButtonPressed:)];
    [self.view addSubview:self.gridButton];
    self.listButton = [self displayButtonWithImageName:@"pixlee-ios-sdk.bundle/column" selector:@selector(displayButtonPressed:)];
    [self.view addSubview:self.listButton];
    
    self.gridButton.enabled = self.albumDisplayMode != PXLAlbumViewControllerDisplayModeGrid;
    self.listButton.enabled = self.albumDisplayMode != PXLAlbumViewControllerDisplayModeList;
    
    [self.gridButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.top.equalTo(self.view.mas_top).with.offset(kButtonTopMargin);
        make.right.equalTo(self.view.mas_centerX);
        make.height.equalTo(@(kButtonHeight));
    }];
    [self.listButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.gridButton.mas_top);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(@(kButtonHeight));
    }];
}

- (UIButton *)displayButtonWithImageName:(NSString *)imageName selector:(SEL)selector {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor whiteColor];
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button setTitleColor:self.view.tintColor forState:UIControlStateNormal];
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    [button addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (void)setupCollectionView {
    self.gridLayout = [UICollectionViewFlowLayout new];
    CGFloat cellWidth = CGRectGetWidth(self.view.bounds);
    cellWidth = floor((cellWidth - 3 * PXLAlbumViewControllerDefaultMargin) / 2);
    self.gridLayout.itemSize = CGSizeMake(cellWidth, cellWidth);
    self.gridLayout.sectionInset = UIEdgeInsetsMake(PXLAlbumViewControllerDefaultMargin,
                                                    PXLAlbumViewControllerDefaultMargin,
                                                    PXLAlbumViewControllerDefaultMargin,
                                                    PXLAlbumViewControllerDefaultMargin);
    self.listLayout = [UICollectionViewFlowLayout new];
    self.listLayout.itemSize = CGSizeMake(CGRectGetWidth(self.view.bounds), CGRectGetWidth(self.view.bounds));
    UICollectionViewFlowLayout *layoutToUse = self.albumDisplayMode == PXLAlbumViewControllerDisplayModeGrid ? self.gridLayout : self.listLayout;
    self.albumCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layoutToUse];
    self.albumCollectionView.backgroundColor = [UIColor whiteColor];
    self.albumCollectionView.dataSource = self;
    self.albumCollectionView.delegate = self;
    [self.view addSubview:self.albumCollectionView];
    [self.albumCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.top.equalTo(self.gridButton.mas_bottom);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    [PXLPhotoCollectionViewCell registerWithCollectionView:self.albumCollectionView];
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

#pragma mark - Button Actions

- (void)displayButtonPressed:(UIButton *)button {
    if (button == self.gridButton) {
        self.gridButton.enabled = NO;
        self.listButton.enabled = YES;
        self.albumDisplayMode = PXLAlbumViewControllerDisplayModeGrid;
    } else if (button == self.listButton) {
        self.listButton.enabled = NO;
        self.gridButton.enabled = YES;
        self.albumDisplayMode = PXLAlbumViewControllerDisplayModeList;
    }
}

- (void)presentDetailVCForPhoto:(PXLPhoto *)photo {
    PXLPhotoDetailViewController *detailVC = [PXLPhotoDetailViewController new];
    detailVC.photo = photo;
    UINavigationController *detailNav = [[UINavigationController alloc] initWithRootViewController:detailVC];
    [self presentViewController:detailNav animated:YES completion:nil];
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

#pragma mark - UICollectionViewDelegate Methods

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    PXLPhoto *photo = [self photoAtIndexPath:indexPath];
    [self presentDetailVCForPhoto:photo];
}

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
