//
//  SignUpWithInvitationViewController.m
//  Magpie
//
//  Created by minh thao nguyen on 7/20/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import "SignUpWithInvitationViewController.h"
#import "ErrorMessageDisplay.h"
#import "Device.h"
#import <Parse/Parse.h>
#import "UserManager.h"
#import "HomePageViewController.h"
#import "TermsOfServiceViewController.h"
#import "PrivacyPolicyViewController.h"
#import "ParseConstant.h"
#import "Mixpanel.h"
#import "SignupRequestInvitationCodeViewController.h"
#import "GuidedInteractionFirstViewController.h"
#import "UIImage+ImageEffects.h"
#import "FontColor.h"
#import "AppDelegate.h"
#import "GuidedInteractionFirstViewController.h"
#import "ValuePropViewController.h"

static NSString * const SIGNUP_BACKGROUND_IMAGE = @"SignupBackgroundImage";
static NSString * const SIGNUP_BACKGROUND_IMAGE_BLURRED = @"SignupBackgroundImageBlurred";

static NSString * const CLOSE_BUTTON_NORMAL_IMAGE = @"NavigationBarCloseIconWhite";
static NSString * const CLOSE_BUTTON_HIGHLIGHT_IMAGE = @"NavigationBarCloseIconRed";

@interface SignUpWithInvitationViewController ()
@property (nonatomic, assign) CGFloat screenWidth;
@property (nonatomic, assign) CGFloat screenHeight;

@property (nonatomic, strong) UIImageView *backgroundImage;
@property (nonatomic, strong) UIImageView *blurredBackgroundImage;

@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) SignUpWithInvitationView *signupView;
@end

@implementation SignUpWithInvitationViewController

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
 * Lazily init the signup view
 * @return SignUpWithInvitationView
 */
-(SignUpWithInvitationView *)signupView {
    if (_signupView == nil) {
        _signupView = [[SignUpWithInvitationView alloc] initWithFrame:CGRectMake(0, 0, self.screenWidth, self.screenHeight)];
        _signupView.signupViewDelegate = self;
    }
    return _signupView;
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
    
    [self.view addSubview:[self signupView]];
    [self.view addSubview:[self closeButton]];
    
    if (self.code) [self.signupView setCode:self.code];
    if (self.email) [self.signupView setEmail:self.email];
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
        self.signupView.alpha = 1;
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
        if ([Device isIphone4]) self.view.transform = CGAffineTransformMakeTranslation(0, -keyboardBounds.size.height + 125);
        else if ([Device isIphone5]) self.view.transform = CGAffineTransformMakeTranslation(0, -keyboardBounds.size.height + 55);
        else self.view.transform = CGAffineTransformMakeTranslation(0, -keyboardBounds.size.height + 50);
        [self.signupView showKeyboard:keyboardBounds.size.height];
    }];
}

/**
 * On keyboard hiding, move the view down
 * @param notif
 */
- (void)keyboardWillHide:(NSNotification *)notif{
    [UIView animateWithDuration:0.3 animations:^{
        self.view.transform = CGAffineTransformIdentity;
        [self.signupView hideKeyboard];
    }];
}

#pragma mark - button click and delegate
/**
 * Go to the term of services screen
 */
-(void)goToTermsOfService {
    [self resignResponder];
    [[Mixpanel sharedInstance] track:@"Terms Click"];
    TermsOfServiceViewController *termsOfServiceViewController = [[TermsOfServiceViewController alloc] init];
    [self.navigationController pushViewController:termsOfServiceViewController animated:YES];
}

/**
 * Go to the privacy policy screen
 */
-(void)goToPrivacyPolicy {
    [self resignResponder];
    [[Mixpanel sharedInstance] track:@"Privacy Policy Click"];
    PrivacyPolicyViewController *privacyPolicyViewController = [[PrivacyPolicyViewController alloc] init];
    [self.navigationController pushViewController:privacyPolicyViewController animated:YES];
}

/**
 * SignUpEmailView Delegate
 * Handle the behavior when the user click on the login button by email
 * @param email
 * @param password
 * @param code
 */
