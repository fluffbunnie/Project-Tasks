//
//  MenuHeaderPreLoggedIn.m
//  Magpie
//
//  Created by minh thao nguyen on 4/23/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import "MenuHeaderPreLoggedIn.h"
#import "TTTAttributedLabel.h"
#import "FontColor.h"
#import "RoundButton.h"

static NSString * SIGN_UP_LABEL_TEXT = @"Sign up now";
static NSString * SIGN_IN_LABEL_TEXT = @"Already have an account? Log In";

@interface MenuHeaderPreLoggedIn()

@property (nonatomic, strong) RoundButton *signupButton;
@property (nonatomic, strong) TTTAttributedLabel *loginLabel;

@end

@implementation MenuHeaderPreLoggedIn

#pragma mark - initiation
/**
 * Lazily init the signup button
 * @return UIButton
 */
-(RoundButton *)signupButton {
    if (_signupButton == nil) {
        _signupButton = [[RoundButton alloc] initWithFrame:CGRectMake(35, 94, 180, 50)];
        [_signupButton setTitle:SIGN_UP_LABEL_TEXT forState:UIControlStateNormal];
        [_signupButton addTarget:self action:@selector(signupButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _signupButton;
}

/**
 * Lazily init the login label
 * @return TTTAttributedLabel
 */
-(TTTAttributedLabel *)loginLabel {
    if (_loginLabel == nil) {
        _loginLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectMake(0, 164, 250, 20)];
        _loginLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:14];
        _loginLabel.textColor = [FontColor descriptionColor];
        _loginLabel.textAlignment = NSTextAlignmentCenter;
        _loginLabel.numberOfLines = 0;
        _loginLabel.text = SIGN_IN_LABEL_TEXT;
        _loginLabel.delegate = self;
        _loginLabel.linkAttributes = @{ (id)kCTForegroundColorAttributeName: [FontColor descriptionColor],
                                        (id)kCTFontAttributeName: [UIFont fontWithName:@"AvenirNext-DemiBold" size:14]};
        NSRange range = [SIGN_IN_LABEL_TEXT rangeOfString:@"Log In"];
        [_loginLabel addLinkToURL:[NSURL URLWithString:@"action://log-in"] withRange:range];
    }
    return _loginLabel;
}

#pragma mark - public init
-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:[self signupButton]];
        [self addSubview:[self loginLabel]];
    }
    return self;
}

#pragma mark - touch listener
/**
 * Handle the action when user tap on the signup button
 */
-(void)signupButtonClicked {
    [self.menuHeaderDelegate signupButtonPressed];
}

/**
 * TTTAttributesLabel delegate
 * Handle the behavior when user click on the login label
 */
-(void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url {
    [self.menuHeaderDelegate loginButtonPressed];
}

@end
