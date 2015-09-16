//
//  RequestInvitationCodeView.m
//  Magpie
//
//  Created by minh thao nguyen on 8/9/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import "RequestInvitationCodeView.h"
#import "FloatUnderlinePlaceHolderTextField.h"
#import "Device.h"
#import "FontColor.h"
#import "TTTAttributedLabel.h"
#import "EmailValidation.h"
#import "WhyInvitationPopup.h"

static NSString * const MAGPIE_ICON_IMG_NAME = @"MagpieIcon";
static NSString * const FIRST_TITLE_TEXT = @"Magpie is a trusted community of travelers like you. Please connect to your Facebook to help us learn more about you";
static NSString * const SECOND_TITLE_TEXT = @"Please enter your email address so we can send an invitation code";
static NSString * const SECOND_TITLE_TEXT_EMAIL_PROVIDED = @"Please verify your email address so we can send an invitation code";


static NSString * FACEBOOK_AUTHENTICATION_TEXT = @"Facebook";
static NSString * EMAIL_PLACEHOLDER = @"Email";

static NSString * FACEBOOK_ASSURANCE_TEXT = @"We will not post on your timeline";

static NSString * REQUEST_INVITATION_BUTTON_TEXT = @"Submit";
static NSString * WHY_INVITATION_BUTTON_TEXT = @"Why invitation only?";

@interface RequestInvitationCodeView()
@property (nonatomic, assign) CGFloat viewWidth;
@property (nonatomic, assign) CGFloat viewHeight;

@property (nonatomic, strong) UIImageView *logoImage;
@property (nonatomic, strong) WhyInvitationPopup *whyInvitationPopup;

@property (nonatomic, strong) UIView *firstContainerView;
@property (nonatomic, strong) UILabel *firstTitleLabel;
@property (nonatomic, strong) UIButton *facebookAuthenticationButton;
@property (nonatomic, strong) UILabel *facebookAskLabel;

@property (nonatomic, strong) UIView *secondContainerView;
@property (nonatomic, strong) UILabel *secondTitleLabel;
@property (nonatomic, strong) FloatUnderlinePlaceHolderTextField * emailTextField;
@property (nonatomic, strong) UIButton *requestInvitationButton;

@property (nonatomic, strong) UIButton *whyInvitationButton;
@end

@implementation RequestInvitationCodeView
#pragma mark - initiation
/**
 * Lazily init the logo image
 * @return UIImage
 */
-(UIImageView *)logoImage {
    if (_logoImage == nil) {
        CGRect frame = CGRectMake(0, 70, self.viewWidth, 80);
        if ([Device isIphone6]) frame = CGRectMake(0, 60, self.viewWidth, 70);
        else if ([Device isIphone5]) frame = CGRectMake(0, 50, self.viewWidth, 70);
        else if ([Device isIphone4]) frame = CGRectMake(0, 30, self.viewWidth, 60);
        
        _logoImage = [[UIImageView alloc] initWithFrame:frame];
        _logoImage.contentMode = UIViewContentModeScaleAspectFit;
        _logoImage.image = [UIImage imageNamed:MAGPIE_ICON_IMG_NAME];
    }
    return _logoImage;
}

/**
 * Lazily init the first container view
 * @return UIView
 */
-(UIView *)firstContainerView {
    if (_firstContainerView == nil) {
        _firstContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.logoImage.frame) + 25, self.viewWidth, self.viewHeight - CGRectGetMaxY(self.logoImage.frame) - 75)];
    }
    return _firstContainerView;
}

/**
 * Lazily init the title label
 * @return UILabel
 */
-(UILabel *)firstTitleLabel {
    if (_firstTitleLabel == nil) {
        _firstTitleLabel = [[UILabel alloc] init];
        _firstTitleLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:17];
        _firstTitleLabel.textAlignment = NSTextAlignmentCenter;
        _firstTitleLabel.textColor = [UIColor whiteColor];
        _firstTitleLabel.text = FIRST_TITLE_TEXT;
        _firstTitleLabel.numberOfLines = 0;
        CGFloat height = [_firstTitleLabel sizeThatFits:CGSizeMake(self.viewWidth - 40, FLT_MAX)].height;
        
        _firstTitleLabel.frame = CGRectMake(20, 0, self.viewWidth - 40, height);
    }
    return _firstTitleLabel;
}


/**
 * Lazily init the facebook's authentication button
 * @return UIButton
 */
