//
//  InvitationStatusRequestCodeSentView.m
//  Magpie
//
//  Created by minh thao nguyen on 8/19/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import "InvitationStatusRequestCodeSentView.h"
#import "FontColor.h"
#import "Device.h"
#import "TTTAttributedLabel.h"

static NSString * const BIG_CHECK_ICON = @"BigCheckIcon";
static NSString * const CONGRAT_LABEL_TEXT = @"Congratulations!";
static NSString * const DESCRIPTION_TEXT = @"Your invitation code has been sent to:";

static NSString * const COMPLETE_REGISTRATION_BUTTON_TEXT = @"Complete registration";
static NSString * const RESEND_CODE_BUTTON_TEXT = @"Resend invitation code";

@interface InvitationStatusRequestCodeSentView()
@property (nonatomic, assign) CGFloat viewWidth;
@property (nonatomic, assign) CGFloat viewHeight;

@property (nonatomic, strong) UIImageView *bigCheckImage;
@property (nonatomic, strong) UILabel *congratulateLabel;
@property (nonatomic, strong) TTTAttributedLabel *descriptionLabel;
@property (nonatomic, strong) UILabel *emailLabel;
@property (nonatomic, strong) UIButton *completeRegistrationButton;
@property (nonatomic, strong) UIButton *resendCodeButton;

@end

@implementation InvitationStatusRequestCodeSentView
#pragma mark - initiation
/**
 * Lazily init the logo image
 * @return UIImageView
 */
-(UIImageView *)bigCheckImage {
    if (_bigCheckImage == nil) {
        CGRect frame = CGRectMake(50, 70, self.viewWidth - 100, 80);
        if ([Device isIphone6]) frame = CGRectMake(40, 50, self.viewWidth - 80, 70);
        if ([Device isIphone5]) frame = CGRectMake(30, 40, self.viewWidth - 60, 60);
        if ([Device isIphone4]) frame = CGRectMake(30, 30, self.viewWidth - 60, 60);
        
        _bigCheckImage = [[UIImageView alloc] initWithFrame:frame];
        _bigCheckImage.contentMode = UIViewContentModeScaleAspectFit;
        _bigCheckImage.image = [UIImage imageNamed:BIG_CHECK_ICON];
    }
    return _bigCheckImage;
}

/**
 * Lazily init the title label
 * @return UILabel
 */
-(UILabel *)congratulateLabel {
    if (_congratulateLabel == nil) {
        _congratulateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.bigCheckImage.frame) + 30, self.viewWidth, 25)];
        _congratulateLabel.font = [UIFont fontWithName:@"AvenirNext-Medium" size:18];
        _congratulateLabel.textColor = [UIColor whiteColor];
        _congratulateLabel.textAlignment = NSTextAlignmentCenter;
        _congratulateLabel.numberOfLines = 0;
        _congratulateLabel.text = CONGRAT_LABEL_TEXT;
    }
    return _congratulateLabel;
}

/**
 * Lazily init the description label
 * @return TTTAttributedLabel
 */
-(TTTAttributedLabel *)descriptionLabel {
    if (_descriptionLabel == nil) {
        _descriptionLabel = [[TTTAttributedLabel alloc] init];
        _descriptionLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:17];
        _descriptionLabel.textAlignment = NSTextAlignmentCenter;
        _descriptionLabel.textColor = [UIColor whiteColor];
        _descriptionLabel.numberOfLines = 0;
        _descriptionLabel.text = DESCRIPTION_TEXT;
        
        CGFloat height = [_descriptionLabel sizeThatFits:CGSizeMake(self.viewWidth - 50, FLT_MAX)].height;
        _descriptionLabel.frame = CGRectMake(25, CGRectGetMaxY(self.congratulateLabel.frame) + 30, self.viewWidth - 50, height);
    }
    return _descriptionLabel;
}

/**
 * Lazily init the mail address
 * @return UILabel
 */
-(UILabel *)emailLabel {
    if (_emailLabel == nil) {
        _emailLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.descriptionLabel.frame) + 20, self.viewWidth - 40, 25)];
        _emailLabel.textAlignment = NSTextAlignmentCenter;
        _emailLabel.textColor = [UIColor whiteColor];
        _emailLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:17];
    }
    return _emailLabel;
}

/**
 * Lazily init the complete registration button
 * @return UIButton
 */
-(UIButton *)completeRegistrationButton {
    if (_completeRegistrationButton == nil) {
        _completeRegistrationButton = [[UIButton alloc] initWithFrame:CGRectMake(30, self.viewHeight - 100, self.viewWidth - 60, 50)];
        _completeRegistrationButton.layer.cornerRadius = 25;
        _completeRegistrationButton.layer.masksToBounds = YES;
        _completeRegistrationButton.titleLabel.font = [UIFont fontWithName:@"AvenirNext-Medium" size:15];
        
        [_completeRegistrationButton setTitle:COMPLETE_REGISTRATION_BUTTON_TEXT forState:UIControlStateNormal];
        
        [_completeRegistrationButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [_completeRegistrationButton setBackgroundImage:[FontColor imageWithColor:[FontColor greenThemeColor]] forState:UIControlStateNormal];
        [_completeRegistrationButton setBackgroundImage:[FontColor imageWithColor:[FontColor darkGreenThemeColor]] forState:UIControlStateHighlighted];
        
        [_completeRegistrationButton addTarget:self action:@selector(completeRegistrationButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _completeRegistrationButton;
}

/**
 * Lazily init the resend invite code button
 * @return UIButton
 */
-(UIButton *)resendCodeButton {
    if (_resendCodeButton == nil) {
        _resendCodeButton = [[UIButton alloc] initWithFrame:CGRectMake((self.viewWidth - 150)/2, self.viewHeight - 40, 150, 30)];
        _resendCodeButton.titleLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:14];
        [_resendCodeButton setTitle:RESEND_CODE_BUTTON_TEXT forState:UIControlStateNormal];
        [_resendCodeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_resendCodeButton setTitleColor:[FontColor themeColor] forState:UIControlStateHighlighted];
        
        [_resendCodeButton addTarget:self action:@selector(resendCodeButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _resendCodeButton;
}


#pragma mark - public methods
-(id)init {
    self.viewWidth = [UIScreen mainScreen].bounds.size.width;
    self.viewHeight = [UIScreen mainScreen].bounds.size.height;
    self = [super initWithFrame:CGRectMake(0, 0, self.viewWidth, self.viewHeight)];
    if (self) {
        [self addSubview:[self bigCheckImage]];
        [self addSubview:[self congratulateLabel]];
        [self addSubview:[self descriptionLabel]];
        [self addSubview:[self emailLabel]];
        [self addSubview:[self completeRegistrationButton]];
        [self addSubview:[self resendCodeButton]];
    }
    return self;
}

/*
 * Set the email text
 * @param NSString
 */
-(void)setEmailAddress:(NSString *)emailAddress {
    self.emailLabel.text = emailAddress;
}

/**
 * Handle the behavior when user click on the check status button
 */
-(void)completeRegistrationButtonClick {
    [self.delegate completeRegistration];
}

/**
 * Handle the behavior when user click on change email address button
 */
-(void)resendCodeButtonClick {
    [self.delegate resendEmail];
}

@end
