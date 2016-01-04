//
//  ValuePropThirdView.m
//  Magpie
//
//  Created by kakalot on 7/29/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import "HowItWorksFourthView.h"
#import "Device.h"
#import "TTTAttributedLabel.h"
#import "FontColor.h"

static NSString * VALUE_LABEL_TEXT_1 = @"She searched on Magpie for free accommendations";
static NSString * VALUE_BACKGROUND_SCREEN_2 = @"Background_Screen_2";

static NSString * VALUE_OPTION_REQUEST_1 = @"Huong's";
static NSString * VALUE_OPTION_REQUEST_2 = @"Huong's_2";
static NSString * VALUE_OPTION_REQUEST_3 = @"Huong's_3";
static NSString * VALUE_OPTION_REQUEST_4 = @"Huong's_4";

@interface HowItWorksFourthView()

@property (nonatomic, assign) CGFloat viewWidth;
@property (nonatomic, assign) CGFloat viewHeight;

@property (nonatomic, strong) UIImageView *valueBackgroundScreen;
@property (nonatomic, strong) UIView *placeOptionsContainer;
@property (nonatomic, strong) UIImageView *valueOptionRequest1;
@property (nonatomic, strong) UIImageView *valueOptionRequest2;
@property (nonatomic, strong) UIImageView *valueOptionRequest3;
@property (nonatomic, strong) UIImageView *valueOptionRequest4;

@property (nonatomic, strong) TTTAttributedLabel *valueLabelText1;


@end

@implementation HowItWorksFourthView

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

/**
 * Lazily init the value prop text
 * @return TTTAttributedLabel
 */
-(TTTAttributedLabel *)valueTitleText1 {
    if (_valueLabelText1 == nil) {
        CGRect frame = CGRectMake((self.viewWidth - 250)/2, 25, 250, 55);
        _valueLabelText1 = [[TTTAttributedLabel alloc] initWithFrame:frame];
        _valueLabelText1.textColor = [FontColor backgroundOverlayColor];
        _valueLabelText1.font = [UIFont fontWithName:@"AvenirNext-Medium" size:17];
        _valueLabelText1.lineSpacing = 5;
        _valueLabelText1.numberOfLines = 0;
        _valueLabelText1.textAlignment = NSTextAlignmentCenter;
        _valueLabelText1.alpha = 0;
        _valueLabelText1.text = VALUE_LABEL_TEXT_1;
    }
    return _valueLabelText1;
}

/**
 * Lazily init the place options container
 * @return UIView
 */
-(UIView *)placeOptionsContainer {
    if (_placeOptionsContainer == nil) {
        CGRect frame;
        CGFloat availableWidth = self.viewWidth - 30;
        CGFloat availableHeight = self.viewHeight - 140;
        CGFloat widthScale = (availableWidth - 10)/(2.0 * 300.0);
        CGFloat heightScale = (availableHeight - 10)/(992.0);
        
        if (heightScale < widthScale) {
            frame = CGRectMake((self.viewWidth - (heightScale * 600.0 + 10))/2.0, 110, heightScale * 600.0 + 10, availableHeight);
        } else frame = CGRectMake(15, 110, availableWidth, widthScale * 992.0 + 15);
        _placeOptionsContainer = [[UIView alloc] initWithFrame:frame];
    }
    return _placeOptionsContainer;
}

/**
 * Lazily init the value prop blur image view
 * @return UIImageView
 */
-(UIImageView *)valueOptionRequestImage1 {
    if (_valueOptionRequest1 == nil) {
        CGFloat width = (self.placeOptionsContainer.frame.size.width - 10)/2.0;
        CGFloat height = width * 510.0 / 300.0;
        _valueOptionRequest1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
        _valueOptionRequest1.contentMode = UIViewContentModeScaleAspectFill;
        _valueOptionRequest1.image = [UIImage imageNamed:VALUE_OPTION_REQUEST_1];
        _valueOptionRequest1.backgroundColor = [UIColor clearColor];
        _valueOptionRequest1.alpha = 0;
    }
    return _valueOptionRequest1;
    
}

/**
 * Lazily init the value prop blur image view
 * @return UIImageView
 */
-(UIImageView *)valueOptionRequestImage2 {
    if (_valueOptionRequest2 == nil) {
        CGFloat width = (self.placeOptionsContainer.frame.size.width - 10)/2.0;
        CGFloat height = width * 482.0 / 300.0;
        _valueOptionRequest2 = [[UIImageView alloc] initWithFrame:CGRectMake(width + 10, 0, width, height)];
        _valueOptionRequest2.contentMode = UIViewContentModeScaleAspectFill;
        _valueOptionRequest2.image = [UIImage imageNamed:VALUE_OPTION_REQUEST_2];
        _valueOptionRequest2.backgroundColor = [UIColor clearColor];
        _valueOptionRequest2.alpha = 0;
    }
    return _valueOptionRequest2;
    
}

/**
 * Lazily init the value prop blur image view
 * @return UIImageView
 */
