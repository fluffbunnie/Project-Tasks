//
//  ValuePropThirdView.m
//  Magpie
//
//  Created by minh thao nguyen on 7/29/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import "HowItWorksSeventhView.h"
#import "Device.h"
#import "TTTAttributedLabel.h"
#import "FontColor.h"

static NSString * VALUE_LABEL_TEXT_4 = @"Meanwhile, Kat received Dani’s request";

static NSString * VALUE_BACKGROUND_SCREEN_2 = @"Background_Screen_2";
static NSString * VALUE_DANIREQUEST_IMAGE = @"DaniRequestToKat";
static NSString * VALUE_KAT_AVATAR_IMAGE = @"Kat_Avatar_221";

@interface HowItWorksSeventhView()

@property (nonatomic, assign) CGFloat viewWidth;
@property (nonatomic, assign) CGFloat viewHeight;

@property (nonatomic, strong) UIImageView *valueBackgroundScreen;
@property (nonatomic, strong) UIImageView *valueDaniRequest;
@property (nonatomic, strong) UIImageView *valueKatAvatar;

@property (nonatomic, strong) TTTAttributedLabel *valueLabelText4;

@end

@implementation HowItWorksSeventhView

#pragma mark - initiation screen 1
/**
 * Lazily init the value prop image
 * @return UIImageView
 */
-(UIImageView *)valueBackgroundImageView {
    if (_valueBackgroundScreen == nil) {
        CGFloat height = self.viewWidth * (1334.0/750.0);
        CGRect frame = CGRectMake(0, 0, self.viewWidth, self.viewHeight);
        if (height > self.viewHeight) frame = CGRectMake(0, self.viewHeight - height, self.viewWidth, height);
        
        _valueBackgroundScreen = [[UIImageView alloc] initWithFrame:frame];
        _valueBackgroundScreen.contentMode = UIViewContentModeScaleAspectFill;
        _valueBackgroundScreen.backgroundColor = [UIColor whiteColor];
        _valueBackgroundScreen.image = [UIImage imageNamed:VALUE_BACKGROUND_SCREEN_2];
    }
    return _valueBackgroundScreen;
}

#pragma mark - initiation screen 4

/**
 * Lazily init the value prop text
 * @return TTTAttributedLabel
 */

-(TTTAttributedLabel *)valueTitleText4 {
    if (_valueLabelText4 == nil) {
        CGRect frame = CGRectMake((self.viewWidth - 220)/2, 25, 220, 55);
        _valueLabelText4 = [[TTTAttributedLabel alloc] initWithFrame:frame];
        _valueLabelText4.textColor = [FontColor backgroundOverlayColor];
        _valueLabelText4.font = [UIFont fontWithName:@"AvenirNext-Medium" size:17];
        _valueLabelText4.lineSpacing = 5;
        _valueLabelText4.numberOfLines = 0;
        _valueLabelText4.textAlignment = NSTextAlignmentCenter;
        _valueLabelText4.alpha = 0;
        _valueLabelText4.text = VALUE_LABEL_TEXT_4;
    }
    return _valueLabelText4;
}

/**
 * Lazily init the value prop image
 * @return UIImageView
 */

-(UIImageView *)valueDaniStayRequest{
    if (_valueDaniRequest == nil) {
        CGFloat width = self.viewWidth * 0.65;
        CGFloat height = width * 728.0/519.0;
        CGFloat yOrigin = 210;
        if ([Device isIphone5]) yOrigin = 190;
        if ([Device isIphone4]) yOrigin = 160;
        
        CGRect frame = CGRectMake(self.viewWidth * 0.175, yOrigin, self.viewWidth * 0.65, height);
        
        _valueDaniRequest = [[UIImageView alloc] initWithFrame:frame];
        _valueDaniRequest.contentMode = UIViewContentModeScaleAspectFill;
        _valueDaniRequest.backgroundColor = [UIColor clearColor];
        _valueDaniRequest.image = [UIImage imageNamed:VALUE_DANIREQUEST_IMAGE];
        _valueDaniRequest.alpha = 0.0f;
    }
    return _valueDaniRequest;
}

/**
 * Lazily init the value prop image
 * @return UIImageView
 */

