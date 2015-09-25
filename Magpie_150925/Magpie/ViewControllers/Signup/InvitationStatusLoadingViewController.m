//
//  InvitationStatusLoadingViewController.m
//  Magpie
//
//  Created by minh thao nguyen on 8/19/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import "InvitationStatusLoadingViewController.h"
#import "UIImage+ImageEffects.h"
#import "AppDelegate.h"
#import <Parse/Parse.h>
#import "ValuePropViewController.h"
#import "ErrorMessageDisplay.h"
#import "InvitationStatusRequestCodeSentViewController.h"
#import "InvitationStatusWithPushNotificationViewController.h"
#import "InvitationStatusViewController.h"

static NSString * const SIGNUP_BACKGROUND_IMAGE_BLURRED = @"SignupBackgroundImageBlurred";
static NSString * const LOADING_TEXT = @"Checking your invitation status";

@interface InvitationStatusLoadingViewController()
@property (nonatomic, assign) CGFloat screenWidth;
@property (nonatomic, assign) CGFloat screenHeight;

@property (nonatomic, strong) UIImageView *blurredBackgroundImage;
@property (nonatomic, strong) UIImageView *loadingIcon;
@property (nonatomic, strong) UILabel *loadingText;

@end

@implementation InvitationStatusLoadingViewController
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
        UIImage *blurredImage = [normalImage applyBlur:10 tintColor:[UIColor colorWithWhite:0 alpha:0.2]];
        _blurredBackgroundImage.image = blurredImage;
    }
    return _blurredBackgroundImage;
}

/**
 * Lazily init the loading icon
 * @return UIImageView
 */
-(UIImageView *)loadingIcon {
    if (_loadingIcon == nil) {
        _loadingIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.screenHeight/2 - 60, self.screenWidth, 100)];
        _loadingIcon.contentMode = UIViewContentModeScaleAspectFit;
        _loadingIcon.image = [UIImage animatedImageNamed:@"Loading" duration:0.7];
    }
    return _loadingIcon;
}

/**
 * Lazily init the loading text
 * @return UILabel
 */
-(UILabel *)loadingText {
    if (_loadingText == nil) {
        _loadingText = [[UILabel alloc] init];
        _loadingText.font = [UIFont fontWithName:@"AvenirNext-Medium" size:15];
        _loadingText.text = [NSString stringWithFormat:@"%@ .", LOADING_TEXT];
        _loadingText.textColor = [UIColor whiteColor];
        CGSize size = [_loadingText sizeThatFits:CGSizeMake(self.screenWidth, self.screenHeight)];
        _loadingText.frame = CGRectMake((self.screenWidth - size.width)/2 - 1, self.screenHeight/2 + 60, size.width + 10, size.height);
    }
    return _loadingText;
}

#pragma mark - public methods
-(void)viewDidLoad {
    [super viewDidLoad];
    self.screenWidth = [[UIScreen mainScreen] bounds].size.width;
    self.screenHeight = [[UIScreen mainScreen] bounds].size.height;
    
    [self.view addSubview:[self blurredBackgroundImage]];
    [self.view addSubview:[self loadingIcon]];
    [self.view addSubview:[self loadingText]];
    [self performSelector:@selector(animateLoadingText) withObject:nil afterDelay:1];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarHidden = YES;
    [self.navigationController setNavigationBarHidden:YES animated:false];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSDate *time  = [[NSDate alloc] init];
    CGFloat startTime = [time timeIntervalSince1970];
    
    NSString *codeId = [[NSUserDefaults standardUserDefaults] stringForKey:USER_DEFAULT_REQUEST_CODE_ID];
    PFQuery *query = [PFQuery queryWithClassName:@"InvitationCode"];
    [query whereKey:@"objectId" equalTo:codeId];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error || objects.count == 0) {
            [ErrorMessageDisplay displayErrorAlertOnViewController:self withTitle:@"Error checking status" andMessage:@"Oops, looks like something went wrong! Please try again."];
        } else {
            PFObject *invitationCodeObj = objects[0];
            
            //wait on this screen for at least 2 second
            CGFloat endTime = [[[NSDate alloc] init] timeIntervalSince1970];
            if (endTime - startTime >= 2) [self checkInvitationStatus:invitationCodeObj];
            else [self performSelector:@selector(checkInvitationStatus:) withObject:invitationCodeObj afterDelay:2 - (endTime - startTime)];
        }
    }];
}

/**
 * Animate the loading text
 */
-(void)animateLoadingText {
    NSString *oneDot = [NSString stringWithFormat:@"%@ .", LOADING_TEXT];
    NSString *twoDots = [NSString stringWithFormat:@"%@ ..", LOADING_TEXT];
    NSString *threeDots = [NSString stringWithFormat:@"%@ ...", LOADING_TEXT];
    if ([self.loadingText.text isEqualToString:oneDot]) self.loadingText.text = twoDots;
    else if ([self.loadingText.text isEqualToString:twoDots]) self.loadingText.text = threeDots;
    else self.loadingText.text = oneDot;
    
    [self performSelector:@selector(animateLoadingText) withObject:nil afterDelay:1];
}

/**
 * Check the invitation status
 * @param PFObject
 */
-(void)checkInvitationStatus:(PFObject *)invitationCodeObj {
    if ([invitationCodeObj[@"status"] isEqualToString:@"APPROVED"]) {
        InvitationStatusRequestCodeSentViewController *requestCodeSentViewController = [[InvitationStatusRequestCodeSentViewController alloc] init];
        requestCodeSentViewController.invitationCodeObj = invitationCodeObj;
        [self.navigationController pushViewController:requestCodeSentViewController animated:YES];
    } else if ([[NSUserDefaults standardUserDefaults] boolForKey:USER_DEFAULT_DID_ASK_PUSH_NOTIFICATION]) {
        InvitationStatusWithPushNotificationViewController *statusWithPushNotifViewController = [[InvitationStatusWithPushNotificationViewController alloc] init];
        statusWithPushNotifViewController.invitationCodeObj = invitationCodeObj;
        [self.navigationController pushViewController:statusWithPushNotifViewController animated:YES];
    } else {
        InvitationStatusViewController *statusViewController = [[InvitationStatusViewController alloc] init];
        statusViewController.invitationCodeObj = invitationCodeObj;
        [self.navigationController pushViewController:statusViewController animated:YES];
    }
}

@end
