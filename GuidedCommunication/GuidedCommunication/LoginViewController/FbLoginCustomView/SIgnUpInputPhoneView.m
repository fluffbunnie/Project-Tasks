//
//  SIgnUpInputPhoneView.m
//  GuidedCommunication
//
//  Created by ducnm33 on 4/26/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import "SIgnUpInputPhoneView.h"
#import "FontColor.h"
#import "RectRedButton.h"

static NSString *VIEW_ICON_NAME = @"IconAvatarDefault";
static NSString *VIEW_TITLE = @"Phone Number";
static NSString *VIEW_DESCRIPTION = @"For account verification, please fill in your\nphone number. Carries charges may apply.";
static NSString *TF_COUNTRY_PLACE_HOLDER = @"Pick your country";
static NSString *TF_PHONE_PLACE_HOLDER = @"Enter your phone number";
static NSString *BUTTON_SEND_CODE = @"Send me the code";

@interface SIgnUpInputPhoneView ()

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIImageView *viewIcon;
@property (nonatomic, strong) UILabel *viewTitle;
@property (nonatomic, strong) UILabel *viewDescription;
@property (nonatomic, strong) RectRedButton *sendCodeButton;

@end

@implementation SIgnUpInputPhoneView

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
 * Lazily init the country textfield
 * @return country textfield
 */
-(FloatPlaceholderTexField *)countryFloatTF {
    if (!_countryFloatTF) {
        float screenWidth = self.containerView.frame.size.width;
        _countryFloatTF = [[FloatPlaceholderTexField alloc] initWithPlaceHolder:TF_COUNTRY_PLACE_HOLDER andFrame:CGRectMake((screenWidth - 280) / 2, self.viewDescription.frame.origin.y + self.viewDescription.frame.size.height + 30, 280, 50)];
        _countryFloatTF.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    }
    return _countryFloatTF;
}

/**
 * Lazily init the phone number textfield
 * @return phone number textfield
 */
-(FloatPlaceholderTexField *)phoneNumberFloatTF {
    if (!_phoneNumberFloatTF) {
        float screenWidth = self.containerView.frame.size.width;
        _phoneNumberFloatTF = [[FloatPlaceholderTexField alloc] initWithPlaceHolder:TF_PHONE_PLACE_HOLDER andFrame:CGRectMake((screenWidth - 280) / 2, self.countryFloatTF.frame.origin.y + self.countryFloatTF.frame.size.height + 20, 280, 50)];
        _phoneNumberFloatTF.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    }
    return _phoneNumberFloatTF;
}

/**
 * Lazily init the phone number textfield
 * @return number people textfield
 */
- (RectRedButton *)sendCodeButton
{
    if (!_sendCodeButton) {
        float screenWidth = self.containerView.frame.size.width;
        float screenHeight = self.containerView.frame.size.height;
        _sendCodeButton = [RectRedButton createButton];
        _sendCodeButton.frame = CGRectMake(0, screenHeight - 50, screenWidth, 50);
        [_sendCodeButton.titleLabel setFont:[FontColor AvenirNextMediumWithSize:15]];
        [_sendCodeButton setTitle:BUTTON_SEND_CODE forState:UIControlStateNormal];
        [_sendCodeButton addTarget:self action:@selector(sendCodeButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _sendCodeButton;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:[self viewIcon]];
        [self addSubview:[self containerView]];
        [self.containerView addSubview:[self viewTitle]];
        [self.containerView addSubview:[self viewDescription]];
        [self.containerView addSubview:[self countryFloatTF]];
        [self.containerView addSubview:[self phoneNumberFloatTF]];
        [self.containerView addSubview:[self sendCodeButton]];
    }
    return self;
}

#pragma mark - methods


#pragma mark - uiaction

- (void)sendCodeButtonClicked
{
    if ([self.myDelegate respondsToSelector:@selector(signUpInputPhoneViewSendCodeButtonClicked)]) {
        [self.myDelegate signUpInputPhoneViewSendCodeButtonClicked];
    }
}

@end
