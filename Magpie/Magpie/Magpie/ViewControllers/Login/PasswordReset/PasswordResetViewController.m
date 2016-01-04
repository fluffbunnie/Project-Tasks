//
//  PasswordResetViewController.m
//  Magpie
//
//  Created by minh thao nguyen on 9/3/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import "PasswordResetViewController.h"
#import "HomePageViewController.h"
#import "UserManager.h"
#import "UIImage+ImageEffects.h"
#import "AppDelegate.h"
#import "FloatUnderlinePlaceHolderTextField.h"
#import "FontColor.h"
#import "ParseConstant.h"
#import "ValuePropViewController.h"


static NSString * const SIGNUP_BACKGROUND_IMAGE_BLURRED = @"SignupBackgroundImageBlurred";

static NSString * const CLOSE_BUTTON_NORMAL_IMAGE = @"NavigationBarCloseIconWhite";
static NSString * const CLOSE_BUTTON_HIGHLIGHT_IMAGE = @"NavigationBarCloseIconRed";

@interface PasswordResetViewController ()
@property (nonatomic, assign) CGFloat screenWidth;
@property (nonatomic, assign) CGFloat screenHeight;
@property (nonatomic, strong) UIImageView *blurredBackgroundImage;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) FloatUnderlinePlaceHolderTextField *passwordTextField;
@property (nonatomic, strong) UIButton *saveButton;
@property (nonatomic, strong) UIButton *closeButton;
@end

@implementation PasswordResetViewController
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
 * Lazily nit the title label
 * @return UILabel
 */
-(UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 64, self.screenWidth, 40)];
        _titleLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:20];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.text = @"Enter your new password";
    }
    return _titleLabel;
}

/**
 * Lazily init the password textfield
 * @return FloatUnderlinePlaceHolderTextField
 */
-(FloatUnderlinePlaceHolderTextField *)passwordTextField {
    if (_passwordTextField == nil) {
        _passwordTextField = [[FloatUnderlinePlaceHolderTextField alloc] initWithPlaceHolder:@"Password" andFrame:CGRectMake(30, 160, self.screenWidth - 60, 50)];
        _passwordTextField.delegate = self;
        _passwordTextField.secureTextEntry = YES;
        [_passwordTextField addTarget:self action:@selector(textFieldDidChange) forControlEvents:UIControlEventEditingChanged];
    }
    return _passwordTextField;
}

/**
 * Lazily init the save button
 * @return UIButton
 */
-(UIButton *)saveButton {
    if (_saveButton == nil) {
        _saveButton = [[UIButton alloc] initWithFrame:CGRectMake(30, self.screenHeight - 100, self.screenWidth - 60, 50)];
        _saveButton.layer.cornerRadius = 25;
        _saveButton.layer.masksToBounds = YES;
        _saveButton.enabled = NO;
        _saveButton.titleLabel.font = [UIFont fontWithName:@"AvenirNext-Medium" size:15];
        
        [_saveButton setTitle:@"Save" forState:UIControlStateNormal];
        
        [_saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_saveButton setTitleColor:[UIColor colorWithWhite:1 alpha:0.7] forState:UIControlStateDisabled];
        
        [_saveButton setBackgroundImage:[FontColor imageWithColor:[FontColor greenThemeColor]] forState:UIControlStateNormal];
        [_saveButton setBackgroundImage:[FontColor imageWithColor:[FontColor darkGreenThemeColor]] forState:UIControlStateHighlighted];
        [_saveButton setBackgroundImage:[FontColor imageWithColor:[UIColor colorWithWhite:1 alpha:0.2]] forState:UIControlStateDisabled];
        
        [_saveButton addTarget:self action:@selector(saveButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _saveButton;
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
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.screenWidth = [[UIScreen mainScreen] bounds].size.width;
    self.screenHeight = [[UIScreen mainScreen] bounds].size.height;
    
    [self.view addSubview:[self blurredBackgroundImage]];
    [self.view addSubview:[self titleLabel]];
    [self.view addSubview:[self passwordTextField]];
    [self.view addSubview:[self saveButton]];
    [self.view addSubview:[self closeButton]];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarHidden = YES;
    [self.navigationController setNavigationBarHidden:YES animated:false];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
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
        self.saveButton.frame = CGRectMake(0, self.screenHeight - keyboardBounds.size.height - 50, self.screenWidth, 50);
        self.saveButton.layer.cornerRadius = 0;
    }];
}

/**
 * On keyboard hiding, move the view down
 * @param notif
 */
- (void)keyboardWillHide:(NSNotification *)notif{
    [UIView animateWithDuration:0.3 animations:^{
        self.saveButton.frame = CGRectMake(30, self.screenHeight - 100, self.screenWidth - 60, 50);
        self.saveButton.layer.cornerRadius = 25;
    }];
}

#pragma mark - private helper
/**
 * Handle the behavior when user change the password text
 */
-(void)textFieldDidChange {
    self.saveButton.enabled = (self.passwordTextField.text.length >= 6);
}

/**
 * Handle the behavior when user click on the login button
 * @param PFObject
 */
-(void)saveButtonClick {
    self.saveButton.enabled = NO;
    NSData *passwordData = [ParseConstant encryptPassword:self.passwordTextField.text withEmail:self.userObj[@"email"]];
    self.userObj[@"password"] = passwordData;
    self.userObj[@"loginType"] = @"email";
    [self.userObj saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [self.userObj pinInBackgroundWithName:@"user"];
        [PFObject unpinAllObjectsInBackgroundWithName:@"favorite"];
        PFQuery *placesQuery = [PFQuery queryWithClassName:@"Property"];
        [placesQuery includeKey:@"amenity"];
        [placesQuery whereKey:@"owner" equalTo:self.userObj];
        [placesQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (objects.count > 0) [PFObject pinAllInBackground:objects withName:@"places"];
            
            PFInstallation *currentInstallation = [PFInstallation currentInstallation];
            currentInstallation[@"user"] = self.userObj;
            [currentInstallation saveInBackground];
            
            //we update the information in user manager class
            NSArray *properties = objects ? objects : [[NSArray alloc] init];
            [[UserManager sharedUserManager] setUserObj:self.userObj];
            [[UserManager sharedUserManager] setUserProperties:properties];
            
            [self goToHomePage];
        }];
    }];
}

/**
 * Go to the home page
 */
-(void)goToHomePage {
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:USER_DEFAULT_SIGNED_UP];
    HomePageViewController *homePageViewController = [[HomePageViewController alloc] init];
    [self.navigationController pushViewController:homePageViewController animated:YES];
}

/**
 * Handle the behavior when user click on the back button
 */
-(void)closeButtonClick {
    ValuePropViewController *valuePropViewController = [[ValuePropViewController alloc] init];
    NSArray *newControllers = [NSArray arrayWithObjects:valuePropViewController, self, nil];
    self.navigationController.viewControllers = newControllers;
    [self.navigationController popViewControllerAnimated:YES];
}

@end
