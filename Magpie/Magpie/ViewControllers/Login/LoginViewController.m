//
//  LoginViewController.m
//  Magpie
//
//  Created by minh thao nguyen on 4/23/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import "LoginViewController.h"
#import "LoginView.h"
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "ErrorMessageDisplay.h"
#import <Parse/Parse.h>
#import "UserManager.h"
#import "HomePageViewController.h"
#import "UserManager.h"
#import "ParseConstant.h"
#import "Mixpanel.h"
#import "UIImage+ImageEffects.h"
#import "AppDelegate.h"
#import "LoginRequestPasswordViewController.h"
#import "Device.h"

static NSString * const SIGNUP_BACKGROUND_IMAGE = @"SignupBackgroundImage";
static NSString * const SIGNUP_BACKGROUND_IMAGE_BLURRED = @"SignupBackgroundImageBlurred";

static NSString * const CLOSE_BUTTON_NORMAL_IMAGE = @"NavigationBarCloseIconWhite";
static NSString * const CLOSE_BUTTON_HIGHLIGHT_IMAGE = @"NavigationBarCloseIconRed";

@interface LoginViewController ()
@property (nonatomic, assign) CGFloat screenWidth;
@property (nonatomic, assign) CGFloat screenHeight;

@property (nonatomic, strong) UIImageView *backgroundImage;
@property (nonatomic, strong) UIImageView *blurredBackgroundImage;

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) LoginView *loginView;
@end

@implementation LoginViewController
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
        _blurredBackgroundImage.image = blurredImage;//[UIImage imageNamed:SIGNUP_BACKGROUND_IMAGE_BLURRED];
        _blurredBackgroundImage.alpha = 0;
    }
    return _blurredBackgroundImage;
}

/**
 * Lazily init the login view
 * @return LoginView
 */
-(LoginView *)loginView {
    if (_loginView == nil) {
        _loginView = [[LoginView alloc] initWithFrame:CGRectMake(0, 0, self.screenWidth, self.screenHeight)];
        _loginView.loginViewDelegate = self;
    }
    return _loginView;
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

#pragma mark - public methods
- (void)viewDidLoad {
    [super viewDidLoad];
    self.screenWidth = [[UIScreen mainScreen] bounds].size.width;
    self.screenHeight = [[UIScreen mainScreen] bounds].size.height;
    
    [self.view addSubview:[self backgroundImage]];
    [self.view addSubview:[self blurredBackgroundImage]];

    
    [self.view addSubview:[self loginView]];
    [self.view addSubview:[self closeButton]];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarHidden = YES;
    [self.navigationController setNavigationBarHidden:YES animated:false];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [UIView animateWithDuration:0.5 animations:^{
        self.blurredBackgroundImage.alpha = 1;
        [self.loginView showView];
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
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
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
        self.view.transform = CGAffineTransformMakeTranslation(0, -keyboardBounds.size.height + 20);
        [self.loginView showKeyboard:keyboardBounds.size.height];
    }];
}

/**
 * On keyboard hiding, move the view down
 * @param notif
 */
- (void)keyboardWillHide:(NSNotification *)notif{
    [UIView animateWithDuration:0.3 animations:^{
        self.view.transform = CGAffineTransformIdentity;
        [self.loginView hideKeyboard];
    }];
}

#pragma mark - button click and delegate
/**
 * LoginView Delegate
 * Handle the behavior when the user clicked on the fb login button
 */
-(void)loginFbButtonClicked {
    [[Mixpanel sharedInstance] track:@"Login Click - Facebook"];
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login logInWithReadPermissions:@[@"email"] handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
        if (error) {
            [ErrorMessageDisplay displayErrorAlertOnViewController:self withTitle:FB_LOGIN_ERROR_TITLE andMessage:FB_LOGIN_ERROR_MESSAGE];
            [self.loginView enableLoginButtons];
        } else if (result.isCancelled) {
            [ErrorMessageDisplay displayErrorAlertOnViewController:self withTitle:FB_LOGIN_CANCEL_TITLE andMessage:FB_LOGIN_CANCEL_MESSAGE];
            [self.loginView enableLoginButtons];
        } else {
            [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:nil] startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id user, NSError *error) {
                if (error) {
                    [ErrorMessageDisplay displayErrorAlertOnViewController:self withTitle:FB_LOGIN_ERROR_TITLE andMessage:FB_LOGIN_ERROR_MESSAGE];
                    [self.loginView enableLoginButtons];
                } else {
                    NSString *fbid = user[@"id"] ? user[@"id"] : nil;
                    
                    PFQuery *query = [PFQuery queryWithClassName:@"Users"];
                    [query whereKey:@"fbUid" equalTo:fbid];
                    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                        if (objects.count > 0) [self userLoggedIn:objects[0]]; //if exist
                        else [ErrorMessageDisplay displayErrorAlertOnViewController:self withTitle:FB_LOGIN_USER_DID_NOT_SIGN_UP_TITLE andMessage:FB_LOGIN_USER_DID_NOT_SIGN_UP_DESCRIPTION];
                    }];
                }
            }];
        }
    }];
}

