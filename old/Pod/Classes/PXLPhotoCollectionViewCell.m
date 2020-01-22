//
//  PXLPhotoCollectionViewCell.m
//  pixlee-ios-sdk
//
//  Created by Tim Shi on 4/30/15.
//
//

#import "PXLPhotoCollectionViewCell.h"

#import <Masonry/Masonry.h>
#import <SDWebImage/UIImageView+WebCache.h>

@interface PXLPhotoCollectionViewCell ()

@property (nonatomic, strong) UIImageView *photoImageView;

@property (nonatomic) BOOL hasInstalledViewConstraints;

@end

@implementation PXLPhotoCollectionViewCell

+ (NSString *)defaultIdentifier {
    static NSString * const PXLPhotoCollectionViewCellIdentifier = @"PXLPhotoCollectionViewCellIdentifier";
    return PXLPhotoCollectionViewCellIdentifier;
}

+ (void)registerWithCollectionView:(UICollectionView *)collectionView {
    [collectionView registerClass:self
       forCellWithReuseIdentifier:[self defaultIdentifier]];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.photoSize = PXLPhotoSizeThumbnail;
        [self setupViews];
    }
    return self;
}
         
- (void)setupViews {
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.photoImageView = [UIImageView new];
    self.photoImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.photoImageView.clipsToBounds = YES;
    [self.contentView addSubview:self.photoImageView];
    [self setNeedsUpdateConstraints];
}

- (void)updateConstraints {
    if (!self.hasInstalledViewConstraints) {
        self.hasInstalledViewConstraints = YES;
        [self.photoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
    }
    [super updateConstraints];
}

- (void)prepareForReuse {
    self.photoImageView.image = nil;
}

- (void)setPhoto:(PXLPhoto *)photo {
    _photo = photo;
    [self configureWithPhoto:photo];
}

- (void)configureWithPhoto:(PXLPhoto *)photo {
    self.photoImageView.image = nil;
    if (photo) {
        NSURL *photoUrl = [photo photoUrlForSize:self.photoSize];
        [self.photoImageView sd_setImageWithURL:photoUrl];
    }
}

@end
