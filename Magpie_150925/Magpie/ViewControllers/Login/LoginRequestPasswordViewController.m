//
//  LoginRequestPasswordViewController.m
//  Magpie
//
//  Created by minh thao nguyen on 8/19/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import "LoginRequestPasswordViewController.h"
#import "UIImage+ImageEffects.h"
#import "FloatUnderlinePlaceHolderTextField.h"
#import "FontColor.h"
#import "EmailValidation.h"
#import "ErrorMessageDisplay.h"
#import <Parse/Parse.h>
#import "ToastView.h"

static NSString * const SIGNUP_BACKGROUND_IMAGE_BLURRED = @"SignupBackgroundImageBlurred";

static NSString * const CLOSE_BUTTON_NORMAL_IMAGE = @"NavigationBarCloseIconWhite";
static NSString * const CLOSE_BUTTON_HIGHLIGHT_IMAGE = @"NavigationBarCloseIconRed";

@interface LoginRequestPasswordViewController ()
@property (nonatomic, assign) CGFloat screenWidth;
@property (nonatomic, assign) CGFloat screenHeight;

@property (nonatomic, strong) UIImageView *backgroundImage;
@property (nonatomic, strong) UIImageView *blurredBackgroundImage;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) FloatUnderlinePlaceHolderTextField *emailTextField;
@property (nonatomic, strong) UIButton *saveButton;
@property (nonatomic, strong) UIButton *closeButton;
@end

@implementation LoginRequestPasswordViewController

#pragma mark - initiation
/**
 * Lazily init the background image
 * @return UIImageView
 */
-(UIImageView *)backgroundImage {
    if (_backgroundImage == nil) {
        _backgroundImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.screenWidth, self.screenHeight)];
        _backgroundImage.contentMode = UIViewContentModeScaleAspectFill;
        _backgroundImage.image = self.capturedBackground;
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
 * Lazily nit the title label
 * @return UILabel
 */
-(UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 64, self.screenWidth, 40)];
        _titleLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:20];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.text = @"Request new password";
    }
    return _titleLabel;
}

/**
 * Lazily init the email textfield
 * @return FloatUnderlinePlaceHolderTextField
 */
-(FloatUnderlinePlaceHolderTextField *)emailTextField {
    if (_emailTextField == nil) {
        _emailTextField = [[FloatUnderlinePlaceHolderTextField alloc] initWithPlaceHolder:@"Email" andFrame:CGRectMake(30, 160, self.screenWidth - 60, 50)];
        _emailTextField.delegate = self;
        _emailTextField.autocorrectionType = UITextAutocorrectionTypeNo;
        _emailTextField.keyboardType = UIKeyboardTypeEmailAddress;
        _emailTextField.transform = CGAffineTransformMakeTranslation(0, self.screenHeight);
        [_emailTextField addTarget:self action:@selector(textFieldDidChange) forControlEvents:UIControlEventEditingChanged];
    }
    return _emailTextField;
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
        
        [_saveButton setTitle:@"Request link" forState:UIControlStateNormal];
        
        [_saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_saveButton setTitleColor:[UIColor colorWithWhite:1 alpha:0.7] forState:UIControlStateDisabled];
        
        [_saveButton setBackgroundImage:[FontColor imageWithColor:[FontColor greenThemeColor]] forState:UIControlStateNormal];
        [_saveButton setBackgroundImage:[FontColor imageWithColor:[FontColor darkGreenThemeColor]] forState:UIControlStateHighlighted];
        [_saveButton setBackgroundImage:[FontColor imageWithColor:[UIColor colorWithWhite:1 alpha:0.2]] forState:UIControlStateDisabled];
        
        _saveButton.transform = CGAffineTransformMakeTranslation(0, self.screenHeight);
        
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


#pragma mark - public method
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.screenWidth = [[UIScreen mainScreen] bounds].size.width;
    self.screenHeight = [[UIScreen mainScreen] bounds].size.height;
    
    [self.view addSubview:[self backgroundImage]];
    [self.view addSubview:[self blurredBackgroundImage]];
    [self.view addSubview:[self titleLabel]];
    [self.view addSubview:[self emailTextField]];
    [self.view addSubview:[self saveButton]];
    [self.view addSubview:[self closeButton]];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(resignResponder)];
    [self.view addGestureRecognizer:tap];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarHidden = YES;
    [self.navigationController setNavigationBarHidden:YES animated:false];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [UIView animateWithDuration:0.3 animations:^{
        self.blurredBackgroundImage.alpha = 1;
        self.titleLabel.transform = CGAffineTransformIdentity;
        self.emailTextField.transform = CGAffineTransformIdentity;
        self.saveButton.transform = CGAffineTransformIdentity;
        self.closeButton.alpha = 1;
    } completion:^(BOOL finished) {
        if (finished) [self.emailTextField becomeFirstResponder];
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

#pragma mark - user interaction
/**
 * Resign the responder when user tap outside the textfield
 */
-(void)resignResponder {
    if ([self.emailTextField isFirstResponder]) [self.emailTextField resignFirstResponder];
}

/**
 * Handle the behavior when text field changed
 */
-(void)textFieldDidChange {
    NSString *currentText= self.emailTextField.text;
    self.saveButton.enabled = [EmailValidation validateEmail:currentText];
}

/**
 * Handle the case when user click on the save button
 */
-(void)saveButtonClick {
    self.saveButton.enabled = NO;
    if ([self.emailTextField isFirstResponder]) [self.emailTextField resignFirstResponder];
    
    NSString *currentText= [self.emailTextField.text lowercaseString];
    PFQuery *query = [PFQuery queryWithClassName:@"Users"];
    [query whereKey:@"email" equalTo:currentText];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error || objects.count == 0) {
            [ErrorMessageDisplay displayErrorAlertOnViewController:self withTitle:EMAIL_SIGNIN_EMAIL_NOT_FOUND_TITLE andMessage:EMAIL_SIGNIN_EMAIL_NOT_FOUND_DESCRIPTION];
        } else {
            PFObject *emailObj = [PFObject objectWithClassName:@"Email"];
            emailObj[@"user"] = objects[0];
            emailObj[@"type"] = @"password reset";
            [emailObj saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    [ErrorMessageDisplay displayErrorAlertOnViewController:self withTitle:@"Email sent" andMessage:@"A password reset link has been sent to your email. Please check your email."];
                } else {
                    [ErrorMessageDisplay displayErrorAlertOnViewController:self withTitle:@"Network error" andMessage:STANDARD_ERROR_MESSAGE];
                    self.saveButton.enabled = YES;
                }
            }];
        }
    }];
}

/**
 * Handle the behavior when user click on the back button
 */
-(void)closeButtonClick {
    [UIView animateWithDuration:0.3 animations:^{
        self.blurredBackgroundImage.alpha = 0;
        self.titleLabel.transform = CGAffineTransformMakeTranslation(0, self.screenHeight);
        self.emailTextField.transform = CGAffineTransformMakeTranslation(0, self.screenHeight);
        self.saveButton.transform = CGAffineTransformMakeTranslation(0, self.screenHeight);
        self.closeButton.alpha = 0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self.navigationController popViewControllerAnimated:NO];
        }
    }];
}


@end
