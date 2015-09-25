//
//  WhyInvitationPopup.m
//  Magpie
//
//  Created by minh thao nguyen on 7/26/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import "WhyInvitationPopup.h"
#import "TTTAttributedLabel.h"
#import "FontColor.h"

static NSString * const TITLE_LABEL_TEXT = @"WHY INVITATION ONLY?";
static NSString * const DESCRIPTION_LABEL_TEXT = @"Our community is built on trust and safety, so new members are selectively added through careful screening";
static NSString * const CTA_BUTTON_TEXT = @"Got It!";

@interface WhyInvitationPopup()
@property (nonatomic, assign) CGFloat viewWidth;
@property (nonatomic, assign) CGFloat viewHeight;

@property (nonatomic, strong) UIView *backgroundView;

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) TTTAttributedLabel *descriptionLabel;
@property (nonatomic, strong) UIButton *ctaButton;

@end

@implementation WhyInvitationPopup
#pragma mark - initiation
/**
 * Lazily init the background view
 * @return UIView
 */
-(UIView *)backgroundView {
    if (_backgroundView == nil) {
        _backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.viewWidth, self.viewHeight)];
        _backgroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
        [_backgroundView addGestureRecognizer:tap];
    }
    return _backgroundView;
}

/**
 * Lazily init the container view
 * @return UIView
 */
-(UIView *)containerView {
    if (_containerView == nil) {
        CGFloat height = [self descriptionLabel].frame.size.height + 150;
        _containerView = [[UIView alloc] initWithFrame:CGRectMake(20, (self.viewHeight - height)/2, self.viewWidth - 40, height)];
        _containerView.backgroundColor = [UIColor whiteColor];
        _containerView.layer.cornerRadius = 5;
        _containerView.layer.masksToBounds = YES;
        _containerView.clipsToBounds = YES;
    }
    return _containerView;
}

/**
 * Lazily init the title label
 * @return UILabel
 */
-(UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel =  [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.viewWidth - 40, 75)];
        _titleLabel.textColor = [FontColor greenThemeColor];
        _titleLabel.font = [UIFont fontWithName:@"AvenirNext-DemiBold" size:15];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.text = TITLE_LABEL_TEXT;
    }
    return _titleLabel;
}

/**
 * Lazily init the description label
 * @return TTTAttributedLabel
 */
-(TTTAttributedLabel *)descriptionLabel {
    if (_descriptionLabel == nil) {
        _descriptionLabel = [[TTTAttributedLabel alloc] init];
        _descriptionLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:15];
        _descriptionLabel.textColor = [FontColor titleColor];
        _descriptionLabel.textAlignment = NSTextAlignmentCenter;
        _descriptionLabel.lineSpacing = 8;
        _descriptionLabel.numberOfLines = 0;
        _descriptionLabel.text = DESCRIPTION_LABEL_TEXT;
        CGFloat descriptionLabelHeight = [_descriptionLabel sizeThatFits:CGSizeMake(self.viewWidth - 90, FLT_MAX)].height;
        _descriptionLabel.frame = CGRectMake(25, 75, self.viewWidth - 90, descriptionLabelHeight);
    }
    return _descriptionLabel;
}

/**
 * Lazily init the CTA Button
 * @return UIButton
 */
-(UIButton *)ctaButton {
    if (_ctaButton == nil) {
        _ctaButton = [[UIButton alloc] initWithFrame:CGRectMake(0, self.containerView.frame.size.height - 50, self.viewWidth - 40, 50)];
        [_ctaButton setBackgroundImage:[FontColor imageWithColor:[FontColor greenThemeColor]] forState:UIControlStateNormal];
        [_ctaButton setBackgroundImage:[FontColor imageWithColor:[FontColor darkGreenThemeColor]] forState:UIControlStateHighlighted];
        [_ctaButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _ctaButton.titleLabel.font = [UIFont fontWithName:@"AvenirNext-DemiBold" size:15];
        [_ctaButton setTitle:CTA_BUTTON_TEXT forState:UIControlStateNormal];
        [_ctaButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    }
    return _ctaButton;
}

#pragma mark - public method
-(id)init {
    self.viewWidth = [UIScreen mainScreen].bounds.size.width;
    self.viewHeight = [UIScreen mainScreen].bounds.size.height;
    self = [super initWithFrame:CGRectMake(0, 0, self.viewWidth, self.viewHeight)];
    if (self) {
        self.alpha = 0;
        [self addSubview:[self backgroundView]];
        [self addSubview:[self containerView]];
        [self.containerView addSubview:[self titleLabel]];
        [self.containerView addSubview:[self descriptionLabel]];
        [self.containerView addSubview:[self ctaButton]];
    }
    return self;
}

/**
 * Show the popup on top of a given parent view
 */
-(void)showInParent {
    UIView *parentView = [UIApplication sharedApplication].keyWindow.subviews.lastObject;
    [parentView addSubview:self];
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 1;
    }];
}

/**
 * Dismiss the popup, cleanup the content in case user click to show again
 */
-(void)dismiss {
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