-(void)signUpWithEmail:(NSString *)email password:(NSString *)password andCode:(NSString *)code {
    [self resignResponder];
    [[Mixpanel sharedInstance] track:@"Sign Up Click - Email"];
    if (password.length < 6) {
        [ErrorMessageDisplay displayErrorAlertOnViewController:self withTitle:EMAIL_SIGN_UP_PASSWORD_TOO_SHORT_TITLE andMessage:EMAIL_SIGN_UP_PASSWORD_TOO_SHORT_MESSAGE];
        [self.signupView enableSignupButton];
    } else {
        PFQuery *query = [PFQuery queryWithClassName:@"Users"];
        [query whereKey:@"email" equalTo:email];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (error) {
                [ErrorMessageDisplay displayErrorAlertOnViewController:self withTitle:EMAIL_SIGN_UP_ERROR_TITLE andMessage:EMAIL_SIGN_UP_ERROR_MESSAGE];
                [self.signupView enableSignupButton];
            } else if (objects.count > 0) {
                [ErrorMessageDisplay displayErrorAlertOnViewController:self withTitle:EMAIL_SIGN_UP_EMAIL_USED_TITLE andMessage:EMAIL_SIGN_UP_EMAIL_USED_MESSAGE];
                [self.signupView enableSignupButton];
            } else {
                PFQuery *inviteCodeQuery = [PFQuery queryWithClassName:@"InvitationCode"];
                [inviteCodeQuery whereKey:@"email" equalTo:email];
                [inviteCodeQuery whereKey:@"code" equalTo:code];
                [inviteCodeQuery findObjectsInBackgroundWithBlock:^(NSArray *iobjects, NSError *error) {
                    if (error) {
                        [ErrorMessageDisplay displayErrorAlertOnViewController:self withTitle:EMAIL_SIGN_UP_ERROR_TITLE andMessage:EMAIL_SIGN_UP_ERROR_MESSAGE];
                        [self.signupView enableSignupButton];
                    } else if (iobjects.count == 0) {
                        [ErrorMessageDisplay displayErrorAlertOnViewController:self withTitle:EMAIL_SIGN_UP_WRONG_CODE_TITLE andMessage:EMAIL_SIGN_UP_WRONG_CODE_MESSAGE];
                        [self.signupView enableSignupButton];
                    } else {
                        PFObject *userWithCode = iobjects[0];
                        NSString *fbId = userWithCode[@"facebook"] ? userWithCode[@"facebook"]: nil;
                        
                        if (fbId == nil) {
                            [self createNewUserFromInvitationCode:userWithCode email:email andPassword:password];
                        } else {
                            PFQuery *facebookUserQuery = [PFQuery queryWithClassName:@"Users"];
                            [facebookUserQuery whereKey:@"fbUid" equalTo:fbId];
                            [facebookUserQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                                if (objects.count > 0) {
                                    [ErrorMessageDisplay displayErrorAlertOnViewController:self withTitle:@"Account In Use" andMessage:@"The Facebook account for this code is already in use. Please log in."];
                                } else {
                                    [self createNewUserFromInvitationCode:userWithCode email:email andPassword:password];
                                }
                            }];
                        }
                    }
                }];
            }
        }];
    }
}

/**
 * Create a new user oject from the invitation code
 * @param PFObject
 * @param NSString
 */
