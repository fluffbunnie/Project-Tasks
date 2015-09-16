//
//  LoginView.m
//  Magpie
//
//  Created by minh thao nguyen on 5/3/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import "LoginView.h"
#import "FloatUnderlinePlaceHolderTextField.h"
#import "RoundButton.h"
#import "FontColor.h"
#import "EmailValidation.h"
#import "Device.h"

static NSString * MAGPIE_ICON_IMG_NAME = @"MagpieIcon";
static NSString * TITLE_TEXT = @"Sign in - the whole world\nis waiting for you to explore";
static NSString * FB_LOGIN_BUTTON_TITLE = @"Sign in with Facebook";
static NSString * EMAIL_PLACE_HOLDER = @"Email";
static NSString * PASSWORD_PLACE_HOLDER = @"Password";
static NSString * EMAIL_LOGIN_BUTTON_TITLE = @"Sign in with email";
static NSString * FORGOT_PASSWORD = @"Forgot password?";

@interface LoginView()
@property (nonatomic, assign) CGFloat viewWidth;
@property (nonatomic, assign) CGFloat viewHeight;

@property (nonatomic, strong) UIImageView *logoImage;
@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIButton *fbLoginButton;
@property (nonatomic, strong) UILabel *orSeparatorLabel;
@property (nonatomic, strong) FloatUnderlinePlaceHolderTextField *emailTextField;
@property (nonatomic, strong) FloatUnderlinePlaceHolderTextField *passwordTextField;
@property (nonatomic, strong) UIButton *emailLoginButton;

@property (nonatomic, strong) UIButton *forgotPasswordButton;
@end

@implementation LoginView
#pragma mark - initiation

/**
 * Lazily init the logo image
 * @return UIImage
 */
-(UIImageView *)logoImage {
    if (_logoImage == nil) {
        CGRect frame = CGRectMake(0, 84, self.viewWidth, 93);
        if ([Device isIphone6]) frame = CGRectMake(0, 78, self.viewWidth, 80);
        if ([Device isIphone5]) frame = CGRectMake(0, 25, self.viewWidth, 70);
        
        _logoImage = [[UIImageView alloc] initWithFrame:frame];
        _logoImage.contentMode = UIViewContentModeScaleAspectFit;
        _logoImage.image = [UIImage imageNamed:MAGPIE_ICON_IMG_NAME];
    }
    return _logoImage;
}

/**
 * Lazily init the view title
 * @return UILabel
 */
-(UILabel *)titleLabel {
    if (_titleLabel == nil) {
        CGRect frame = CGRectMake(0, 197, self.viewWidth, 60);
        if ([Device isIphone6]) frame = CGRectMake(0, 173, self.viewWidth, 60);
        else if ([Device isIphone5]) frame = CGRectMake(0, 110, self.viewWidth, 60);
        else if ([Device isIphone4]) frame = CGRectMake(0, 30, self.viewWidth, 60);
        
        _titleLabel = [[UILabel alloc] initWithFrame:frame];
        _titleLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:20];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.text = TITLE_TEXT;
        _titleLabel.numberOfLines = 0;
    }
    return _titleLabel;
}

/**
 * Lazily init the login with fb rounded Button
 * @return UIButton
 */
