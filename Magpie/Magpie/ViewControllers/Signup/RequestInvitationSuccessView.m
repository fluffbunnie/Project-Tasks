//
//  RequestInvitationSuccessView.m
//  Magpie
//
//  Created by minh thao nguyen on 8/10/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import "RequestInvitationSuccessView.h"
#import "FontColor.h"
#import "Device.h"
#import "TTTAttributedLabel.h"

static NSString * const BIG_CHECK_ICON = @"BigCheckIcon";
static NSString * const CONGRAT_LABEL_TEXT = @"Congratulations!";
static NSString * const DESCRIPTION_TEXT = @"You've requested an invitation code. Magpie staff will review your new profile and send you your invitation code within 24 hours.\n\n\nWe'll notify you at: ";

static NSString * const PUSH_NOTIFICATION_BUTTON_TEXT = @"Notify me when ready";;
static NSString * const CHANGE_EMAIL_ADDRESS_BUTTON_TEXT = @"Change email address";

@interface RequestInvitationSuccessView()
@property (nonatomic, assign) CGFloat viewWidth;
@property (nonatomic, assign) CGFloat viewHeight;

@property (nonatomic, strong) UIImageView *bigCheckImage;
@property (nonatomic, strong) UILabel *congratulateLabel;
@property (nonatomic, strong) TTTAttributedLabel *descriptionLabel;
@property (nonatomic, strong) UILabel *emailLabel;
@property (nonatomic, strong) UIButton *pushNotificationButton;
@property (nonatomic, strong) UIButton *changeEmailButton;
@end

@implementation RequestInvitationSuccessView
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
        _emailLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.descriptionLabel.frame) + 5, self.viewWidth - 40, 25)];
        _emailLabel.textAlignment = NSTextAlignmentCenter;
        _emailLabel.textColor = [UIColor whiteColor];
        _emailLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:17];
    }
    return _emailLabel;
}

/**
 * Lazily init the push notification button
 * @return UIButton
 */
-(UIButton *)pushNotificationButton {
    if (_pushNotificationButton == nil) {
        _pushNotificationButton = [[UIButton alloc] initWithFrame:CGRectMake(30, self.viewHeight - 100, self.viewWidth - 60, 50)];
        _pushNotificationButton.layer.cornerRadius = 25;
        _pushNotificationButton.layer.masksToBounds = YES;
        _pushNotificationButton.titleLabel.font = [UIFont fontWithName:@"AvenirNext-Medium" size:15];
        
        [_pushNotificationButton setTitle:PUSH_NOTIFICATION_BUTTON_TEXT forState:UIControlStateNormal];
        
        [_pushNotificationButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [_pushNotificationButton setBackgroundImage:[FontColor imageWithColor:[FontColor greenThemeColor]] forState:UIControlStateNormal];
        [_pushNotificationButton setBackgroundImage:[FontColor imageWithColor:[FontColor darkGreenThemeColor]] forState:UIControlStateHighlighted];
        
        [_pushNotificationButton addTarget:self action:@selector(pushNotificationButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _pushNotificationButton;
}

/**
 * Lazily init the change email address button
 * @return UIButton
 */
-(UIButton *)changeEmailButton {
    if (_changeEmailButton == nil) {
        _changeEmailButton = [[UIButton alloc] initWithFrame:CGRectMake((self.viewWidth - 150)/2, self.viewHeight - 40, 150, 30)];
        _changeEmailButton.titleLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:14];
        [_changeEmailButton setTitle:CHANGE_EMAIL_ADDRESS_BUTTON_TEXT forState:UIControlStateNormal];
        [_changeEmailButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_changeEmailButton setTitleColor:[FontColor themeColor] forState:UIControlStateHighlighted];
        
        [_changeEmailButton addTarget:self action:@selector(changeEmailButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _changeEmailButton;
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
        //[self addSubview:[self pushNotificationButton]];
        [self addSubview:[self changeEmailButton]];
        self.transform = CGAffineTransformMakeTranslation(self.viewWidth, 0);
    }
    return self;
}

/**
 * Show the view
 */
-(void)showView {
    self.transform = CGAffineTransformIdentity;
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
-(void)pushNotificationButtonClick {
    [self.delegate enablePushNotification];
}

/**
 * Handle the behavior when user click on change email address button
 */
-(void)changeEmailButtonClick {
    [self.delegate changeEmailAddress];
}

@end
