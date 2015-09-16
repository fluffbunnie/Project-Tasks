//
//  SignupRequestInvitationCodeViewController.m
//  Magpie
//
//  Created by minh thao nguyen on 7/20/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import "SignupRequestInvitationCodeViewController.h"
#import "FloatUnderlinePlaceHolderTextField.h"
#import "SocialProfileVerificationButton.h"
#import "Device.h"
#import "FontColor.h"
#import "EmailValidation.h"
#import "WhyInvitationPopup.h"
#import <Parse/Parse.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "ErrorMessageDisplay.h"
#import "UIImage+ImageEffects.h"
#import "InvitationStatusViewController.h"
#import "WhyInvitationPopup.h"
#import "AppDelegate.h"
#import "RequestInvitationSuccessView.h"
#import "InvitationStatusViewController.h"

static NSString * const SIGNUP_BACKGROUND_IMAGE = @"SignupBackgroundImage";
static NSString * const SIGNUP_BACKGROUND_IMAGE_BLURRED = @"SignupBackgroundImageBlurred";

static NSString * const CLOSE_BUTTON_NORMAL_IMAGE = @"NavigationBarCloseIconWhite";
static NSString * const CLOSE_BUTTON_HIGHLIGHT_IMAGE = @"NavigationBarCloseIconRed";

@interface SignupRequestInvitationCodeViewController ()
@property (nonatomic, strong) PFObject *codeRequestObj;

@property (nonatomic, assign) CGFloat screenWidth;
@property (nonatomic, assign) CGFloat screenHeight;

@property (nonatomic, strong) UIImageView *backgroundImage;
@property (nonatomic, strong) UIImageView *blurredBackgroundImage;

@property (nonatomic, strong) RequestInvitationCodeView *invitationRequestView;
@property (nonatomic, strong) UIButton *closeButton;

@property (nonatomic, strong) RequestInvitationSuccessView *successView;
@end

@implementation SignupRequestInvitationCodeViewController
#pragma mark - initiation
/**
 * Lazily init the background image
 * @return UIImageView
 */
-(UIImageView *)backgroundImage {
    if (_backgroundImage == nil) {
        _backgroundImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.screenWidth, self.screenHeight)];
        _backgroundImage.contentMode = UIViewContentModeScaleAspectFill;
        _backgroundImage.image = [UIImage imageNamed:SIGNUP_BACKGROUND_IMAGE];
    }
    return _backgroundImage;
}

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
        _blurredBackgroundImage.alpha = 0;
    }
    return _blurredBackgroundImage;
}

/**
 * Lazily init the invitation request view
 * @return RequestInvitationCodeView
 */
-(RequestInvitationCodeView *)invitationRequestView {
    if (_invitationRequestView == nil) {
        _invitationRequestView = [[RequestInvitationCodeView alloc] init];
        _invitationRequestView.delegate = self;
    }
    return _invitationRequestView;
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
 * Lazily init the success view 
 * @return RequestInvitationSuccessView
 */
-(RequestInvitationSuccessView *)successView {
    if (_successView == nil) {
        _successView = [[RequestInvitationSuccessView alloc] init];
    }
    return _successView;
}


#pragma mark - view delegate
- (void)viewDidLoad {
    [super viewDidLoad];
    self.codeRequestObj = [PFObject objectWithClassName:@"InvitationCode"];
    
    self.screenWidth = [[UIScreen mainScreen] bounds].size.width;
    self.screenHeight = [[UIScreen mainScreen] bounds].size.height;
    
    [self.view addSubview:[self backgroundImage]];
    [self.view addSubview:[self blurredBackgroundImage]];
    
    [self.view addSubview:[self invitationRequestView]];
    [self.view addSubview:[self closeButton]];
    [self.view addSubview:[self successView]];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarHidden = YES;
    [self.navigationController setNavigationBarHidden:YES animated:false];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [UIView animateWithDuration:0.8 animations:^{
        self.blurredBackgroundImage.alpha = 1;
        self.invitationRequestView.alpha = 1;
        self.closeButton.alpha = 1;
    }];
    
    // Listen for keyboard appearances and disappearances
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
}

#pragma mark - keyboard detect
/**
 * On keyboard showing, move the view up
 * @param notif
 */
- (void)keyboardWillShow:(NSNotification *) notif {
    CGRect keyboardBounds;
    [[notif.userInfo valueForKey:UIKeyboardFrameBeginUserInfoKey] getValue:&keyboardBounds];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.invitationRequestView.transform = CGAffineTransformMakeTranslation(0, 50 - keyboardBounds.size.height);
        [self.invitationRequestView showKeyboard:keyboardBounds.size.height];
    }];
}