-(UIButton *)fbLoginButton {
    if (_fbLoginButton == nil) {
        _fbLoginButton = [[UIButton alloc] initWithFrame: CGRectMake(30, self.viewHeight - 380, self.viewWidth - 60, 50)];
        _fbLoginButton.titleLabel.font = [UIFont fontWithName:@"AvenirNext-Medium" size:15];
        _fbLoginButton.layer.cornerRadius = 25;
        _fbLoginButton.layer.masksToBounds = YES;
        
        [_fbLoginButton setTitle:FB_LOGIN_BUTTON_TITLE forState:UIControlStateNormal];
        
        [_fbLoginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_fbLoginButton setTitleColor:[UIColor colorWithWhite:1 alpha:0.7] forState:UIControlStateDisabled];
        
        [_fbLoginButton setBackgroundImage:[FontColor imageWithColor:[FontColor fbColor]] forState:UIControlStateNormal];
        [_fbLoginButton setBackgroundImage:[FontColor imageWithColor:[FontColor darkFbColor]] forState:UIControlStateHighlighted];
        [_fbLoginButton setBackgroundImage:[FontColor imageWithColor:[UIColor colorWithWhite:1 alpha:0.2]] forState:UIControlStateDisabled];
        
        [_fbLoginButton addTarget:self action:@selector(fbLoginButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _fbLoginButton;
}

/**
 * Lazily init the or separator label
 * @param UILabel
 */
-(UILabel *)orSeparatorLabel {
    if (_orSeparatorLabel == nil) {
        _orSeparatorLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.viewHeight - 300, self.viewWidth, 20)];
        _orSeparatorLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:14];
        _orSeparatorLabel.textColor = [UIColor whiteColor];
        _orSeparatorLabel.textAlignment = NSTextAlignmentCenter;
        _orSeparatorLabel.text = @"- or -";
    }
    return _orSeparatorLabel;
}

/**
 * Lazily init the email textfield
 * @return FloatUnderlinePlaceHolderTextField
 */
-(FloatUnderlinePlaceHolderTextField *)emailTextField {
    if (_emailTextField == nil) {
        _emailTextField = [[FloatUnderlinePlaceHolderTextField alloc] initWithPlaceHolder:EMAIL_PLACE_HOLDER andFrame:CGRectMake(30, self.viewHeight - 250, self.viewWidth - 60, 50)];
        _emailTextField.delegate = self;
        _emailTextField.autocorrectionType = UITextAutocorrectionTypeNo;
        _emailTextField.keyboardType = UIKeyboardTypeEmailAddress;
        [_emailTextField addTarget:self action:@selector(textFieldDidChange) forControlEvents:UIControlEventEditingChanged];
    }
    return _emailTextField;
}

/**
 * Lazily init the password input text field
 * @return FloatUnderlinePlaceHolderTextField
 */
-(FloatUnderlinePlaceHolderTextField *)passwordTextField {
    if (_passwordTextField == nil) {
        _passwordTextField = [[FloatUnderlinePlaceHolderTextField alloc] initWithPlaceHolder:PASSWORD_PLACE_HOLDER andFrame:CGRectMake(30, self.viewHeight - 180, self.viewWidth - 60, 50)];
        _passwordTextField.secureTextEntry = YES;
        _passwordTextField.delegate = self;
        [_passwordTextField addTarget:self action:@selector(textFieldDidChange) forControlEvents:UIControlEventEditingChanged];
    }
    return _passwordTextField;
}

/**
 * Lazily init the email login button
 * @return UIButton
 */
