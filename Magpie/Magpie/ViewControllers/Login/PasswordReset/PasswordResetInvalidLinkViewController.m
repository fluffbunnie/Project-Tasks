//
//  PasswordResetInvalidLinkViewController.m
//  Magpie
//
//  Created by minh thao nguyen on 9/2/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import "PasswordResetInvalidLinkViewController.h"
#import "UIImage+ImageEffects.h"
#import "TTTAttributedLabel.h"
#import "FontColor.h"
#import "ValuePropViewController.h"
#import <Parse/Parse.h>
#import "ErrorMessageDisplay.h"

static NSString * MAGPIE_ICON_IMG_NAME = @"MagpieIcon";
static NSString * const SIGNUP_BACKGROUND_IMAGE_BLURRED = @"SignupBackgroundImageBlurred";
static NSString * const CLOSE_BUTTON_NORMAL_IMAGE = @"NavigationBarCloseIconWhite";
static NSString * const CLOSE_BUTTON_HIGHLIGHT_IMAGE = @"NavigationBarCloseIconRed";

@interface PasswordResetInvalidLinkViewController ()
@property (nonatomic, assign) CGFloat screenWidth;
@property (nonatomic, assign) CGFloat screenHeight;

@property (nonatomic, strong) UIImageView *backgroundImage;
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UIImageView *logoImage;
@property (nonatomic, strong) TTTAttributedLabel *titleLabel;
@property (nonatomic, strong) UIButton *requestNewLinkButton;
@end

@implementation PasswordResetInvalidLinkViewController
#pragma mark - initiation
/**
 * Lazily init the background image
 * @return UIImage
 */
-(UIImageView *)backgroundImage {
    if (_backgroundImage == nil) {
        _backgroundImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.screenWidth, self.screenHeight)];
        _backgroundImage.contentMode = UIViewContentModeScaleAspectFill;
        UIImage *normalImage = [UIImage imageNamed:SIGNUP_BACKGROUND_IMAGE_BLURRED];
        UIImage *blurredImage = [normalImage applyBlur:10 tintColor:[UIColor colorWithWhite:0 alpha:0.2]];
        _backgroundImage.image = blurredImage;
    }
    return _backgroundImage;
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
        _closeButton.alpha = 0;
        [_closeButton addTarget:self action:@selector(closeButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}

/**
 * Lazily init the logo image
 * @return UIImage
 */
-(UIImageView *)logoImage {
    if (_logoImage == nil) {
        _logoImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 84, self.screenWidth, 80)];
        _logoImage.contentMode = UIViewContentModeScaleAspectFit;
        _logoImage.image = [UIImage imageNamed:MAGPIE_ICON_IMG_NAME];
    }
    return _logoImage;
}

/**
 * Lazily init the title text
 * @return TTTAttributedLabel
 */
-(TTTAttributedLabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[TTTAttributedLabel alloc] init];
        _titleLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:20];
        _titleLabel.numberOfLines = 0;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.lineSpacing = 10;
        _titleLabel.text = self.titleTextString;
        
        CGFloat height = [_titleLabel sizeThatFits:CGSizeMake(self.screenWidth - 70, FLT_MAX)].height;
        _titleLabel.frame = CGRectMake(35, CGRectGetMaxY(self.logoImage.frame) + 30, self.screenWidth - 70, height);
    }
    return _titleLabel;
}

/**
 * Lazily init request new link button
 * @return UIButton
 */
-(UIButton *)requestNewLinkButton {
    if (_requestNewLinkButton == nil) {
        _requestNewLinkButton = [[UIButton alloc] initWithFrame:CGRectMake(35, self.screenHeight - 100, self.screenWidth - 70, 50)];
        _requestNewLinkButton.layer.cornerRadius = 25;
        _requestNewLinkButton.layer.masksToBounds = YES;
        _requestNewLinkButton.titleLabel.font = [UIFont fontWithName:@"AvenirNext-Medium" size:15];
        
        [_requestNewLinkButton setTitle:@"Request new link" forState:UIControlStateNormal];
        
        [_requestNewLinkButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_requestNewLinkButton setTitleColor:[UIColor colorWithWhite:1 alpha:0.7] forState:UIControlStateDisabled];
        
        [_requestNewLinkButton setBackgroundImage:[FontColor imageWithColor:[FontColor greenThemeColor]] forState:UIControlStateNormal];
        [_requestNewLinkButton setBackgroundImage:[FontColor imageWithColor:[FontColor darkGreenThemeColor]] forState:UIControlStateHighlighted];
        [_requestNewLinkButton setBackgroundImage:[FontColor imageWithColor:[UIColor colorWithWhite:1 alpha:0.2]] forState:UIControlStateDisabled];
        
        [_requestNewLinkButton addTarget:self action:@selector(newLinkButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _requestNewLinkButton;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.screenWidth = [[UIScreen mainScreen] bounds].size.width;
    self.screenHeight = [[UIScreen mainScreen] bounds].size.height;
    
    [self.view addSubview:[self backgroundImage]];
    [self.view addSubview:[self closeButton]];
    [self.view addSubview:[self logoImage]];
    [self.view addSubview:[self titleLabel]];
    [self.view addSubview:[self requestNewLinkButton]];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarHidden = YES;
    [self.navigationController setNavigationBarHidden:YES animated:false];
}

#pragma mark - UIGesture
/**
 * Handle the behavior when user click on the close button
 */
-(void)closeButtonClick {
    ValuePropViewController *valuePropViewController = [[ValuePropViewController alloc] init];
    NSArray *newControllers = [NSArray arrayWithObjects:valuePropViewController, self, nil];
    self.navigationController.viewControllers = newControllers;
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 * Handle the behavior when user click on request new link button
 */
-(void)newLinkButtonClick {
    self.requestNewLinkButton.enabled = NO;
    
    PFQuery *query = [PFQuery queryWithClassName:@"Users"];
    [query whereKey:@"email" equalTo:self.email];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error || objects.count == 0) {
            [ErrorMessageDisplay displayErrorAlertOnViewController:self withTitle:@"Network error" andMessage:STANDARD_ERROR_MESSAGE];
        } else {
            PFObject *emailObj = [PFObject objectWithClassName:@"Email"];
            emailObj[@"user"] = objects[0];
            emailObj[@"type"] = @"password reset";
            [emailObj saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    [ErrorMessageDisplay displayErrorAlertOnViewController:self withTitle:@"Email sent" andMessage:@"A password reset link has been sent to your email. Please check your email."];
                } else {
                    [ErrorMessageDisplay displayErrorAlertOnViewController:self withTitle:@"Network error" andMessage:STANDARD_ERROR_MESSAGE];
                    self.requestNewLinkButton.enabled = YES;
                }
            }];
        }
    }];
}

@end
