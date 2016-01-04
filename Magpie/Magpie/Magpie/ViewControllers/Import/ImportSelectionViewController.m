//
//  ImportSelectionViewController.m
//  Magpie
//
//  Created by minh thao nguyen on 9/9/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import "ImportSelectionViewController.h"
#import "Device.h"
#import "RoundButton.h"
#import "FontColor.h"
#import "ImportAirbnbViewController.h"

static NSString * const CLOSE_BUTTON_NORMAL_IMAGE = @"NavigationBarCloseIconWhite";
static NSString * const CLOSE_BUTTON_HIGHLIGHT_IMAGE = @"NavigationBarCloseIconRed";

static NSString *IMAGE_ICON_NAME = @"MyPlaceEmptyIcon";
static NSString *TITLE_TEXT = @"Import your Airbnb listing with just one tap";
static NSString *IMPORT_BUTTON_TITLE = @"Go to Airbnb";

@interface ImportSelectionViewController ()
@property (nonatomic, assign) CGFloat screenWidth;
@property (nonatomic, assign) CGFloat screenHeight;

@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UIImageView *iconImage;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *descriptionLabel;
@property (nonatomic, strong) RoundButton *importButton;
@end

@implementation ImportSelectionViewController
#pragma mark - initiation
/**
 * Lazily init the close button
 * @return UIButton
 */
-(UIButton *)closeButton {
    if (_closeButton == nil) {
        _closeButton = [[UIButton alloc] initWithFrame:CGRectMake(self.screenWidth - 50, 0, 50, 50)];
        [_closeButton setImage:[UIImage imageNamed:CLOSE_BUTTON_NORMAL_IMAGE] forState:UIControlStateNormal];
        [_closeButton setImage:[UIImage imageNamed:CLOSE_BUTTON_HIGHLIGHT_IMAGE] forState:UIControlStateHighlighted];
        [_closeButton addTarget:self action:@selector(closeButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}

/**
 * Lazily init the icon image
 * @return UIImageView
 */
-(UIImageView *)iconImage {
    if (_iconImage == nil) {
        _iconImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, (self.screenHeight - 200)/2, self.screenWidth, 70)];
        _iconImage.contentMode = UIViewContentModeScaleAspectFit;
        _iconImage.image = [UIImage imageNamed:IMAGE_ICON_NAME];
    }
    return _iconImage;
}

/**
 * Lazily init the title label
 * @return UILabel
 */
-(UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont fontWithName:@"AvenirNext-Medium" size:18];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.text = TITLE_TEXT;
        _titleLabel.numberOfLines = 0;
        
        CGSize size = [_titleLabel sizeThatFits:CGSizeMake(self.screenWidth - 80, FLT_MAX)];
        _titleLabel.frame = CGRectMake(40, CGRectGetMaxY(self.iconImage.frame) + 30, self.screenWidth - 80, size.height);
    }
    return _titleLabel;
}

/**
 * Lazily initiate the import button
 * @return RoundButton
 */
-(RoundButton *)importButton {
    if (_importButton == nil) {
        _importButton = [[RoundButton alloc] initWithFrame:CGRectMake(35, self.screenHeight - 100, self.screenWidth - 70, 50)];
        [_importButton setTitle:IMPORT_BUTTON_TITLE forState:UIControlStateNormal];
        [_importButton addTarget:self action:@selector(goToAirbnbImport) forControlEvents:UIControlEventTouchUpInside];
    }
    return _importButton;
}

#pragma mark - public method
- (void)viewDidLoad {
    [super viewDidLoad];
    self.screenWidth = [UIScreen mainScreen].bounds.size.width;
    self.screenHeight = [UIScreen mainScreen].bounds.size.height;
    
    self.view.backgroundColor = [FontColor backgroundOverlayColor];
    [self.view addSubview:[self closeButton]];
    [self.view addSubview:[self iconImage]];
    [self.view addSubview:[self titleLabel]];
    [self.view addSubview:[self descriptionLabel]];
    [self.view addSubview:[self importButton]];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarHidden = YES;
    [self.navigationController setNavigationBarHidden:YES animated:false];
}
#pragma mark - UIGesture
/**
 * Handle the behavior when user click on close button
 */
-(void)closeButtonClick {
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 * Handle the behavior when user click on the 'go to airbnb' button
 */
-(void)goToAirbnbImport {
    ImportAirbnbViewController *importViewController = [[ImportAirbnbViewController alloc] init];
    importViewController.prevScreenCapturedImage = [Device captureScreenshot];
    [self.navigationController pushViewController:importViewController animated:NO];
}

@end
