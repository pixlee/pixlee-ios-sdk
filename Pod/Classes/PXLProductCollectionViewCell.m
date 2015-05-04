//
//  PXLProductCollectionViewCell.m
//  pixlee-ios-sdk
//
//  Created by Tim Shi on 5/4/15.
//
//

#import "PXLProductCollectionViewCell.h"

#import "PXLProduct.h"
#import <Masonry/Masonry.h>
#import <SDWebImage/UIImageView+WebCache.h>

@interface PXLProductCollectionViewCell ()

@property (nonatomic, strong) UIImageView *productImageView;
@property (nonatomic, strong) UIButton *actionButton;

@property (nonatomic) BOOL hasInstalledViewConstraints;

@end

@implementation PXLProductCollectionViewCell

+ (NSString *)defaultIdentifier {
    static NSString * const PXLProductCollectionViewCellIdentifier = @"PXLProductCollectionViewCellIdentifier";
    return PXLProductCollectionViewCellIdentifier;
}

+ (void)registerWithCollectionView:(UICollectionView *)collectionView {
    [collectionView registerClass:self
       forCellWithReuseIdentifier:[self defaultIdentifier]];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    self.productImageView = [UIImageView new];
    self.productImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.productImageView.clipsToBounds = YES;
    [self.contentView addSubview:self.productImageView];
    
    self.actionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.actionButton setTitleColor:self.tintColor
                            forState:UIControlStateNormal];
    [self.actionButton addTarget:self
                          action:@selector(actionButtonPressed)
                forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.actionButton];
    
    [self setNeedsUpdateConstraints];
}

- (void)updateConstraints {
    if (!self.hasInstalledViewConstraints) {
        const CGFloat kMargin = 5;
        
        self.hasInstalledViewConstraints = YES;
        [self.productImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top).with.offset(kMargin);
            make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-kMargin);
            make.right.equalTo(self.contentView.mas_centerX).with.offset(-kMargin);
            make.width.equalTo(self.productImageView.mas_height);
        }];
        [self.actionButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_centerX).with.offset(kMargin);
            make.centerY.equalTo(self.contentView.mas_centerY);
        }];
    }
    [super updateConstraints];
}

- (void)setProduct:(PXLProduct *)product {
    _product = product;
    [self configureWithProduct:product];
}

- (void)configureWithProduct:(PXLProduct *)product {
    self.productImageView.image = nil;
    [self.productImageView sd_setImageWithURL:product.imageUrl];
    [self.actionButton setTitle:product.linkText forState:UIControlStateNormal];
}

- (void)actionButtonPressed {
    if (self.actionButtonPressedForProduct) {
        self.actionButtonPressedForProduct(self.product);
    }
}

@end
