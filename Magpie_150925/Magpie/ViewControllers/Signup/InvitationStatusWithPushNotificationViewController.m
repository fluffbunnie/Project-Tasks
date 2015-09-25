//
//  InvitationStatusWithPushNotificationViewController.m
//  Magpie
//
//  Created by minh thao nguyen on 8/18/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import "InvitationStatusWithPushNotificationViewController.h"
#import "UIImage+ImageEffects.h"
#import "ValuePropViewController.h"
#import "InvitationEmailChangeViewController.h"
#import "Device.h"
#import "InvitationStatusRequestCodeSentViewController.h"

static NSString * const SIGNUP_BACKGROUND_IMAGE_BLURRED = @"SignupBackgroundImageBlurred";

static NSString * const CLOSE_BUTTON_NORMAL_IMAGE = @"NavigationBarCloseIconWhite";
static NSString * const CLOSE_BUTTON_HIGHLIGHT_IMAGE = @"NavigationBarCloseIconRed";

@interface InvitationStatusWithPushNotificationViewController ()
@property (nonatomic, assign) CGFloat screenWidth;
@property (nonatomic, assign) CGFloat screenHeight;

@property (nonatomic, strong) UIImageView *blurredBackgroundImage;
@property (nonatomic, strong) InvitationStatusWithPushNotificationView *statusView;
@property (nonatomic, strong) UIButton *closeButton;
@end

@implementation InvitationStatusWithPushNotificationViewController
#pragma mark - initiation
/**
 * Lazily init the blurred background image
 * @return UIImageView
 */
-(UIImageView *)blurredBackgroundImage {
    if (_blurredBackgroundImage == nil) {
        _blurredBackgroundImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.screenWidth, self.screenHeight)];
        _blurredBackgroundImage.contentMode = UIViewContentModeScaleAspectFill;
        UIImage *normalImage = [UIImage imageNamed:SIGNUP_BACKGROUND_IMAGE_BLURRED];
        UIImage *blurredImage = [normalImage applyBlur:10 tintColor:[UIColor colorWithWhite:0 alpha:0.2]];//[UIColor colorWithRed:118/255.0 green:197/255.0 blue:202/255.0 alpha:0.5]];
        _blurredBackgroundImage.image = blurredImage;
    }
    return _blurredBackgroundImage;
}

/**
 * Lazily init the invitation success view
 * @return InvitationStatusWithPushNotificationView
 */
-(InvitationStatusWithPushNotificationView *)statusView {
    if (_statusView == nil) {
        _statusView = [[InvitationStatusWithPushNotificationView alloc] init];
        [_statusView setEmailAddress:self.invitationCodeObj[@"email"]];
        _statusView.delegate = self;
    }
    return _statusView;
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

#pragma mark - public methods
-(void)viewDidLoad {
    [super viewDidLoad];
    self.screenWidth = [[UIScreen mainScreen] bounds].size.width;
    self.screenHeight = [[UIScreen mainScreen] bounds].size.height;
    
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setObject:self.invitationCodeObj forKey:@"invitationCode"];
    [currentInstallation saveInBackground];
    
    [self.view addSubview:[self blurredBackgroundImage]];
    [self.view addSubview:[self statusView]];
    [self.view addSubview:[self closeButton]];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarHidden = YES;
    [self.navigationController setNavigationBarHidden:YES animated:false];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(viewDidEnterForeground) name:UIApplicationDidBecomeActiveNotification object:nil];
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
}

-(void)viewDidEnterForeground {
    [self.invitationCodeObj fetchInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        NSString *status = self.invitationCodeObj[@"status"];
        if ([status isEqualToString:@"APPROVED"]) {
            InvitationStatusRequestCodeSentViewController *codeSentViewController = [[InvitationStatusRequestCodeSentViewController alloc] init];
            codeSentViewController.invitationCodeObj = self.invitationCodeObj;
            [self.navigationController pushViewController:codeSentViewController animated:YES];
        }
    }];
}


/**
 * Set the email address after the email changed
 * @param NSString
 */
-(void)setEmail:(NSString *)email {
    self.invitationCodeObj[@"email"] = email;
    [self.invitationCodeObj saveInBackground];
    [self.statusView setEmailAddress:email];
}

#pragma mark - UI Action
/**
 * Handle the behavior when user click on close button
 */
-(void)closeButtonClick {
    ValuePropViewController *valuePropViewController = [[ValuePropViewController alloc] init];
    
    NSArray *stack = [NSArray arrayWithObjects:valuePropViewController, self, nil];
    self.navigationController.viewControllers = stack;
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 * InvitationStatusWithPushNotificationView delegate
 * Handle the behavior when user click on change email button
 */
-(void)changeEmailAddress {
    InvitationEmailChangeViewController *emailChanged = [[InvitationEmailChangeViewController alloc] init];
    emailChanged.capturedBackground = [Device captureScreenshot];
    emailChanged.email = self.invitationCodeObj[@"email"];
    [self.navigationController pushViewController:emailChanged animated:NO];
}

@end
