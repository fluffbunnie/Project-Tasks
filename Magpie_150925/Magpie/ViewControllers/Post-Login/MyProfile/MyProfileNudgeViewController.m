//
//  MyProfileNudgeViewController.m
//  Magpie
//
//  Created by minh thao nguyen on 9/13/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import "MyProfileNudgeViewController.h"
#import "TTTAttributedLabel.h"
#import "FontColor.h"
#import "MyProfileViewController.h"

static NSString * const MAGPIE_ICON = @"MagpieIcon";

static NSString * const TITLE_TEXT = @"Hi %@, please update your profile so the host would know who is knocking on the door.";
static NSString * const BUTTON_TEXT = @"Go to your profile";

static NSString * const CLOSE_BUTTON_NORMAL_IMAGE = @"NavigationBarCloseIconWhite";
static NSString * const CLOSE_BUTTON_HIGHLIGHT_IMAGE = @"NavigationBarCloseIconRed";

@interface MyProfileNudgeViewController ()
@property (nonatomic, assign) CGFloat screenWidth;
@property (nonatomic, assign) CGFloat screenHeight;

@property (nonatomic, strong) UIImageView *capturedBackgroundImage;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIImageView *magpieIcon;
@property (nonatomic, strong) TTTAttributedLabel * titleLabel;
@property (nonatomic, strong) UIButton *goToProfileButton;
@property (nonatomic, strong) UIButton *closeButton;
@end

@implementation MyProfileNudgeViewController
#pragma mark - initiation
/**
 * Lazily init the captured background image
 * @return UIImageView
 */
-(UIImageView *)capturedBackgroundImage {
    if (_capturedBackgroundImage == nil) {
        _capturedBackgroundImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.screenWidth, self.screenHeight)];
        _capturedBackgroundImage.contentMode = UIViewContentModeScaleAspectFill;
        _capturedBackgroundImage.image = self.capturedBackground;
    }
    return _capturedBackgroundImage;
}

/**
 * Lazily init the container view
 * @return UIView
 */
-(UIView *)containerView {
    if (_containerView == nil) {
        _containerView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.screenWidth, self.screenHeight)];
        _containerView.backgroundColor = [UIColor colorWithRed:118/255.0 green:197/255.0 blue:202/255.0 alpha:0.9];
        _containerView.userInteractionEnabled = YES;
        _containerView.alpha = 0;
    }
    return _containerView;
}

/**
 * Lazily init Magpie icon
 * @return UIImageView
 */
-(UIImageView *)magpieIcon {
    if (_magpieIcon == nil) {
        _magpieIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, self.screenWidth, 75)];
        _magpieIcon.contentMode = UIViewContentModeScaleAspectFit;
        _magpieIcon.image = [UIImage imageNamed:MAGPIE_ICON];
    }
    return _magpieIcon;
}

/**
 * Lazily init the title label
 * @return TTTAttributedLabel
 */
-(TTTAttributedLabel *)titleLabel {
    if (_titleLabel == nil) {
        NSString *userName = self.userObj[@"firstname"] ? self.userObj[@"firstname"] : @"";
        _titleLabel = [[TTTAttributedLabel alloc] init];
        _titleLabel.font = [UIFont fontWithName:@"AvenirNext-Medium" size:20];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.numberOfLines = 0;
        _titleLabel.text = [NSString stringWithFormat: TITLE_TEXT, userName];
        CGFloat height = [_titleLabel sizeThatFits:CGSizeMake(self.screenWidth - 70, FLT_MAX)].height;
        _titleLabel.frame = CGRectMake(35, 160, self.screenWidth - 70, height);
    }
    return _titleLabel;
}

/**
 * Lazily init go to profile button
 * @return UIButton
 */
-(UIButton *)goToProfileButton {
    if (_goToProfileButton == nil) {
        _goToProfileButton = [[UIButton alloc] initWithFrame:CGRectMake(35, self.screenHeight - 100, self.screenWidth - 70, 50)];
        _goToProfileButton.layer.cornerRadius = 25;
        _goToProfileButton.layer.masksToBounds = YES;
        _goToProfileButton.titleLabel.font = [UIFont fontWithName:@"AvenirNext-Medium" size:15];
        [_goToProfileButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_goToProfileButton setTitle:BUTTON_TEXT forState:UIControlStateNormal];
        [_goToProfileButton setBackgroundImage:[FontColor imageWithColor:[FontColor themeColor]] forState:UIControlStateNormal];
        [_goToProfileButton setBackgroundImage:[FontColor imageWithColor:[FontColor darkThemeColor]] forState:UIControlStateHighlighted];
        [_goToProfileButton addTarget:self action:@selector(goToProfileButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _goToProfileButton;
}

/**
 * Lazily init the cross closing button
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

#pragma mark - public class
- (void)viewDidLoad {
    [super viewDidLoad];
    self.screenWidth = [[UIScreen mainScreen] bounds].size.width;
    self.screenHeight = [[UIScreen mainScreen] bounds].size.height;

    [self.view addSubview:[self capturedBackgroundImage]];
    [self.view addSubview:[self containerView]];
    [self.containerView addSubview:[self magpieIcon]];
    [self.containerView addSubview:[self titleLabel]];
    [self.containerView addSubview:[self goToProfileButton]];
    [self.view addSubview:[self closeButton]];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarHidden = YES;
    [self.navigationController setNavigationBarHidden:YES animated:false];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [UIView animateWithDuration:0.8 animations:^{
        self.containerView.alpha = 1;
    }];
}

#pragma mark - touch gesture
/**
 * Handle the behavior when user tap on the close button
 */
-(void)closeButtonClick {
    [self.navigationController popViewControllerAnimated:NO];
}

/**
 * Handle the behavior when user click on go to profile button
 */
-(void)goToProfileButtonClick {
    MyProfileViewController *myProfileView = [[MyProfileViewController alloc] init];
    [self.navigationController pushViewController:myProfileView animated:YES];
}


@end