-(void)createNewUserFromInvitationCode:(PFObject *)userWithCode email:(NSString *)email andPassword:(NSString *)password {
    userWithCode[@"status"] =  @"SIGNED_UP";
    [userWithCode saveInBackground];
    
    PFObject *userObj = [PFObject objectWithClassName:@"Users"];
    userObj[@"loginType"] = @"email";
    if (userWithCode[@"username"]) userObj[@"username"] = userWithCode[@"username"];
    if (userWithCode[@"firstname"]) userObj[@"firstname"] = userWithCode[@"firstname"];
    if (userWithCode[@"lastname"]) userObj[@"lastname"] = userWithCode[@"lastname"];
    if (userWithCode[@"photo"]) userObj[@"profilePic"] = userWithCode[@"photo"];
    if (userWithCode[@"gender"]) userObj[@"gender"] = userWithCode[@"gender"];
    
    userObj[@"email"] = email;
    userObj[@"password"] = [ParseConstant encryptPassword:password withEmail:email];
    userObj[@"numLikes"] = @0;
    userObj[@"numMatches"] = @0;
    userObj[@"numConversations"] = @0;
    userObj[@"numProperties"] = @0;
    if (userWithCode[@"facebook"]) userObj[@"fbUid"] = userWithCode[@"facebook"];
    if (userWithCode[@"linkedIn"]) userObj[@"linkedIn"] = userWithCode[@"linkedIn"];
    
    [userObj saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (error) {
            [ErrorMessageDisplay displayErrorAlertOnViewController:self withTitle:EMAIL_SIGN_UP_ERROR_TITLE andMessage:EMAIL_SIGN_UP_ERROR_MESSAGE];
            [self.signupView enableSignupButton];
        } else [self userSignedUpWithUserObject:userObj andLoginType:@"email"];
    }];

}

/**
 * Handle the behavior when user clicked on the close button
 */
-(void)closeButtonClick {
    [self resignResponder];
    NSInteger currentViewControllerIndex = [self.navigationController.viewControllers indexOfObject:self];
    if (currentViewControllerIndex != 0) [self.navigationController popViewControllerAnimated:YES];
    else {
        ValuePropViewController *valuePropViewController = [[ValuePropViewController alloc] init];
        NSArray *newControllers = [NSArray arrayWithObjects:valuePropViewController, self, nil];
        self.navigationController.viewControllers = newControllers;
        [self.navigationController popViewControllerAnimated:YES];
    }
}

/**
 * Handle the behavior when user click on request the invitational code
 */
-(void)goToRequestCodeScreen {
    [self resignResponder];
    SignupRequestInvitationCodeViewController *requestCodeViewController = [[SignupRequestInvitationCodeViewController alloc] init];
    [self.navigationController pushViewController:requestCodeViewController animated:YES];
}

/**
 * Handle the behavior when the user tap outside the email button
 */
-(void)resignResponder {
    [self.signupView resignResponder];
}

#pragma mark - private helpers
/**
 * Handle the behavior when user has successfully logged in
 * @param PFObject
 */
-(void)userLoggedIn:(PFObject *)userObj {
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
        
        [self goToGuidedInteractionView];
    }];
}

/**
 * Handle the behavior when the user has successfully sign up
 * @param PFObject
 * @param NSString
 */
-(void)userSignedUpWithUserObject:(PFObject *)userObj andLoginType:(NSString *)loginType {
    [userObj pinInBackgroundWithName:@"user"];
    [[UserManager sharedUserManager] setUserObj:userObj];
    
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    currentInstallation[@"user"] = userObj;
    [currentInstallation saveInBackground];
    
    //finally, before pushing the new view, we want to record all the favorite items in
    PFQuery *favoriteQuery = [PFQuery queryWithClassName:@"Favorite"];
    [favoriteQuery fromLocalDatastore];
    [favoriteQuery fromPinWithName:@"favorite"];
    [favoriteQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        NSMutableArray *favorites = [[NSMutableArray alloc] init];
        if (objects.count > 0) {
            for (PFObject *favorite in objects) {
                favorite[@"user"] = userObj;
                [favorites addObject:favorite];
            }
            
            userObj[@"numLikes"] = @(objects.count);
            [[UserManager sharedUserManager] setUserObj:userObj];
        }
        [PFObject saveAllInBackground:favorites];
        [PFObject unpinAllInBackground:objects];
        
        [self goToGuidedInteractionView];
    }];
}

/**
 * Private class to register for push notification
 */
-(void)goToGuidedInteractionView {
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:USER_DEFAULT_SIGNED_UP];
    GuidedInteractionFirstViewController *firstViewController = [[GuidedInteractionFirstViewController alloc] init];
    [self.navigationController pushViewController:firstViewController animated:YES];
    
}

@end
