//
//  ValuePropFirstView.m
//  Magpie
//
//  Created by minh thao nguyen on 7/29/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import "ValuePropFirstView.h"
#import "Device.h"
#import "TTTAttributedLabel.h"
#import "UIImage+ImageEffects.h"

static NSString * VALUE_PROP = @"Exchange your place and travel the world for free";

static NSString * VALUE_PROP_SCREEN = @"ValuePropFirstScreen";
static NSString * VALUE_PROP_SCREEN_BLUR = @"ValuePropFirstScreenBlur";
static NSString * VALUE_PROP_ICON = @"ValuePropFirstScreenBigIcon";

@interface ValuePropFirstView()
@property (nonatomic, assign) CGFloat viewWidth;
@property (nonatomic, assign) CGFloat viewHeight;
@property (nonatomic, strong) UIImageView *valuePropImageView;
@property (nonatomic, strong) UIImageView *valuePropBlurImageView;
@property (nonatomic, strong) TTTAttributedLabel *valuePropText;
@property (nonatomic, strong) UIImageView *valuePropIcon;

@end

@implementation ValuePropFirstView
#pragma mark - initiation
/**
 * Lazily init the value prop image
 * @return UIImageView
 */
-(UIImageView *)valuePropImageView {
    if (_valuePropImageView == nil) {
        _valuePropImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.viewWidth, self.viewHeight)];
        _valuePropImageView.contentMode = UIViewContentModeScaleAspectFill;
        _valuePropImageView.image = [UIImage imageNamed:VALUE_PROP_SCREEN];
    }
    return _valuePropImageView;
}

/**
 * Lazily init the value prop blur image view
 * @return UIImageView
 */
-(UIImageView *)valuePropBlurImageView {
    if (_valuePropBlurImageView == nil) {
        _valuePropBlurImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.viewWidth, self.viewHeight)];
        _valuePropBlurImageView.contentMode = UIViewContentModeScaleAspectFill;
        UIImage *image = [UIImage imageNamed:VALUE_PROP_SCREEN_BLUR];
        _valuePropBlurImageView.image = [image applyBlur:5 tintColor:[UIColor colorWithWhite:0 alpha:0.15]];
        _valuePropBlurImageView.alpha = 0;
    }
    return _valuePropBlurImageView;
}

/**
 * Lazily init the value prop icon
 * @return UIImageView
 */
-(UIImageView *)valuePropIcon {
    if (_valuePropIcon == nil) {
        _valuePropIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.viewHeight/2 - 150, self.viewWidth, 150)];
        _valuePropIcon.contentMode = UIViewContentModeScaleAspectFit;
        _valuePropIcon.image = [UIImage imageNamed:VALUE_PROP_ICON];
        _valuePropIcon.alpha = 0;
    }
    return _valuePropIcon;
}

/**
 * Lazily init the value prop text
 * @return TTTAttributedLabel
 */
-(TTTAttributedLabel *)valuePropText {
    if (_valuePropText == nil) {
        CGRect frame = CGRectMake(35, self.viewHeight/2 + 20, self.viewWidth - 70, 60);
        if ([Device isIphone4] || [Device isIphone5]) frame = CGRectMake(20, self.viewHeight/2 + 20, self.viewWidth - 40, 60);
        _valuePropText = [[TTTAttributedLabel alloc] initWithFrame:frame];
        _valuePropText.lineSpacing = 10;
        _valuePropText.font = [UIFont fontWithName:@"AvenirNext-Medium" size:18];
        _valuePropText.textColor = [UIColor whiteColor];
        _valuePropText.textAlignment = NSTextAlignmentCenter;
        _valuePropText.numberOfLines = 0;
        _valuePropText.shadowColor = [UIColor colorWithWhite:0 alpha:0.3];
        _valuePropText.shadowRadius = 1;
        _valuePropText.shadowOffset = CGSizeMake(0, 1);
        _valuePropText.text = VALUE_PROP;
        _valuePropText.alpha = 0;
    }
    return _valuePropText;
}

#pragma mark - public method
-(id)init {
    self.viewWidth = [UIScreen mainScreen].bounds.size.width;
    self.viewHeight = [UIScreen mainScreen].bounds.size.height;
    self = [super initWithFrame:CGRectMake(0, 0, self.viewWidth, self.viewHeight)];
    if (self) {
        [self addSubview:[self valuePropImageView]];
        [self addSubview:[self valuePropBlurImageView]];
        [self addSubview:[self valuePropText]];
        [self addSubview:[self valuePropIcon]];
    }
    return self;
}

/**
 * Show the view in animation
 */
-(void)showView {
    [UIView animateWithDuration:1 animations:^{
        self.valuePropBlurImageView.alpha = 1;
        self.valuePropIcon.alpha = 1;
    } completion:^(BOOL finished) {
        if (finished) {
            [UIView animateWithDuration:0.5 animations:^{
                self.valuePropText.alpha = 1;
            }];
        }
    }];
}

/**
 * Hide the view in animation
 */
-(void)hideView {
    self.valuePropText.alpha = 0;
    self.valuePropIcon.alpha = 0;
    self.valuePropBlurImageView.alpha = 0;
}

@end
