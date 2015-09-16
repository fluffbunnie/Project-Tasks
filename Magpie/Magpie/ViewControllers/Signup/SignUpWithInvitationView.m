//
//  SignUpWithInvitationView.m
//  Magpie
//
//  Created by minh thao nguyen on 7/20/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import "SignUpWithInvitationView.h"
#import "FloatUnderlinePlaceholderTextField.h"
#import "FontColor.h"
#import "EmailValidation.h"
#import "Device.h"

static NSString * MAGPIE_ICON_IMG_NAME = @"MagpieIcon";
static NSString * TITLE_TEXT = @"Sign up - the whole world\nis waiting for you to explore";
static NSString * EMAIL_PLACE_HOLDER = @"Email";
static NSString * PASSWORD_PLACE_HOLDER = @"Password";
static NSString * INVITE_CODE_HOLDER = @"Invitation Code";

static NSString * TERMS_TEXT = @"By joining, you agree to our Terms and Privacy Policy.";

static NSString * SIGNUP_BUTTON_TITLE = @"Sign up";

@interface SignUpWithInvitationView()
@property (nonatomic, assign) CGFloat viewWidth;
@property (nonatomic, assign) CGFloat viewHeight;

@property (nonatomic, strong) UIImageView *logoImage;
@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) FloatUnderlinePlaceHolderTextField *emailTextField;
@property (nonatomic, strong) FloatUnderlinePlaceHolderTextField *passwordTextField;
@property (nonatomic, strong) FloatUnderlinePlaceHolderTextField *inviteCodeTextField;

@property (nonatomic, strong) TTTAttributedLabel *termsLabel;
@property (nonatomic, strong) UIButton *signupButton;

@property (nonatomic, strong) UITapGestureRecognizer *tap;

@end

@implementation SignUpWithInvitationView
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
        CGRect frame = CGRectMake(0, 197, self.viewWidth , 60);
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
 * Lazily init the container view
 * @return UIView
 */
-(UIView *)containerView {
    if (_containerView == nil) {
        CGRect frame = CGRectMake(0, 270, self.viewWidth, 265);
        if ([Device isIphone4]) frame = CGRectMake(0, 84, self.viewWidth, 265);
        if ([Device isIphone5]) frame = CGRectMake(0, 170, self.viewWidth, 265);
        if ([Device isIphone6]) frame = CGRectMake(0, 248, self.viewWidth, 265);
        _containerView = [[UIView alloc] initWithFrame:frame];
    }
    return _containerView;
}

/**
 * Lazily init the email textfield
 * @return FloatUnderlinePlaceHolderTextField
 */
-(FloatUnderlinePlaceHolderTextField *)emailTextField {
    if (_emailTextField == nil) {
        _emailTextField = [[FloatUnderlinePlaceHolderTextField alloc] initWithPlaceHolder:EMAIL_PLACE_HOLDER andFrame:CGRectMake(30, 20, self.viewWidth - 60, 50)];
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
        _passwordTextField = [[FloatUnderlinePlaceHolderTextField alloc] initWithPlaceHolder:PASSWORD_PLACE_HOLDER andFrame:CGRectMake(30, 160, self.viewWidth - 60, 50)];
        _passwordTextField.secureTextEntry = YES;
        _passwordTextField.delegate = self;
        [_passwordTextField addTarget:self action:@selector(textFieldDidChange) forControlEvents:UIControlEventEditingChanged];
    }
    return _passwordTextField;
}

/** 
 * Lazily init the password code text field
 * @return FloatUnderlinePlaceHolderTextField
 */
-(FloatUnderlinePlaceHolderTextField *)inviteCodeTextField {
    if (_inviteCodeTextField == nil) {
        _inviteCodeTextField = [[FloatUnderlinePlaceHolderTextField alloc] initWithPlaceHolder:INVITE_CODE_HOLDER andFrame:CGRectMake(30, 90, self.viewWidth - 60, 50)];
        _inviteCodeTextField.delegate = self;
        _inviteCodeTextField.autocorrectionType = UITextAutocorrectionTypeNo;
        _inviteCodeTextField.keyboardType = UIKeyboardTypeDecimalPad;
        [_inviteCodeTextField addTarget:self action:@selector(textFieldDidChange) forControlEvents:UIControlEventEditingChanged];
    }
    return _inviteCodeTextField;
}

/**
 * Lazily init the email signup button
 * @return UIButton
 */
