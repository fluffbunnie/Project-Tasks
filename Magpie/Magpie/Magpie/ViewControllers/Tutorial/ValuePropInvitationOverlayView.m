//
//  ValuePropInvitationOverlayView.m
//  Magpie
//
//  Created by minh thao nguyen on 8/6/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import "ValuePropInvitationOverlayView.h"
#import "FontColor.h"
#import "WhyInvitationPopup.h"

static NSString * const REQUEST_CODE_BUTTON_TEXT = @"Request an invitation code";
static NSString * const ALREADY_HAVE_CODE_BUTTON_TEXT = @"I already have an invitation code";
static NSString * const WHY_INVITATION_LABEL_TEXT = @"Why invitation only?";

@interface ValuePropInvitationOverlayView()
@property (nonatomic, assign) CGFloat viewWidth;
@property (nonatomic, assign) CGFloat viewHeight;
@property (nonatomic, strong) UIView *backgroundView;

@property (nonatomic, strong) UIView *codeContainerView;
@property (nonatomic, strong) UIButton *requestCodeButton;
@property (nonatomic, strong) UIButton *alreadyHaveCodeButton;
@property (nonatomic, strong) UIButton *whyInvitationLabel;

@property (nonatomic, strong) WhyInvitationPopup *whyInvitationPopup;

@end

@implementation ValuePropInvitationOverlayView
#pragma mark - initiation
/**
 * Lazily init the background view
 * @return UIView
 */
-(UIView *)backgroundView {
    if (_backgroundView == nil) {
        _backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.viewWidth, self.viewHeight)];
        _backgroundView.backgroundColor = [FontColor backgroundOverlayColor];
        _backgroundView.alpha = 0;
    }
    return _backgroundView;
}

/**
 * Lazily init the code container view 
 * @return UIView
 */
-(UIView *)codeContainerView {
    if (_codeContainerView == nil) {
        _codeContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, self.viewHeight - 200, self.viewWidth, 175)];
        _codeContainerView.transform = CGAffineTransformMakeTranslation(0, 200);
        _codeContainerView.alpha = 0;
    }
    return _codeContainerView;
}

/**
 * Lazily init the request code button
 * @return UIButton
 */
-(UIButton *)requestCodeButton {
    if (_requestCodeButton == nil) {
        _requestCodeButton = [[UIButton alloc] initWithFrame:CGRectMake((self.viewWidth - 250)/2, 0, 250, 50)];
        [_requestCodeButton setBackgroundImage:[FontColor imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        [_requestCodeButton setBackgroundImage:[FontColor imageWithColor:[FontColor greenThemeColor]] forState:UIControlStateHighlighted];
        [_requestCodeButton setTitleColor:[FontColor titleColor] forState:UIControlStateNormal];
        [_requestCodeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [_requestCodeButton setTitle:REQUEST_CODE_BUTTON_TEXT forState:UIControlStateNormal];
        _requestCodeButton.titleLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:14];
        _requestCodeButton.layer.cornerRadius = 25;
        _requestCodeButton.layer.masksToBounds = YES;
        
        [_requestCodeButton addTarget:self action:@selector(requestCodeButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _requestCodeButton;
}

/**
 * Lazily init the already have code button
 * @return UIButton
 */
-(UIButton *)alreadyHaveCodeButton {
    if (_alreadyHaveCodeButton == nil) {
        _alreadyHaveCodeButton = [[UIButton alloc] initWithFrame:CGRectMake((self.viewWidth - 250)/2, 70, 250, 50)];
        [_alreadyHaveCodeButton setBackgroundImage:[FontColor imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        [_alreadyHaveCodeButton setBackgroundImage:[FontColor imageWithColor:[FontColor greenThemeColor]] forState:UIControlStateHighlighted];
        [_alreadyHaveCodeButton setTitleColor:[FontColor titleColor] forState:UIControlStateNormal];
        [_alreadyHaveCodeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [_alreadyHaveCodeButton setTitle:ALREADY_HAVE_CODE_BUTTON_TEXT forState:UIControlStateNormal];
        _alreadyHaveCodeButton.titleLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:14];
        _alreadyHaveCodeButton.layer.cornerRadius = 25;
        _alreadyHaveCodeButton.layer.masksToBounds = YES;
        
        [_alreadyHaveCodeButton addTarget:self action:@selector(alreadyHaveCodeButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _alreadyHaveCodeButton;
}

/**
 * Lazily init why invitation label
 * @return UIButton
 */
-(UIButton *)whyInvitationLabel {
    if (_whyInvitationLabel == nil) {
        _whyInvitationLabel = [[UIButton alloc] initWithFrame:CGRectMake((self.viewWidth - 140)/2, 140, 140, 35)];
        [_whyInvitationLabel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_whyInvitationLabel setTitleColor:[FontColor themeColor] forState:UIControlStateHighlighted];
        [_whyInvitationLabel setTitle:WHY_INVITATION_LABEL_TEXT forState:UIControlStateNormal];
        _whyInvitationLabel.titleLabel.font = [UIFont fontWithName:@"AvenirNext-DemiBold" size:14];
        
        [_whyInvitationLabel addTarget:self action:@selector(whyInvitationLabelClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _whyInvitationLabel;
}

#pragma mark - public methods
-(id)init {
    self.viewWidth = [UIScreen mainScreen].bounds.size.width;
    self.viewHeight = [UIScreen mainScreen].bounds.size.height;
    self = [super initWithFrame:CGRectMake(0, 0, self.viewWidth, self.viewHeight)];
    if (self) {
        self.hidden = YES;
        [self addSubview:[self backgroundView]];
        [self addSubview:[self codeContainerView]];
        [self.codeContainerView addSubview:[self requestCodeButton]];
        [self.codeContainerView addSubview:[self alreadyHaveCodeButton]];
        [self.codeContainerView addSubview:[self whyInvitationLabel]];
        
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
        [self addGestureRecognizer:tapGestureRecognizer];
    }
    return self;
}

/**
 * Show the view in parent
 */
-(void)showInParent {
    self.hidden = NO;
    [UIView animateWithDuration:0.35 animations:^{
        self.backgroundView.alpha = 0.9;
    } completion:^(BOOL finished) {
        if (finished) {
            [UIView animateWithDuration:0.3 animations:^{
                self.codeContainerView.alpha = 1;
                self.codeContainerView.transform = CGAffineTransformIdentity;
            }];
        }
    }];
}

/**
 * Dismiss in parent
 */
-(void)dismiss {
    [UIView animateWithDuration:0.3 animations:^{
        self.codeContainerView.alpha = 0;
        self.codeContainerView.transform = CGAffineTransformMakeTranslation(0, 200);
    } completion:^(BOOL finished) {
        if (finished) {
            [UIView animateWithDuration:0.35 animations:^{
                self.backgroundView.alpha = 0;
            } completion:^(BOOL finished) {
                if (finished) self.hidden = YES;
            }];
        }
    }];
}

#pragma mark - UI Actions
/**
 * Handle behavior when user click on the request code button
 */
-(void)requestCodeButtonClick {
    [self.delegate goToRequestCode];
}

/**
 * Handle behavior when user click on the already have code button
 */
-(void)alreadyHaveCodeButtonClick {
    [self.delegate goToSignup];
}

/**
 * Handle the behavior when user click on why invitation label
 */
-(void)whyInvitationLabelClick {
    if (self.whyInvitationPopup == nil) self.whyInvitationPopup = [[WhyInvitationPopup alloc] init];
    [self.whyInvitationPopup showInParent];
}


@end
