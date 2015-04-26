//
//  SignUpAirbnbView.m
//  GuidedCommunication
//
//  Created by ducnm33 on 4/26/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import "SignUpAirbnbView.h"
#import "RoundRedButton.h"
#import "FontColor.h"

static NSString * VIEW_ICON_NAME = @"IconMagpieAirbnb";
static NSString * VIEW_TITLE = @"Import your Airbnb listing";
static NSString * VIEW_DESCRIPTION = @"One click to import everything and save\nall that time to plan your next trip.";
static NSString * BUTTON_LOGIN_TITLE = @"Sounds good, take me to Airbnb";

@interface SignUpAirbnbView ()

@property (nonatomic, strong) UIImageView *viewIcon;
@property (nonatomic, strong) UILabel *viewTitle;
@property (nonatomic, strong) UILabel *viewDescription;
@property (nonatomic, strong) RoundRedButton *loginButton;

@end

@implementation SignUpAirbnbView

#pragma mark - initiation

/**
 * Lazily init the view icon
 * @return view icon
 */
-(UIImageView *)viewIcon {
    if (_viewIcon == nil) {
        float screenWidth = self.frame.size.width;
        float screenHeight = self.frame.size.height;
        _viewIcon = [[UIImageView alloc] initWithFrame:CGRectMake((screenWidth - 204) / 2, (screenHeight - 70) / 2, 204, 70)];
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
        float screenWidth = [[UIScreen mainScreen] bounds].size.width;
        _viewTitle = [[UILabel alloc] initWithFrame:CGRectMake(25, 0, screenWidth - 50, 28)];
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
        float screenWidth = [[UIScreen mainScreen] bounds].size.width;
        _viewDescription = [[UILabel alloc] initWithFrame:CGRectMake(20, 28 + 10, screenWidth - 40, 50)];
        _viewDescription.font = [FontColor AvenirNextRegularWithSize:14];
        _viewDescription.textAlignment = NSTextAlignmentCenter;
        _viewDescription.textColor = [FontColor descriptionColor];
        _viewDescription.text = VIEW_DESCRIPTION;
        _viewDescription.numberOfLines = 0;
    }
    return _viewDescription;
}

/**
 * Lazily init the login button
 * @return RoundBlueButton
 */
- (RoundRedButton *)loginButton
{
    if (!_loginButton) {
        float screenWidth = self.frame.size.width;
        float screenHeight = self.frame.size.height;
        _loginButton = [RoundRedButton createButton];
        _loginButton.frame = CGRectMake((screenWidth - 280) / 2, screenHeight - 50 - 64 - 20, 280, 50);
        [_loginButton setTitle:BUTTON_LOGIN_TITLE forState:UIControlStateNormal];
        [_loginButton addTarget:self action:@selector(loginButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _loginButton;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:[self viewIcon]];
        [self addSubview:[self viewTitle]];
        [self addSubview:[self viewDescription]];
        [self addSubview:[self loginButton]];
    }
    return self;
}

#pragma mark - uiaction

- (void)loginButtonClicked
{
    if ([self.myDelegate respondsToSelector:@selector(signUpAirbnbViewLoginButtonClicked)]) {
        [self.myDelegate signUpAirbnbViewLoginButtonClicked];
    }
}

@end
