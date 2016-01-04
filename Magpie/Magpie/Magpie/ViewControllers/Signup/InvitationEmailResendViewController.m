//
//  InvitationEmailResendViewController.m
//  Magpie
//
//  Created by minh thao nguyen on 8/19/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import "InvitationEmailResendViewController.h"
#import "UIImage+ImageEffects.h"
#import "FloatUnderlinePlaceHolderTextField.h"
#import "FontColor.h"
#import "EmailValidation.h"
#import "InvitationStatusRequestCodeSentViewController.h"

static NSString * const SIGNUP_BACKGROUND_IMAGE_BLURRED = @"SignupBackgroundImageBlurred";

static NSString * const CLOSE_BUTTON_NORMAL_IMAGE = @"NavigationBarCloseIconWhite";
static NSString * const CLOSE_BUTTON_HIGHLIGHT_IMAGE = @"NavigationBarCloseIconRed";

@interface InvitationEmailResendViewController ()
@property (nonatomic, assign) CGFloat screenWidth;
@property (nonatomic, assign) CGFloat screenHeight;

@property (nonatomic, strong) UIImageView *backgroundImage;
@property (nonatomic, strong) UIImageView *blurredBackgroundImage;

@property (nonatomic, strong) FloatUnderlinePlaceHolderTextField *emailTextField;
@property (nonatomic, strong) UIButton *saveButton;
@property (nonatomic, strong) UIButton *closeButton;
@end

@implementation InvitationEmailResendViewController
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
 * Lazily init the email textfield
 * @return FloatUnderlinePlaceHolderTextField
 */
-(FloatUnderlinePlaceHolderTextField *)emailTextField {
    if (_emailTextField == nil) {
        _emailTextField = [[FloatUnderlinePlaceHolderTextField alloc] initWithPlaceHolder:@"Email" andFrame:CGRectMake(30, 100, self.screenWidth - 60, 50)];
        _emailTextField.text = self.email;
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
        _saveButton.titleLabel.font = [UIFont fontWithName:@"AvenirNext-Medium" size:15];
        
        [_saveButton setTitle:@"Resend the Code" forState:UIControlStateNormal];
        
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
    self.saveButton.enabled = [EmailValidation validateEmail:self.emailTextField.text];
}

/**
 * Handle the case when user click on the save button
 */
-(void)saveButtonClick {
    self.saveButton.enabled = NO;
    self.email = self.emailTextField.text;
    if ([self.emailTextField isFirstResponder]) [self.emailTextField resignFirstResponder];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.blurredBackgroundImage.alpha = 0;
        self.emailTextField.transform = CGAffineTransformMakeTranslation(0, self.screenHeight);
        self.saveButton.transform = CGAffineTransformMakeTranslation(0, self.screenHeight);
        self.closeButton.alpha = 0;
    } completion:^(BOOL finished) {
        if (finished) {
            NSInteger currentViewControllerIndex = [self.navigationController.viewControllers indexOfObject:self];
            UIViewController *previousViewController = [self.navigationController.viewControllers objectAtIndex:currentViewControllerIndex-1];
            if ([previousViewController isKindOfClass:InvitationStatusRequestCodeSentViewController.class]) {
                [(InvitationStatusRequestCodeSentViewController *)previousViewController setEmail:[self.email lowercaseString]];
            }
            
            [self.navigationController popViewControllerAnimated:NO];
        }
    }];
}

/**
 * Handle the behavior when user click on the back button
 */
-(void)closeButtonClick {
    [UIView animateWithDuration:0.3 animations:^{
        self.blurredBackgroundImage.alpha = 0;
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
