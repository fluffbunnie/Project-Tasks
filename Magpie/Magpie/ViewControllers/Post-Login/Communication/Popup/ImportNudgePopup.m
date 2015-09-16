//
//  ImportNudgePopup.m
//  Magpie
//
//  Created by minh thao nguyen on 5/29/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import "ImportNudgePopup.h"
#import "RoundButton.h"
#import "UnderLineButton.h"
#import "FontColor.h"
#import "TTTAttributedLabel.h"

static NSString * const PLACE_ICON = @"MyPlaceListingRequiredIcon";
static NSString * const TITLE = @"Import or create a place";
static NSString * const DESCRIPTION = @"You must have at least one active place to start requesting free stay.";
static NSString * const BUTTON_TITLE = @"Let's do it!";

@interface ImportNudgePopup()
@property (nonatomic, assign) CGFloat viewWidth;
@property (nonatomic, assign) CGFloat viewHeight;

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIImageView *placeImageIcon;
@property (nonatomic, strong) UILabel *popupTitle;
@property (nonatomic, strong) TTTAttributedLabel *popupDescription;
@property (nonatomic, strong) RoundButton *goToMyPlaceButton;
@property (nonatomic, strong) UnderLineButton *closeButton;
@end

@implementation ImportNudgePopup

#pragma mark - initiation
/**
 * Lazily init the content view
 * @return UIView
 */
-(UIView *)contentView {
    if (_contentView == nil) {
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(20, (self.viewHeight - 370) / 2, self.viewWidth - 40, 355)];
        _contentView.backgroundColor = [UIColor whiteColor];
        _contentView.layer.cornerRadius = 10;
        _contentView.layer.masksToBounds = YES;
        _contentView.clipsToBounds = YES;
    }
    return _contentView;
}

/**
 * Lazily init image place icon
 * @return UIImageView
 */
-(UIImageView *)placeImageIcon {
    if (_placeImageIcon == nil) {
        _placeImageIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 30, self.viewWidth - 40, 60)];
        _placeImageIcon.contentMode = UIViewContentModeScaleAspectFit;
        _placeImageIcon.image = [UIImage imageNamed:PLACE_ICON];
    }
    return _placeImageIcon;
}

/**
 * Lazily init the popup title
 * @return UILabel
 */
-(UILabel *)popupTitle {
    if (_popupTitle == nil) {
        _popupTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 125, self.viewWidth - 40, 30)];
        _popupTitle.textAlignment = NSTextAlignmentCenter;
        _popupTitle.font = [UIFont fontWithName:@"AvenirNext-Medium" size:18];
        _popupTitle.textColor = [FontColor titleColor];
        _popupTitle.text = TITLE;
    }
    return _popupTitle;
}

/**
 * Lazily init the popup description
 * @return UILabel
 */
-(TTTAttributedLabel *)popupDescription {
    if (_popupDescription == nil) {
        _popupDescription = [[TTTAttributedLabel alloc] initWithFrame:CGRectMake(30, 165, self.viewWidth - 100, 115)];
        _popupDescription.textAlignment = NSTextAlignmentCenter;
        _popupDescription.numberOfLines = 0;
        _popupDescription.textColor = [FontColor descriptionColor];
        _popupDescription.font = [UIFont fontWithName:@"AvenirNext-Regular" size:15];
        _popupDescription.lineSpacing = 15;
        _popupDescription.text = DESCRIPTION;
    }
    return _popupDescription;
}

/**
 * Lazily init the go to my place button
 * @return RoundButton
 */
-(RoundButton *)goToMyPlaceButton {
    if (_goToMyPlaceButton == nil) {
        _goToMyPlaceButton = [[RoundButton alloc] initWithFrame:CGRectMake(0, 305, self.viewWidth - 40, 50)];
        _goToMyPlaceButton.layer.cornerRadius = 0;
        [_goToMyPlaceButton setTitle:BUTTON_TITLE forState:UIControlStateNormal];
        [_goToMyPlaceButton addTarget:self action:@selector(goToMyPlaceButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _goToMyPlaceButton;
}

/**
 * Lazily init the close button
 * @return UnderLineButton
 */
-(UnderLineButton *)closeButton {
    if (_closeButton == nil) {
        _closeButton = [[UnderLineButton alloc] initWithFrame:CGRectMake((self.viewWidth - 70)/2, CGRectGetMaxY(self.contentView.frame) + 20, 70, 20)];
        [_closeButton setTitle:@"Go back" forState:UIControlStateNormal];
        [_closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_closeButton setTitleColor:[FontColor descriptionColor] forState:UIControlStateHighlighted];
        _closeButton.titleLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:14];
        
        [_closeButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}


#pragma mark - public method
-(id)init {
    self.viewWidth = [[UIScreen mainScreen] bounds].size.width;
    self.viewHeight = [[UIScreen mainScreen] bounds].size.height;
    self = [super initWithFrame:CGRectMake(0, 0, self.viewWidth, self.viewHeight)];
    if (self) {
        self.alpha = 0;
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
        
        [self addSubview:[self contentView]];
        [self.contentView addSubview:[self placeImageIcon]];
        [self.contentView addSubview:[self popupTitle]];
        [self.contentView addSubview:[self popupDescription]];
        [self.contentView addSubview:[self goToMyPlaceButton]];
        
        [self addSubview:[self closeButton]];
    }
    return self;
}

-(void)showInParent {
    if (self.alpha == 0) {
        UIView *parentView = [UIApplication sharedApplication].keyWindow.subviews.lastObject;
        [parentView addSubview:self];
        [UIView animateWithDuration:0.25 animations:^{
            self.alpha = 1;
        }];
    }
}

-(void)dismiss {
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [self.importNudgeDelegate goBackToPreviousScreen];
    }];
}

#pragma mark - private method & delegate
/**
 * Handle the behavior when the go to my button was click
 */
-(void)goToMyPlaceButtonClick {
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [self.importNudgeDelegate goToMyPlace];
    }];
}

/**
 * go back button click action
 */
-(void)goBack {
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [self.importNudgeDelegate goBackToPreviousScreen];
    }];
}

@end