-(UIButton *)facebookAuthenticationButton {
    if (_facebookAuthenticationButton == nil) {
        _facebookAuthenticationButton = [[UIButton alloc] initWithFrame: CGRectMake(30, CGRectGetMaxY(self.firstTitleLabel.frame) + 50, self.viewWidth - 60, 50)];
        _facebookAuthenticationButton.titleLabel.font = [UIFont fontWithName:@"AvenirNext-Medium" size:15];
        _facebookAuthenticationButton.layer.cornerRadius = 25;
        _facebookAuthenticationButton.layer.masksToBounds = YES;
        
        [_facebookAuthenticationButton setTitle:FACEBOOK_AUTHENTICATION_TEXT forState:UIControlStateNormal];
        
        [_facebookAuthenticationButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_facebookAuthenticationButton setTitleColor:[UIColor colorWithWhite:1 alpha:0.7] forState:UIControlStateDisabled];
        
        [_facebookAuthenticationButton setBackgroundImage:[FontColor imageWithColor:[FontColor fbColor]] forState:UIControlStateNormal];
        [_facebookAuthenticationButton setBackgroundImage:[FontColor imageWithColor:[FontColor darkFbColor]] forState:UIControlStateHighlighted];
        [_facebookAuthenticationButton setBackgroundImage:[FontColor imageWithColor:[UIColor colorWithWhite:1 alpha:0.2]] forState:UIControlStateDisabled];
        
        [_facebookAuthenticationButton addTarget:self action:@selector(fbLoginButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _facebookAuthenticationButton;
}

/**
 * Lazily init facebook assurance label
 * @return UILabel
 */
-(UILabel *)facebookAskLabel {
    if (_facebookAskLabel == nil) {
        _facebookAskLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.facebookAuthenticationButton.frame) + 15, self.viewWidth, 20)];
        _facebookAskLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:13];
        _facebookAskLabel.textColor = [UIColor whiteColor];
        _facebookAskLabel.textAlignment = NSTextAlignmentCenter;
        _facebookAskLabel.text = FACEBOOK_ASSURANCE_TEXT;
    }
    return _facebookAskLabel;
}

/**
 * Lazily init the second container
 * @return UIView
 */
-(UIView *)secondContainerView {
    if (_secondContainerView == nil) {
        _secondContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.logoImage.frame) + 25, self.viewWidth, self.viewHeight - CGRectGetMaxY(self.logoImage.frame) - 75)];
        _secondContainerView.transform = CGAffineTransformMakeTranslation(self.viewWidth, 0);
    }
    return _secondContainerView;
}

/**
 * Lazily init the second title label
 * @return UILabel
 */
-(UILabel *)secondTitleLabel {
    if (_secondTitleLabel == nil) {
        _secondTitleLabel = [[UILabel alloc] init];
        _secondTitleLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:18];
        _secondTitleLabel.textAlignment = NSTextAlignmentCenter;
        _secondTitleLabel.textColor = [UIColor whiteColor];
        _secondTitleLabel.text = SECOND_TITLE_TEXT;
        _secondTitleLabel.numberOfLines = 0;
        
        CGFloat height = [_secondTitleLabel sizeThatFits:CGSizeMake(self.viewWidth - 40, FLT_MAX)].height;
        _secondTitleLabel.frame = CGRectMake(20, 0, self.viewWidth - 40, height);
    }
    return _secondTitleLabel;
}

/**
 * Lazily init the email text field
 * @return FloatUnderlinePlaceHolderTextField
 */
-(FloatUnderlinePlaceHolderTextField *)emailTextField {
    if (_emailTextField == nil) {
        _emailTextField = [[FloatUnderlinePlaceHolderTextField alloc] initWithPlaceHolder:EMAIL_PLACEHOLDER andFrame:CGRectMake(30, CGRectGetMaxY(self.secondTitleLabel.frame) + 50, self.viewWidth - 60, 50)];
        _emailTextField.delegate = self;
        _emailTextField.autocorrectionType = UITextAutocorrectionTypeNo;
        _emailTextField.keyboardType = UIKeyboardTypeEmailAddress;
        [_emailTextField addTarget:self action:@selector(textFieldDidChange) forControlEvents:UIControlEventEditingChanged];
    }
    return _emailTextField;
}

/**
 * Lazily init the request invitation button
 * @return UIButton
 */
