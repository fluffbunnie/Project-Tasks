//
//  SignUpInputCodeView.m
//  GuidedCommunication
//
//  Created by ducnm33 on 4/26/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import "SignUpInputCodeView.h"
#import "FontColor.h"
#import "RectRedButton.h"
#import "UnderLineButton.h"

static NSString * VIEW_ICON_NAME = @"IconAvatarDefault";
static NSString * VIEW_TITLE = @"Verify Code";
static NSString * VIEW_DESCRIPTION = @"We just sent you the code. It should arrive\n in less than one minute.";
static NSString * TF_CODE_PLACE_HOLDER = @"Enter your verify code";
static NSString * BUTTON_VERIFY = @"Verify me";
static NSString * BUTTON_RESEND_CODE = @"Resend code";
static NSString * BUTTON_WRONG_PHONE = @"Wrong phone number?";

@interface SignUpInputCodeView ()

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIImageView *viewIcon;
@property (nonatomic, strong) UILabel *viewTitle;
@property (nonatomic, strong) UILabel *viewDescription;
@property (nonatomic, strong) RectRedButton *verifyButton;
@property (nonatomic, strong) UnderLineButton *resendCodeButton;
@property (nonatomic, strong) UnderLineButton *wrongPhoneButton;

@end

@implementation SignUpInputCodeView

#pragma mark - initiation
/**
 * Lazily init the container view
 * @return containerView
 */
-(UIView *)containerView {
    if (_containerView == nil) {
        float screenWidth = [[UIScreen mainScreen] bounds].size.width;
        float screenHeight = [[UIScreen mainScreen] bounds].size.height;
        CGFloat marginTop = self.viewIcon.frame.origin.y + self.viewIcon.frame.size.height + 10;
        _containerView = [[UIView alloc] initWithFrame:CGRectMake(0, marginTop, screenWidth, screenHeight - marginTop - 64)];
        _containerView.backgroundColor = [UIColor whiteColor];
    }
    return _containerView;
}

/**
 * Lazily init the view icon
 * @return view icon
 */
-(UIImageView *)viewIcon {
    if (_viewIcon == nil) {
        float screenWidth = self.frame.size.width;
        _viewIcon = [[UIImageView alloc] initWithFrame:CGRectMake((screenWidth - 50) / 2, 0, 50, 50)];
        _viewIcon.contentMode = UIViewContentModeScaleAspectFit;
        _viewIcon.image = [UIImage imageNamed:VIEW_ICON_NAME];
    }
    return _viewIcon;
}

/**
 * Lazily init the view title
 * @return view title
 */
-(UILabel *)viewTitle {
    if (_viewTitle == nil) {
        float screenWidth = self.containerView.frame.size.width;
        _viewTitle = [[UILabel alloc] initWithFrame:CGRectMake(25, 50, screenWidth - 50, 28)];
        _viewTitle.font = [FontColor AvenirNextRegularWithSize:20];
        _viewTitle.textAlignment = NSTextAlignmentCenter;
        _viewTitle.textColor = [FontColor titleColor];
        _viewTitle.text = VIEW_TITLE;
    }
    return _viewTitle;
}

/**
 * Lazily init the view description
 * @return view description
 */
-(UILabel *)viewDescription {
    if (_viewDescription == nil) {
        float screenWidth = self.containerView.frame.size.width;
        _viewDescription = [[UILabel alloc] initWithFrame:CGRectMake(20, self.viewTitle.frame.origin.y + self.viewTitle.frame.size.height + 10, screenWidth - 40, 50)];
        _viewDescription.font = [FontColor AvenirNextRegularWithSize:14];
        _viewDescription.textAlignment = NSTextAlignmentCenter;
        _viewDescription.textColor = [FontColor descriptionColor];
        _viewDescription.text = VIEW_DESCRIPTION;
        _viewDescription.numberOfLines = 0;
    }
    return _viewDescription;
}

/**
 * Lazily init the code textfield
 * @return code textfield
 */
-(FloatPlaceholderTexField *)codeFloatTF {
    if (!_codeFloatTF) {
        float screenWidth = self.containerView.frame.size.width;
        _codeFloatTF = [[FloatPlaceholderTexField alloc] initWithPlaceHolder:TF_CODE_PLACE_HOLDER andFrame:CGRectMake((screenWidth - 280) / 2, self.viewDescription.frame.origin.y + self.viewDescription.frame.size.height + 20, 280, 50)];
        _codeFloatTF.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    }
    return _codeFloatTF;
}

/**
 * Lazily init the phone number textfield
 * @return number people textfield
 */
- (RectRedButton *)verifyButton
{
    if (!_verifyButton) {
        float screenWidth = self.containerView.frame.size.width;
        float screenHeight = self.containerView.frame.size.height;
        _verifyButton = [RectRedButton createButton];
        _verifyButton.frame = CGRectMake(0, screenHeight - 50, screenWidth, 50);
        [_verifyButton.titleLabel setFont:[FontColor AvenirNextMediumWithSize:15]];
        [_verifyButton setTitle:BUTTON_VERIFY forState:UIControlStateNormal];
        [_verifyButton addTarget:self action:@selector(verifyButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _verifyButton;
}

/**
 * Lazily init the resend code button
 * @return UnderLineButton
 */
- (UnderLineButton *)resendCodeButton
{
    if (!_resendCodeButton) {
        float screenHeight = self.containerView.frame.size.height;
        _resendCodeButton = [UnderLineButton createButton];
        [_resendCodeButton setTitle:BUTTON_RESEND_CODE forState:UIControlStateNormal];
        _resendCodeButton.frame = CGRectMake(20, screenHeight - 50 - 30, 80, 30);
        _resendCodeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    }
    
    return _resendCodeButton;
}

/**
 * Lazily init the wrong phone number button
 * @return UnderLineButton
 */
- (UnderLineButton *)wrongPhoneButton
{
    if (!_wrongPhoneButton) {
        float screenWidth = self.containerView.frame.size.width;
        float screenHeight = self.containerView.frame.size.height;
        _wrongPhoneButton = [UnderLineButton createButton];
        [_wrongPhoneButton setTitle:BUTTON_WRONG_PHONE forState:UIControlStateNormal];
        _wrongPhoneButton.frame = CGRectMake(screenWidth - 20 - 150, screenHeight - 50 - 30, 150, 30);
        _wrongPhoneButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    }
    
    return _wrongPhoneButton;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:[self viewIcon]];
        [self addSubview:[self containerView]];
        [self.containerView addSubview:[self viewTitle]];
        [self.containerView addSubview:[self viewDescription]];
        [self.containerView addSubview:[self codeFloatTF]];
        [self.containerView addSubview:[self verifyButton]];
        [self.containerView addSubview:[self resendCodeButton]];
        [self.containerView addSubview:[self wrongPhoneButton]];
    }
    return self;
}

#pragma mark - uiaction 

- (void)verifyButtonClicked
{
    if ([self.myDelegate respondsToSelector:@selector(signUpInputCodeViewVerifyButtonClicked)]) {
        [self.myDelegate signUpInputCodeViewVerifyButtonClicked];
    }
}

@end
