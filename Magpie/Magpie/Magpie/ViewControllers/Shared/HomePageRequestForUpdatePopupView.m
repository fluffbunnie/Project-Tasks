//
//  HomePageRequestForUpdatePopupView.m
//  Magpie
//
//  Created by minh thao nguyen on 7/29/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import "HomePageRequestForUpdatePopupView.h"
#import "TTTAttributedLabel.h"
#import "FontColor.h"

static NSString * const TITLE_LABEL_TEXT = @"NEW UPDATE AVAILABLE!";
static NSString * const DESCRIPTION_LABEL_TEXT = @"New version of Magpie is available. Please update to the latest version.";
static NSString * const CTA_BUTTON_TEXT = @"Update Now";
static NSString * const CLOSE_BUTTON_TEXT = @"I'll update it later";

@interface HomePageRequestForUpdatePopupView()
@property (nonatomic, assign) CGFloat viewWidth;
@property (nonatomic, assign) CGFloat viewHeight;

@property (nonatomic, strong) UIView *parentView;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) TTTAttributedLabel *descriptionLabel;
@property (nonatomic, strong) UIButton *ctaButton;

@property (nonatomic, strong) UIButton *closeButton;
@end

@implementation HomePageRequestForUpdatePopupView
#pragma mark - initiation
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
        [_ctaButton addTarget:self action:@selector(goToDownloadPage) forControlEvents:UIControlEventTouchUpInside];
    }
    return _ctaButton;
}

/**
 * Lazily init the close button
 * @return UIButton
 */
-(UIButton *)closeButton {
    if (_closeButton == nil) {
        _closeButton = [[UIButton alloc] initWithFrame:CGRectMake((self.viewWidth - 140) / 2, self.viewHeight - 50, 140, 40)];
        _closeButton.titleLabel.font = [UIFont fontWithName:@"AvenirNext-Medium" size:14];
        [_closeButton setTitleColor:[FontColor subTitleColor] forState:UIControlStateNormal];
        [_closeButton setTitleColor:[FontColor themeColor] forState:UIControlStateHighlighted];
        [_closeButton setTitle:CLOSE_BUTTON_TEXT forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}

#pragma mark - public method
-(id)init {
    self.viewWidth = [UIScreen mainScreen].bounds.size.width;
    self.viewHeight = [UIScreen mainScreen].bounds.size.height;
    self = [super initWithFrame:CGRectMake(0, 0, self.viewWidth, self.viewHeight)];
    if (self) {
        self.alpha = 0;
        self.backgroundColor = [UIColor colorWithRed:118/255.0 green:197/255.0 blue:202/255.0 alpha:0.9];
        [self addSubview:[self containerView]];
        [self.containerView addSubview:[self titleLabel]];
        [self.containerView addSubview:[self descriptionLabel]];
        [self.containerView addSubview:[self ctaButton]];
        
        UITapGestureRecognizer *tapInside = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapInside)];
        UITapGestureRecognizer *tapOutside = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
        
        [self.containerView addGestureRecognizer:tapInside];
        [self addGestureRecognizer:tapOutside];
        
        
    }
    return self;
}

/**
 * Show the popup on top of a given parent view
 */
-(void)showInParent {
    if (!self.parentView) self.parentView = [UIApplication sharedApplication].keyWindow.subviews.lastObject;
    [self.parentView addSubview:self];
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

/**
 * Tap inside the contaier frame
 */
-(void)tapInside {
    //DO nothing
}

/**
 * Go the the download page
 */
-(void)goToDownloadPage {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.getmagpie.com/beta"]];
    [self dismiss];
}



@end