/**
 * Loginview Delegate
 * Handle the behavior when the user click on the login button by email
 * @param email
 * @param password
 */
-(void)loginWithEmail:(NSString *)email andPassword:(NSString *)password {
    [[Mixpanel sharedInstance] track:@"Login Click - Email"];
    PFQuery *query = [PFQuery queryWithClassName:@"Users"];
    [query whereKey:@"email" equalTo:email];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            [ErrorMessageDisplay displayErrorAlertOnViewController:self withTitle:EMAIL_SIGNIN_ERROR_TITLE andMessage:EMAIL_SIGNIN_ERROR_DESCRIPTION];
            [self.loginView enableLoginButtons];
        } else if (objects.count == 0) {
            [ErrorMessageDisplay displayErrorAlertOnViewController:self withTitle:EMAIL_SIGNIN_EMAIL_NOT_FOUND_TITLE andMessage:EMAIL_SIGNIN_EMAIL_NOT_FOUND_DESCRIPTION];
            [self.loginView enableLoginButtons];
        } else {
            PFObject *userObj = objects[0];
            NSString *loginType = userObj[@"loginType"] ? userObj[@"loginType"] : @"";
            NSData *savedPassword= userObj[@"password"] ? userObj[@"password"] : nil;
            
            if ([loginType isEqualToString:@"facebook"]) {
                [ErrorMessageDisplay displayErrorAlertOnViewController:self withTitle:EMAIL_SIGNIN_FB_SIGNIN_REQUIRED_TITLE andMessage:EMAIL_SIGNIN_FB_SIGNIN_REQUIRED_DESCRIPTION];
                [self.loginView enableLoginButtons];
            } else {
                NSData *decryptedSavedPassword = [ParseConstant decryptPassword:savedPassword withEmail:email];
                NSData *decryptedPassword = [ParseConstant decryptPassword:[ParseConstant encryptPassword:password withEmail:email] withEmail:email];
                if (![decryptedSavedPassword isEqualToData:decryptedPassword]) {
                    [ErrorMessageDisplay displayErrorAlertOnViewController:self withTitle:EMAIL_SIGNIN_WRONG_EMAIL_OR_PASSWORD_TITLE andMessage:EMAIL_SIGNIN_WRONG_EMAIL_OR_PASSWORD_DESCRIPTION];
                    [self.loginView enableLoginButtons];
                } else [self userLoggedIn:userObj];
            }
        }
    }];
}

/**
 * Handle the behavior when user click on forgot password
 */
-(void)forgotPasswordClick {
    LoginRequestPasswordViewController *forgotPasswordViewController = [[LoginRequestPasswordViewController alloc] init];
    forgotPasswordViewController.capturedBackground = [Device captureScreenshot];
    [self.navigationController pushViewController:forgotPasswordViewController animated:NO];
}

/**
 * Handle the behavior when user clicked on the close button
 */
-(void)closeButtonClick {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - private helpers
/**
 * Handle the behavior when user has successfully logged in 
 * @param PFObject
 */
-(void)userLoggedIn:(PFObject *)userObj {
    if (userObj) {
        [userObj pinInBackgroundWithName:@"user"];
        [PFObject unpinAllObjectsInBackgroundWithName:@"favorite"];
        PFQuery *placesQuery = [PFQuery queryWithClassName:@"Property"];
        [placesQuery includeKey:@"amenity"];
        [placesQuery whereKey:@"owner" equalTo:userObj];
        [placesQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (objects.count > 0) [PFObject pinAllInBackground:objects withName:@"places"];
            
            PFInstallation *currentInstallation = [PFInstallation currentInstallation];
            currentInstallation[@"user"] = userObj;
            [currentInstallation saveInBackground];
            
            //we update the information in user manager class
            NSArray *properties = objects ? objects : [[NSArray alloc] init];
            [[UserManager sharedUserManager] setUserObj:userObj];
            [[UserManager sharedUserManager] setUserProperties:properties];
        }];
    }
    [self goToHomePage];
}

/**
 * Go to the home page
 */
-(void)goToHomePage {
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:USER_DEFAULT_SIGNED_UP];
    HomePageViewController *homePageViewController = [[HomePageViewController alloc] init];
    [self.navigationController pushViewController:homePageViewController animated:YES];
}


@end