-(UIImageView *)valueAvatarDaniStayRequest{
    if (_valueKatAvatar == nil) {
        CGFloat size = [Device isIphone5] ? 90 : ([Device isIphone4] ? 60 : 110);
        CGRect frame = CGRectMake(CGRectGetMinX(self.valueDaniRequest.frame) - 20, 120, size, size);
        _valueKatAvatar = [[UIImageView alloc] initWithFrame:frame];
        _valueKatAvatar.contentMode = UIViewContentModeScaleAspectFill;
        _valueKatAvatar.backgroundColor = [UIColor clearColor];
        _valueKatAvatar.image = [UIImage imageNamed:VALUE_KAT_AVATAR_IMAGE];//VALUE_KAT_AVATR];
        _valueKatAvatar.alpha = 0.0f;
    }
    return _valueKatAvatar;
}

-(void) initScreen4 {
 
    [self addSubview:[self valueTitleText4]];
    [self addSubview:[self valueDaniStayRequest]];
    [self addSubview:[self valueAvatarDaniStayRequest]];
}

#pragma mark - public method
-(id)init {
    self.viewWidth = [UIScreen mainScreen].bounds.size.width;
    self.viewHeight = [UIScreen mainScreen].bounds.size.height;
    _animationStatus = None;
    self = [super initWithFrame:CGRectMake(6 * self.viewWidth, 0, self.viewWidth, self.viewHeight)];
    if (self) {
        [self addSubview:[self valueBackgroundImageView]];
        [self initScreen4];

    }
    return self;
}

/**
 * show the view4 in animation
 */

-(void) showView {
    if (_animationStatus != None)
        _animationStatus = Running;
    [UIView animateWithDuration:1.0f delay:0.0f options:UIViewAnimationOptionTransitionCurlUp animations:^{
        _valueLabelText4.alpha = 1;
    } completion:^(BOOL finished) {
        if (finished) {
            [UIView animateWithDuration:1.5f delay:0.5f options:UIViewAnimationOptionTransitionCurlUp animations:^{
                _valueDaniRequest.alpha = 1;
            } completion:^(BOOL finished) {}];
            
            CGFloat size = [Device isIphone5] ? 90 : ([Device isIphone4] ? 60 : 110);
            _valueKatAvatar.frame = CGRectMake(CGRectGetMinX(self.valueDaniRequest.frame) - 20, 120, size, size);
            _valueKatAvatar.transform = CGAffineTransformMakeScale(1.5, 1.5);
            _valueKatAvatar.alpha = 0;
            [UIView animateWithDuration:0.5f delay:1.5f options:UIViewAnimationOptionTransitionCurlUp animations:^{
                _valueKatAvatar.transform = CGAffineTransformIdentity;
                _valueKatAvatar.alpha = 1;
            } completion:^(BOOL finished) {
                if (_animationStatus == None) {
//                    [_howItWorksViewDelegate gotoNextPage];
                    [self performSelector:@selector(goToNextPage) withObject:nil afterDelay:1.5f];
                }
                _animationStatus = Done;
//                [_howItWorksViewDelegate gotoNextPage];
            }];
            
        }
    }];
}

/**
 * Go to the next page
 */
-(void)goToNextPage {
    [self.howItWorksViewDelegate gotoNextPage];
}

/**
 * Hide the view and animation
 */
-(void)hideView {
    //screen hide all
    self.valueLabelText4.alpha = 0;
    self.valueDaniRequest.alpha = 0;
    self.valueKatAvatar.alpha = 0;
    
    [self.valueLabelText4.layer removeAllAnimations];
    [self.valueDaniRequest.layer removeAllAnimations];
    [self.valueKatAvatar.layer removeAllAnimations];
}

/**
 * Hide the view and stop animation
 */

-(void)stopAnmationAndShowView {
    
    [self.valueLabelText4.layer removeAllAnimations];
    [self.valueDaniRequest.layer removeAllAnimations];
    [self.valueKatAvatar.layer removeAllAnimations];
    
    self.valueLabelText4.alpha = 1;
    self.valueDaniRequest.alpha = 1;
    self.valueKatAvatar.alpha = 1;

}
@end