-(UIButton *)requestInvitationButton {
    if (_requestInvitationButton == nil) {
        _requestInvitationButton = [[UIButton alloc] initWithFrame:CGRectMake(30, self.secondContainerView.frame.size.height - 50, self.viewWidth - 60, 50)];
        _requestInvitationButton.layer.cornerRadius = 25;
        _requestInvitationButton.layer.masksToBounds = YES;
        _requestInvitationButton.enabled = NO;
        _requestInvitationButton.titleLabel.font = [UIFont fontWithName:@"AvenirNext-Medium" size:15];
        
        [_requestInvitationButton setTitle:REQUEST_INVITATION_BUTTON_TEXT forState:UIControlStateNormal];
        
        [_requestInvitationButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_requestInvitationButton setTitleColor:[UIColor colorWithWhite:1 alpha:0.7] forState:UIControlStateDisabled];
        
        [_requestInvitationButton setBackgroundImage:[FontColor imageWithColor:[FontColor greenThemeColor]] forState:UIControlStateNormal];
        [_requestInvitationButton setBackgroundImage:[FontColor imageWithColor:[FontColor darkGreenThemeColor]] forState:UIControlStateHighlighted];
        [_requestInvitationButton setBackgroundImage:[FontColor imageWithColor:[UIColor colorWithWhite:1 alpha:0.2]] forState:UIControlStateDisabled];
        
        [_requestInvitationButton addTarget:self action:@selector(requestInvitationButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _requestInvitationButton;
}

/**
 * Lazily init the why invitation button
 * @return UIButton
 */
-(UIButton *)whyInvitationButton {
    if (_whyInvitationButton == nil) {
        _whyInvitationButton = [[UIButton alloc] initWithFrame:CGRectMake((self.viewWidth - 150)/2, self.viewHeight - 40, 150, 30)];
        _whyInvitationButton.titleLabel.font = [UIFont fontWithName:@"AvenirNext-Medium" size:12];
        [_whyInvitationButton setTitle:WHY_INVITATION_BUTTON_TEXT forState:UIControlStateNormal];
        [_whyInvitationButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_whyInvitationButton setTitleColor:[FontColor themeColor] forState:UIControlStateHighlighted];
        
        [_whyInvitationButton addTarget:self action:@selector(whyInvitationButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _whyInvitationButton;
}

#pragma mark - public methods
-(id)init {
    self.viewWidth = [UIScreen mainScreen].bounds.size.width;
    self.viewHeight = [UIScreen mainScreen].bounds.size.height;
    self = [super initWithFrame:CGRectMake(0, 0, self.viewWidth, self.viewHeight)];
    if (self) {
        self.clipsToBounds = YES;
        
        [self addSubview:[self logoImage]];
        [self addSubview:[self whyInvitationButton]];
        
        [self addSubview:[self firstContainerView]];
        [self.firstContainerView addSubview:[self firstTitleLabel]];
        [self.firstContainerView addSubview:[self facebookAuthenticationButton]];
        [self.firstContainerView addSubview:[self facebookAskLabel]];
        
        [self addSubview:[self secondContainerView]];
        [self.secondContainerView addSubview:[self secondTitleLabel]];
        [self.secondContainerView addSubview:[self emailTextField]];
        [self.secondContainerView addSubview:[self requestInvitationButton]];
        
        self.alpha = 0;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                       initWithTarget:self
                                       action:@selector(resignResponder)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

/**
 * Set the email resulted from facebook authentication
 * @param email
 */
-(void)setEmail:(NSString *)email {
    if (email.length > 0) {
        self.secondTitleLabel.text = SECOND_TITLE_TEXT_EMAIL_PROVIDED;
        self.emailTextField.text = email;
        [self enableInvitationCodeRequestButton];
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        self.secondContainerView.transform = CGAffineTransformIdentity;
        self.firstContainerView.alpha = 0;
    } completion:^(BOOL finished) {
        [self.firstContainerView removeFromSuperview];
    }];
}

/**
 * Enable the invitation code request button
 */
-(void)enableInvitationCodeRequestButton {
    self.requestInvitationButton.enabled = YES;
}

/**
 * When the keyboard is show, we move the content of the signup button up if needed
 * @param CGFloat
 */
-(void)showKeyboard:(CGFloat)keyboardHeight {
    self.whyInvitationButton.alpha = 0;
    self.requestInvitationButton.frame = CGRectMake(0, self.secondContainerView.frame.size.height - 50, self.viewWidth, 50);
    self.requestInvitationButton.layer.cornerRadius = 0;
}

/**
 * When the keyboard is hidden, we return the button back to usual position
 */
-(void)hideKeyboard {
    self.whyInvitationButton.alpha = 1;
    self.requestInvitationButton.transform = CGAffineTransformIdentity;
    self.requestInvitationButton.layer.cornerRadius = 25;
    self.requestInvitationButton.frame = CGRectMake(30, self.secondContainerView.frame.size.height - 50, self.viewWidth - 60, 50);
}

#pragma mark - UIInteraction
/**
 * Handle behavior when user click on authenticate using facebook button
 */
-(void)fbLoginButtonClick {
    [self.delegate authenticateWithFacebook];
}

/**
 * Handle behavior when user click on the request invitation code button
 */
-(void)requestInvitationButtonClick {
    [self resignResponder];
    [self.delegate requestCodeWithEmail:[self.emailTextField.text lowercaseString]];
}

/**
 * Handle behavior when user click on why invitation code button
 */
-(void)whyInvitationButtonClick {
    if (self.whyInvitationPopup == nil) self.whyInvitationPopup = [[WhyInvitationPopup alloc] init];
    [self.whyInvitationPopup showInParent];
}

/**
 * Custom delegate for TextField
 * Call this function when the text field is editted
 */
-(void)textFieldDidChange {
    self.requestInvitationButton.enabled = [EmailValidation validateEmail:self.emailTextField.text];
}

/**
 * Dismiss keyboard and resign first responder
 */
-(void)resignResponder {
    if ([self.emailTextField isFirstResponder]) [self.emailTextField resignFirstResponder];
}

@end
