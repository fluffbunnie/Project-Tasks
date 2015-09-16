//
//  PasswordResetLoadingViewController.m
//  Magpie
//
//  Created by minh thao nguyen on 8/19/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import "PasswordResetLoadingViewController.h"
#import "UIImage+ImageEffects.h"
#import "AppDelegate.h"
#import <Parse/Parse.h>
#import "ValuePropViewController.h"
#import "ErrorMessageDisplay.h"
#import "InvitationStatusRequestCodeSentViewController.h"
#import "InvitationStatusWithPushNotificationViewController.h"
#import "InvitationStatusViewController.h"
#import "ValuePropViewController.h"
#import "PasswordResetViewController.h"
#import "PasswordResetInvalidLinkViewController.h"

static NSString * const SIGNUP_BACKGROUND_IMAGE_BLURRED = @"SignupBackgroundImageBlurred";
static NSString * const LOADING_TEXT = @"Checking your password reset link";

@interface PasswordResetLoadingViewController()
@property (nonatomic, assign) CGFloat screenWidth;
@property (nonatomic, assign) CGFloat screenHeight;

@property (nonatomic, strong) UIImageView *blurredBackgroundImage;
@property (nonatomic, strong) UIImageView *loadingIcon;
@property (nonatomic, strong) UILabel *loadingText;

@property (nonatomic, assign) NSTimeInterval startTime;
@end

@implementation PasswordResetLoadingViewController
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
    self.startTime = [[[NSDate alloc] init] timeIntervalSince1970];
    [self checkPasswordResetStatus];
}

#pragma mark - helper methods
/**
 * Check the reset status
 */
-(void)checkPasswordResetStatus {
    if (self.email.length > 0) {
        PFQuery *query = [[PFQuery alloc] initWithClassName:@"Users"];
        [query whereKey:@"email" equalTo:self.email];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error && objects.count > 0) {
                PFObject *userObj = objects[0];
                NSData *password = userObj[@"password"] ? userObj[@"password"] : nil;
                if (password == nil) [self goToPasswordResetWithUserObj:userObj];
                else {
                    NSString *passwordString = [password base64EncodedStringWithOptions:0];
                    if ([passwordString isEqualToString:self.base64Password]) [self goToPasswordResetWithUserObj:userObj];
                    else {
                        PasswordResetInvalidLinkViewController *invalidLinkViewController = [[PasswordResetInvalidLinkViewController alloc] init];
                        invalidLinkViewController.titleTextString = PASSWORD_RESETTED_TEXT;
                        invalidLinkViewController.email = self.email;
                        [self.navigationController pushViewController:invalidLinkViewController animated:YES];
                    }
                }
            } else [self goBackWithErrorTitle:@"Network error"];
        }];
    } else [self goBackWithErrorTitle:@"Unknown error"];
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
 * Something goest wrong, so go back
 */
-(void)goBackWithErrorTitle:(NSString *)title {
    if ([UIAlertController class]) {
        UIAlertController *alert= [UIAlertController alertControllerWithTitle:title message:STANDARD_ERROR_MESSAGE preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            ValuePropViewController *valuePropViewController = [[ValuePropViewController alloc] init];
            
            NSArray *stack = [NSArray arrayWithObjects:valuePropViewController, self, nil];
            self.navigationController.viewControllers = stack;
            [self.navigationController popViewControllerAnimated:YES];
        }];
        
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
    } else {
        UIAlertView* dialog = [[UIAlertView alloc] initWithTitle:title message:STANDARD_ERROR_MESSAGE delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        dialog.delegate = self;
        [dialog show];
    }
}

/**
 * UIAlertView delegate
 * Go back when there is no listing to import
 */
-(void)alertViewCancel:(UIAlertView *)alertView {
    ValuePropViewController *valuePropViewController = [[ValuePropViewController alloc] init];
    
    NSArray *stack = [NSArray arrayWithObjects:valuePropViewController, self, nil];
    self.navigationController.viewControllers = stack;
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 * Go to the password reset page with a given user obj
 * @param PFObject
 */
-(void)goToPasswordResetWithUserObj:(PFObject *)userObj {
    NSTimeInterval currentTime = [[[NSDate alloc] init] timeIntervalSince1970];
    if (currentTime - self.startTime > 1) [self helperGoToPasswordResetWithUserObj:userObj];
    else [self performSelector:@selector(helperGoToPasswordResetWithUserObj:) withObject:userObj afterDelay:1 - (currentTime - self.startTime)];
}

/**
 * Selector of go to password reset
 * @param PFObject
 */
-(void)helperGoToPasswordResetWithUserObj:(PFObject *)userObj {
    PasswordResetViewController *passwordResetViewController = [[PasswordResetViewController alloc] init];
    passwordResetViewController.userObj = userObj;
    [self.navigationController pushViewController:passwordResetViewController animated:NO];
}

@end
