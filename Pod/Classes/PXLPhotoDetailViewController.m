//
//  PXLPhotoDetailViewController.m
//  Pods
//
//  Created by Tim Shi on 5/3/15.
//
//

#import "PXLPhotoDetailViewController.h"

#import "PXLPhoto.h"

#import <FormatterKit/TTTTimeIntervalFormatter.h>
#import <Masonry/Masonry.h>
#import <SDWebImage/UIImageView+WebCache.h>

@interface PXLPhotoDetailViewController ()

@property (nonatomic, strong) UIImageView *photoImageView, *sourceIconImageView;
@property (nonatomic, strong) UILabel *usernameLabel, *dateLabel, *captionLabel;
@property (nonatomic) BOOL hasInstalledViewConstraints;

@end

@implementation PXLPhotoDetailViewController

+ (TTTTimeIntervalFormatter *)dateFormatter {
    static TTTTimeIntervalFormatter *dateFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [TTTTimeIntervalFormatter new];
    });
    return dateFormatter;
}

- (void)setPhoto:(PXLPhoto *)photo {
    _photo = photo;
    [self configureWithPhoto:photo];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupViews];
    
    [self configureWithPhoto:self.photo];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonPressed)];
}

- (void)updateViewConstraints {
    
    if (!self.hasInstalledViewConstraints) {
        self.hasInstalledViewConstraints = YES;
        
        const CGFloat kMargin = 15;
        const CGFloat kSourceIconHeight = 20;
        const CGFloat kSourceIconMargin = 5;
        
        [self.photoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(self.view.mas_width);
            make.height.equalTo(self.photoImageView.mas_width);
            make.center.equalTo(self.view);
        }];
        [self.sourceIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view.mas_left).with.offset(kMargin);
            make.bottom.equalTo(self.photoImageView.mas_top);
            make.height.equalTo(@(kSourceIconHeight));
            make.width.equalTo(self.sourceIconImageView.mas_height);
        }];
        [self.usernameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.sourceIconImageView.mas_right).with.offset(kSourceIconMargin);
            make.right.equalTo(self.dateLabel.mas_left);
            make.bottom.equalTo(self.photoImageView.mas_top);
        }];
        [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.usernameLabel.mas_right);
            make.right.equalTo(self.view.mas_right).with.offset(-kMargin);
            make.bottom.equalTo(self.photoImageView.mas_top);
        }];
        [self.captionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view.mas_left).with.offset(kMargin);
            make.right.equalTo(self.view.mas_right).with.offset(-kMargin);
            make.top.equalTo(self.photoImageView.mas_bottom);
            make.bottom.lessThanOrEqualTo(self.view.mas_bottom).with.offset(-kMargin);
        }];
    }
    
    [super updateViewConstraints];
}

- (void)setupViews {
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.photoImageView = [UIImageView new];
    self.photoImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:self.photoImageView];
    
    self.sourceIconImageView = [UIImageView new];
    self.sourceIconImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:self.sourceIconImageView];
    
    self.usernameLabel = [UILabel new];
    [self.view addSubview:self.usernameLabel];
    
    self.dateLabel = [UILabel new];
    self.dateLabel.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:self.dateLabel];
    
    self.captionLabel = [UILabel new];
    self.captionLabel.numberOfLines = 0;
    [self.view addSubview:self.captionLabel];
    
    [self.view setNeedsUpdateConstraints];
}

- (void)configureWithPhoto:(PXLPhoto *)photo {
    self.photoImageView.image = nil;
    [self.photoImageView sd_setImageWithURL:[photo photoUrlForSize:PXLPhotoSizeBig]];
    
    self.sourceIconImageView.image = [photo sourceIconImage];
    
    self.usernameLabel.text = photo.username ? [NSString stringWithFormat:@"@%@", photo.username] : @"";
    if (photo.updatedAt) {
        self.dateLabel.text = [[[self class] dateFormatter] stringForTimeIntervalFromDate:[NSDate date] toDate:photo.updatedAt];
    } else {
        self.dateLabel.text = @"";
    }
    self.captionLabel.text = photo.title ?: @"";
}

#pragma mark - Button Actions

- (void)doneButtonPressed {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