-(UIButton *)signupButton {
    if (_signupButton == nil) {
        _signupButton = [[UIButton alloc] initWithFrame:CGRectMake(30, self.viewHeight - 100, self.viewWidth - 60, 50)];
        _signupButton.layer.cornerRadius = 25;
        _signupButton.layer.masksToBounds = YES;
        _signupButton.enabled = NO;
        _signupButton.titleLabel.font = [UIFont fontWithName:@"AvenirNext-Medium" size:15];
        
        [_signupButton setTitle:SIGNUP_BUTTON_TITLE forState:UIControlStateNormal];
        
        [_signupButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_signupButton setTitleColor:[UIColor colorWithWhite:1 alpha:0.7] forState:UIControlStateDisabled];
        
        [_signupButton setBackgroundImage:[FontColor imageWithColor:[FontColor greenThemeColor]] forState:UIControlStateNormal];
        [_signupButton setBackgroundImage:[FontColor imageWithColor:[FontColor darkGreenThemeColor]] forState:UIControlStateHighlighted];
        [_signupButton setBackgroundImage:[FontColor imageWithColor:[UIColor colorWithWhite:1 alpha:0.2]] forState:UIControlStateDisabled];
        
        
        [_signupButton addTarget:self action:@selector(signupButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _signupButton;
}

/**
 * Lazily init the terms label
 * @return TTTAttributedLabel
 */
-(TTTAttributedLabel *)termsLabel {
    if (_termsLabel == nil) {
        _termsLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectMake(0, self.viewHeight - 35, self.viewWidth, 25)];
        _termsLabel.textAlignment = NSTextAlignmentCenter;
        _termsLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:11];
        _termsLabel.textAlignment = NSTextAlignmentCenter;
        _termsLabel.textColor = [UIColor whiteColor];
        _termsLabel.lineSpacing = 5;
        _termsLabel.text = TERMS_TEXT;
        _termsLabel.numberOfLines = 0;
        
        _termsLabel.linkAttributes = @{(id)kCTForegroundColorAttributeName: [UIColor whiteColor],
                                       (id)kCTFontAttributeName: [UIFont fontWithName:@"AvenirNext-DemiBold" size:11]};
        NSRange termsRange = [TERMS_TEXT rangeOfString:@"Terms"];
        NSRange privacyRange = [TERMS_TEXT rangeOfString:@"Privacy Policy"];
        
        [_termsLabel addLinkToURL:[NSURL URLWithString:@"action://terms"] withRange:termsRange];
        [_termsLabel addLinkToURL:[NSURL URLWithString:@"action://privacy"] withRange:privacyRange];
        _termsLabel.delegate = self;
    }
    return _termsLabel;
}


#pragma mark - public methods
-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.viewWidth = frame.size.width;
        self.viewHeight = frame.size.height;
        
        if (![Device isIphone4])[self addSubview:[self logoImage]];
        [self addSubview:[self titleLabel]];
        [self addSubview:[self containerView]];
        [self.containerView addSubview:[self emailTextField]];
        [self.containerView addSubview:[self passwordTextField]];
        [self.containerView addSubview:[self inviteCodeTextField]];
        [self addSubview:[self termsLabel]];
        [self addSubview:[self signupButton]];
        self.alpha = 0;
        
        self.tap = [[UITapGestureRecognizer alloc]
                                       initWithTarget:self
                                       action:@selector(resignResponder)];
        self.tap.cancelsTouchesInView = NO;
        [self addGestureRecognizer:self.tap];
    }
    return self;
}

/**
 * Show the view. This happen when user click on the login with email
 */
-(void)showView {
    self.transform = CGAffineTransformIdentity;
}

/**
 * Enable the login button
 */
-(void)enableSignupButton {
    self.signupButton.enabled = YES;
    
}

/**
 * When the keyboard is show, we move the content of the signup button up if needed
 * @param CGFloat
 */
-(void)showKeyboard:(CGFloat)keyboardHeight {
    self.tap.cancelsTouchesInView = YES;
    self.signupButton.frame = CGRectMake(0, self.viewHeight - 100, self.viewWidth, 50);
    if ([Device isIphone4]) self.signupButton.transform = CGAffineTransformMakeTranslation(0, -75);
    if ([Device isIphone5]) self.signupButton.transform = CGAffineTransformMakeTranslation(0, -5);
    self.signupButton.layer.cornerRadius = 0;
}

/**
 * When the keyboard is hidden, we return the button back to usual position
 */
-(void)hideKeyboard {
    self.tap.cancelsTouchesInView = NO;
    self.signupButton.transform = CGAffineTransformIdentity;
    self.signupButton.layer.cornerRadius = 25;
    self.signupButton.frame = CGRectMake(30, self.viewHeight - 100, self.viewWidth - 60, 50);
}

-(void)setEmail:(NSString *)email {
    [self.emailTextField setText:email];
}

-(void)setCode:(NSString *)code {
    [self.inviteCodeTextField setText:code];
}

#pragma mark - ui action
/**
 * Handle the behavior when user click on the email-login button
 */
-(void)signupButtonClick {
    self.signupButton.enabled = NO;
    [self.signupViewDelegate signUpWithEmail:[self.emailTextField.text lowercaseString] password:self.passwordTextField.text andCode:self.inviteCodeTextField.text];
}

/**
 * TTTAttributesLabel delegate
 * Handle the behavior when user click on the login label
 */
-(void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url {
    NSString *urlString = [url absoluteString];
    if ([urlString isEqualToString:@"action://terms"]) [self.signupViewDelegate goToTermsOfService];
    else if ([urlString isEqualToString:@"action://privacy"]) [self.signupViewDelegate goToPrivacyPolicy];
    else [self.signupViewDelegate goToRequestCodeScreen];
}

#pragma mark - uitextfield delegate
/**
 * Custom delegate for FloatPlaceholderTextField
 * Call this function when the text field is editted
 */
-(void)textFieldDidChange {
    self.signupButton.enabled = ([EmailValidation validateEmail:self.emailTextField.text] && self.passwordTextField.text.length > 0 && self.inviteCodeTextField.text.length > 0);
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

/**
 * Handle the behavior when the user tap outside the email button
 */
-(void)resignResponder {
    if (self.emailTextField.isFirstResponder) [self.emailTextField resignFirstResponder];
    if (self.passwordTextField.isFirstResponder) [self.passwordTextField resignFirstResponder];
    if (self.inviteCodeTextField.isFirstResponder) [self.inviteCodeTextField resignFirstResponder];
}



@end
