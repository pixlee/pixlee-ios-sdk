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
#import <SDWebImage/UIImageView+WebCache.h>

@interface PXLPhotoDetailViewController ()

@property (nonatomic, strong) UIImageView *photoImageView;
@property (nonatomic, strong) UILabel *sourceLabel, *usernameLabel, *dateLabel, *captionLabel;

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
    
    
    
    [super updateViewConstraints];
}

- (void)setupViews {
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.photoImageView = [UIImageView new];
    self.photoImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:self.photoImageView];
    
    self.sourceLabel = [UILabel new];
    [self.view addSubview:self.sourceLabel];
    
    self.usernameLabel = [UILabel new];
    [self.view addSubview:self.usernameLabel];
    
    self.dateLabel = [UILabel new];
    [self.view addSubview:self.dateLabel];
    
    self.captionLabel = [UILabel new];
    self.captionLabel.numberOfLines = 0;
    [self.view addSubview:self.captionLabel];
}

- (void)configureWithPhoto:(PXLPhoto *)photo {
    self.photoImageView.image = nil;
    [self.photoImageView sd_setImageWithURL:[photo photoUrlForSize:PXLPhotoSizeBig]];
    
    self.sourceLabel.text = photo.source ?: @"";
    self.usernameLabel.text = photo.username ?: @"";
    if (photo.updatedAt) {
        self.dateLabel.text = [[[self class] dateFormatter] stringForTimeIntervalFromDate:photo.updatedAt toDate:[NSDate date]];
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