-(UIButton *)emailLoginButton {
    if (_emailLoginButton == nil) {
        _emailLoginButton = [[UIButton alloc] initWithFrame:CGRectMake(30, self.viewHeight - 100, self.viewWidth - 60, 50)];
        _emailLoginButton.enabled = NO;
        _emailLoginButton.titleLabel.font = [UIFont fontWithName:@"AvenirNext-Medium" size:15];
        _emailLoginButton.layer.cornerRadius = 25;
        _emailLoginButton.layer.masksToBounds = YES;
        
        [_emailLoginButton setTitle:EMAIL_LOGIN_BUTTON_TITLE forState:UIControlStateNormal];
        
        [_emailLoginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_emailLoginButton setTitleColor:[UIColor colorWithWhite:1 alpha:0.7] forState:UIControlStateDisabled];
    
        [_emailLoginButton setBackgroundImage:[FontColor imageWithColor:[FontColor greenThemeColor]] forState:UIControlStateNormal];
        [_emailLoginButton setBackgroundImage:[FontColor imageWithColor:[FontColor darkGreenThemeColor]] forState:UIControlStateHighlighted];
        [_emailLoginButton setBackgroundImage:[FontColor imageWithColor:[UIColor colorWithWhite:1 alpha:0.2]] forState:UIControlStateDisabled];
        
        [_emailLoginButton addTarget:self action:@selector(emailLoginButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _emailLoginButton;
}

/**
 * Lazily init the forgot password button
 * @return UIButton
 */
-(UIButton *)forgotPasswordButton {
    if (_forgotPasswordButton == nil) {
        _forgotPasswordButton = [[UIButton alloc] initWithFrame:CGRectMake((self.viewWidth - 100)/2, self.viewHeight - 40, 100, 30)];
        _forgotPasswordButton.titleLabel.font = [UIFont fontWithName:@"AvenirNext-Medium" size:12];
        [_forgotPasswordButton setTitle:FORGOT_PASSWORD forState:UIControlStateNormal];
        [_forgotPasswordButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_forgotPasswordButton setTitleColor:[FontColor themeColor] forState:UIControlStateHighlighted];
        
        [_forgotPasswordButton addTarget:self action:@selector(forgotPasswordButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _forgotPasswordButton;
}

#pragma mark - public methods
-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.viewWidth = frame.size.width;
        self.viewHeight = frame.size.height;
        self.alpha = 0;
        
        if (![Device isIphone4])[self addSubview:[self logoImage]];
        [self addSubview:[self titleLabel]];
        [self addSubview:[self fbLoginButton]];
        [self addSubview:[self orSeparatorLabel]];
        [self addSubview:[self emailTextField]];
        [self addSubview:[self passwordTextField]];
        [self addSubview:[self emailLoginButton]];
        [self addSubview:[self forgotPasswordButton]];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                       initWithTarget:self
                                       action:@selector(dismissKeyboard)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

/**
 * Show the view. This happen when user click on the login with email
 */
-(void)showView {
    self.alpha = 1;
}

/**
 * Enable the login button
 */
-(void)enableLoginButtons {
    self.emailLoginButton.enabled = ([EmailValidation validateEmail:self.emailTextField.text] && self.passwordTextField.text.length >=6);
    self.fbLoginButton.enabled = YES;
}

/**
 * When the keyboard is show, we move the content of the signup button up if needed
 * @param CGFloat
 */
-(void)showKeyboard:(CGFloat)keyboardHeight {
    self.forgotPasswordButton.alpha = 0;
    self.emailLoginButton.frame = CGRectMake(0, self.viewHeight - 100, self.viewWidth, 50);
    self.emailLoginButton.transform = CGAffineTransformMakeTranslation(0, 30);
    self.emailLoginButton.layer.cornerRadius = 0;
}

/**
 * When the keyboard is hidden, we return the button back to usual position
 */
-(void)hideKeyboard {
    self.forgotPasswordButton.alpha = 1;
    self.emailLoginButton.transform = CGAffineTransformIdentity;
    self.emailLoginButton.layer.cornerRadius = 25;
    self.emailLoginButton.frame = CGRectMake(30, self.viewHeight - 100, self.viewWidth - 60, 50);
}

#pragma mark - ui action
/**
 * Handle the behavior when the user tap outside the text field
 */
-(void)dismissKeyboard {
    if (self.emailTextField.isFirstResponder) [self.emailTextField resignFirstResponder];
    else if (self.passwordTextField.isFirstResponder) [self.passwordTextField resignFirstResponder];
}

/**
 * Handle the behavior when user click on the fb-login button
 */
-(void)fbLoginButtonClick {
    self.fbLoginButton.enabled = NO;
    [self.loginViewDelegate loginFbButtonClicked];
}

/**
 * Handle the behavior when user click on the email-login button
 */
-(void)emailLoginButtonClick {
    self.emailLoginButton.enabled = NO;
    [self.loginViewDelegate loginWithEmail:[self.emailTextField.text lowercaseString] andPassword:self.passwordTextField.text];
}

/**
 * handle the behavior when user click on forgot password
 */
-(void)forgotPasswordButtonClick {
    [self.loginViewDelegate forgotPasswordClick];
}

#pragma mark - uitextfield delegate
/**
 * Custom delegate for FloatPlaceholderTextField
 * Call this function when the text field is editted
 * @param FloatPlaceholderTextField
 */
-(void)textFieldDidChange {
    self.emailLoginButton.enabled = ([EmailValidation validateEmail:self.emailTextField.text] && self.passwordTextField.text.length >=6);
}

/**
 * Handle the behavior when the user click on the done button
 * @param UITextField
 * @return BOOL
 */
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

@end