/**
 * On keyboard hiding, move the view down
 * @param notif
 */
- (void)keyboardWillHide:(NSNotification *)notif{
    [UIView animateWithDuration:0.3 animations:^{
        self.invitationRequestView.transform = CGAffineTransformIdentity;
        [self.invitationRequestView hideKeyboard];
    }];
}

#pragma mark - user interaction
/**
 * Handle the behavior when user click on the back button
 */
-(void)closeButtonClick {
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 * RequestInvitationCodeView Delegate
 * Handle behavior when user click on the facebook verification button
 */
-(void)authenticateWithFacebook {
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login logInWithReadPermissions:@[@"email"] handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
        if (error) [self displayFbErrorMessage];
        else if (result.isCancelled) [ErrorMessageDisplay displayErrorAlertOnViewController:self withTitle:FB_LOGIN_CANCEL_TITLE andMessage:FB_LOGIN_CANCEL_MESSAGE];
        else {
            [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:nil] startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id user, NSError *error) {
                if (error) [self displayFbErrorMessage];
                else {
                    NSString *facebookId = user[@"id"];
                    PFQuery *existingUserQuery = [[PFQuery alloc] initWithClassName:@"Users"];
                    [existingUserQuery whereKey:@"fbUid" equalTo:facebookId];
                    [existingUserQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                        if (objects.count > 0) {
                            [ErrorMessageDisplay displayErrorAlertOnViewController:self withTitle:FB_SIGN_UP_ACCOUNT_USED_TITLE andMessage:FB_SIGN_UP_ACCOUNT_USED_DESCRIPTION];
                        } else {
                            if (user[@"email"]) [self.invitationRequestView setEmail:user[@"email"]];
                            else [self.invitationRequestView setEmail:nil];
                            
                            self.codeRequestObj[@"facebook"] = user[@"id"];
                            self.codeRequestObj[@"photo"] = [NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?width=320&height=320", user[@"id"]];
                            if (user[@"name"]) self.codeRequestObj[@"username"] = user[@"name"];
                            if (user[@"first_name"]) self.codeRequestObj[@"firstname"] = user[@"first_name"];
                            if (user[@"last_name"]) self.codeRequestObj[@"lastname"] = user[@"last_name"];
                            if (user[@"gender"]) self.codeRequestObj[@"gender"] = user[@"gender"];
                        }
                    }];
                }
            }];
        }
    }];
}

/**
 * RequestInvitationCodeView delegate
 * Handle the behavior when user click on the request invitation code
 */
-(void)requestCodeWithEmail:(NSString *)email {
    PFQuery *emailQuery = [[PFQuery alloc] initWithClassName:@"Users"];
    [emailQuery whereKey:@"email" equalTo:email];
    [emailQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (objects.count > 0) {
            [ErrorMessageDisplay displayErrorAlertOnViewController:self withTitle:EMAIL_SIGN_UP_EMAIL_USED_TITLE andMessage:EMAIL_SIGN_UP_EMAIL_USED_MESSAGE];
            [self.invitationRequestView enableInvitationCodeRequestButton];
        } else {
            self.codeRequestObj[@"email"] = email;
            [self.successView setEmailAddress:email];
            [self.codeRequestObj saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (error || !succeeded) {
                    [self displayRequestError];
                    [self.invitationRequestView enableInvitationCodeRequestButton];
                } else {
                    [[NSUserDefaults standardUserDefaults] setValue:self.codeRequestObj.objectId forKey:USER_DEFAULT_REQUEST_CODE_ID];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    
                    [UIView animateWithDuration:0.3 animations:^{
                        self.closeButton.alpha = 0;
                        self.invitationRequestView.alpha = 0;
                        [self.successView showView];
                    } completion:^(BOOL finished) {
                        if (finished) {
                            InvitationStatusViewController *statusViewController = [[InvitationStatusViewController alloc] init];
                            statusViewController.invitationCodeObj = self.codeRequestObj;
                            [self.navigationController pushViewController:statusViewController animated:NO];
                        }
                    }];
                }
            }];
        }
    }];
}

#pragma mark - display standard error message
/**
 * Display facebook login error message
 */
-(void)displayFbErrorMessage {
    [ErrorMessageDisplay displayErrorAlertOnViewController:self withTitle:FB_LOGIN_ERROR_TITLE andMessage:FB_LOGIN_ERROR_MESSAGE];
}

/**
 * Display request error
 */
-(void)displayRequestError {
    [ErrorMessageDisplay displayErrorAlertOnViewController:self withTitle:CODE_REQUEST_ERROR_TITLE andMessage:CODE_REQUEST_ERROR_MESSAGE];
}



@end