-(UIImageView *)valueOptionRequestImage3 {
    if (_valueOptionRequest3 == nil) {
        CGFloat width = (self.placeOptionsContainer.frame.size.width - 10)/2.0;
        CGFloat height = width * 482.0 / 300.0;
        _valueOptionRequest3 = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.valueOptionRequest1.frame) + 10, width, height)];
        _valueOptionRequest3.contentMode = UIViewContentModeScaleAspectFill;
        _valueOptionRequest3.image = [UIImage imageNamed:VALUE_OPTION_REQUEST_3];
        _valueOptionRequest3.backgroundColor = [UIColor clearColor];
        _valueOptionRequest3.alpha = 0;
    }
    return _valueOptionRequest3;
    
}

/**
 * Lazily init the value prop blur image view
 * @return UIImageView
 */
-(UIImageView *)valueOptionRequestImage4 {
    if (_valueOptionRequest4 == nil) {
        CGFloat width = (self.placeOptionsContainer.frame.size.width - 10)/2.0;
        CGFloat height = width * 510.0 / 300.0;
        _valueOptionRequest4 = [[UIImageView alloc] initWithFrame:CGRectMake(width + 10, CGRectGetMaxY(self.valueOptionRequest2.frame) + 10, width, height)];
        _valueOptionRequest4.contentMode = UIViewContentModeScaleAspectFill;
        _valueOptionRequest4.image = [UIImage imageNamed:VALUE_OPTION_REQUEST_4];
        _valueOptionRequest4.backgroundColor = [UIColor clearColor];
        _valueOptionRequest4.alpha = 0;
    }
    return _valueOptionRequest4;
    
}

#pragma mark Init all screens
/**
 * Inititialize all screen
 */
-(void) initScreen1 {
    [self addSubview:[self valueBackgroundImageView]];
    
    [self addSubview:[self valueTitleText1]];
    [self addSubview:[self placeOptionsContainer]];
    [self.placeOptionsContainer addSubview:[self valueOptionRequestImage1]];
    [self.placeOptionsContainer addSubview:[self valueOptionRequestImage2]];
    [self.placeOptionsContainer addSubview:[self valueOptionRequestImage3]];
    [self.placeOptionsContainer addSubview:[self valueOptionRequestImage4]];
}

#pragma mark - public method
-(id)init {
    self.viewWidth = [UIScreen mainScreen].bounds.size.width;
    self.viewHeight = [UIScreen mainScreen].bounds.size.height;
    _animationStatus = None;
    self = [super initWithFrame:CGRectMake(self.viewWidth * 3, 0, self.viewWidth, self.viewHeight)];
    if (self) {
        [self initScreen1];
    }
    return self;
}

/**
 * Show the view in animation
 */
-(void)showView {
    if (_animationStatus != None)
        _animationStatus = Running;
    [UIView animateWithDuration:0.8f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _valueLabelText1.alpha = 1;
    } completion:^(BOOL finished) {
        if (finished) {
            [UIView animateWithDuration:1.2 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                _valueOptionRequest1.alpha = 1;
            } completion:^(BOOL finished) {}];
            
            [UIView animateWithDuration:1.2f delay:0.7 options:UIViewAnimationOptionCurveEaseIn animations:^{
                _valueOptionRequest2.alpha = 1;
            } completion:^(BOOL finished) {}];
            
            [UIView animateWithDuration:1.2f delay:1.4 options:UIViewAnimationOptionCurveEaseIn animations:^{
                _valueOptionRequest3.alpha = 1;
            } completion:^(BOOL finished) {}];
            

            
            [UIView animateWithDuration:1.2 delay:2.1 options:UIViewAnimationOptionCurveEaseIn animations:^{
                _valueOptionRequest4.alpha = 1;
            } completion:^(BOOL finished) {
                if (finished) {
                    if (_animationStatus == None) {
//                        [_howItWorksViewDelegate gotoNextPage];
                        [self performSelector:@selector(goToNextPage) withObject:nil afterDelay:1.5f];
                        
                    }
                    _animationStatus = Done;
//                    [_howItWorksViewDelegate gotoNextPage];
//                    [self animatedScreen2];
                }
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
    self.valueOptionRequest1.alpha = 0;
    self.valueOptionRequest2.alpha = 0;
    self.valueOptionRequest3.alpha = 0;
    self.valueOptionRequest4.alpha = 0;
    self.valueLabelText1.alpha = 0;
    
    [self.valueOptionRequest1.layer removeAllAnimations];
    [self.valueOptionRequest2.layer removeAllAnimations];
    [self.valueOptionRequest3.layer removeAllAnimations];
    [self.valueOptionRequest4.layer removeAllAnimations];
    [self.valueLabelText1.layer removeAllAnimations];

}

/**
 * Hide the view and animation
 */
-(void)stopAnmationAndShowView {
   
    [self.valueOptionRequest1.layer removeAllAnimations];
    [self.valueOptionRequest2.layer removeAllAnimations];
    [self.valueOptionRequest3.layer removeAllAnimations];
    [self.valueOptionRequest4.layer removeAllAnimations];
    [self.valueLabelText1.layer removeAllAnimations];

    self.valueOptionRequest1.alpha = 1;
    self.valueOptionRequest2.alpha = 1;
    self.valueOptionRequest3.alpha = 1;
    self.valueOptionRequest4.alpha = 1;
    self.valueLabelText1.alpha = 1;
}

@end
