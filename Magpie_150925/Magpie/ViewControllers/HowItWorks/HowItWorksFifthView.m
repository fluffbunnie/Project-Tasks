//
//  ValuePropThirdView.m
//  Magpie
//
//  Created by minh thao nguyen on 7/29/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import "HowItWorksFifthView.h"
#import "Device.h"
#import "TTTAttributedLabel.h"
#import "FontColor.h"

static NSString * VALUE_LABEL_TEXT_2 = @"She checked out details of each place and the host";
static NSString * VALUE_OPTION_REQUEST_1 = @"Huong's";
static NSString * VALUE_BACKGROUND_SCREEN_2 = @"Background_Screen_2";
static NSString * VALUE_HUONG_CHECK_OUT = @"Huong's_checkout";

@interface HowItWorksFifthView()

@property (nonatomic, assign) CGFloat viewWidth;
@property (nonatomic, assign) CGFloat viewHeight;

@property (nonatomic, strong) UIImageView *valueBackgroundScreen;
@property (nonatomic, strong) UIImageView *valueHuongCheckOut;
@property (nonatomic, strong) TTTAttributedLabel *valueLabelText2;
@end

@implementation HowItWorksFifthView

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

- (CGRect) getFrameSize{
    CGRect frame;
    CGFloat availableWidth = self.viewWidth - 30;
    CGFloat availableHeight = self.viewHeight - 140;
    CGFloat widthScale = (availableWidth - 10)/(2.0 * 300.0);
    CGFloat heightScale = (availableHeight - 10)/(992.0);
    
    if (heightScale < widthScale) {
        frame = CGRectMake((self.viewWidth - (heightScale * 600.0 + 10))/2.0, 110, heightScale * 600.0 + 10, availableHeight);
    } else frame = CGRectMake(15, 110, availableWidth, widthScale * 992.0 + 15);
    return frame;
}

#pragma mark - initiation screen 2

/**
 * Lazily init the value prop text
 * @return TTTAttributedLabel
 */

-(TTTAttributedLabel *)valueTitleText2 {
    if (_valueLabelText2 == nil) {
        CGRect frame = CGRectMake((self.viewWidth - 250)/2, 25, 250, 55);
        _valueLabelText2 = [[TTTAttributedLabel alloc] initWithFrame:frame];
        _valueLabelText2.textColor = [FontColor backgroundOverlayColor];
        _valueLabelText2.font = [UIFont fontWithName:@"AvenirNext-Medium" size:17];
        _valueLabelText2.lineSpacing = 5;
        _valueLabelText2.numberOfLines = 0;
        _valueLabelText2.textAlignment = NSTextAlignmentCenter;
        _valueLabelText2.alpha = 0;
        _valueLabelText2.text = VALUE_LABEL_TEXT_2;
    }
    return _valueLabelText2;
}

/**
 * Lazily init the value prop image
 * @return UIImageView
 */
-(UIImageView *)valueCheckOutDetails{
    if (_valueHuongCheckOut == nil) {
        CGRect frame = [self getFrameSize];
        
        CGFloat width = (frame.size.width - 10)/2.0;
        CGFloat height = width * 510.0 / 300.0;
        
        CGRect frame1 = CGRectMake(0, 0, width, height);
        
        CGFloat height1 = CGRectGetWidth(frame1) * 1009.0/580.0;
        _valueHuongCheckOut = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(frame), CGRectGetMinY(frame), CGRectGetWidth(frame1), height1)];
        
        _valueHuongCheckOut.contentMode = UIViewContentModeScaleAspectFill;
        _valueHuongCheckOut.backgroundColor = [UIColor clearColor];
        _valueHuongCheckOut.image = [UIImage imageNamed:VALUE_HUONG_CHECK_OUT];
        _valueHuongCheckOut.alpha = 0.0f;
    }
    return _valueHuongCheckOut;
}

-(void) initScreen2 {
//    [self addSubview:[self placeOptionsContainer]];
//    [self.placeOptionsContainer addSubview:[self valueOptionRequestImage1]];
    [self addSubview:[self valueTitleText2]];
    [self addSubview:[self valueCheckOutDetails]];
}

#pragma mark - public method
-(id)init {
    self.viewWidth = [UIScreen mainScreen].bounds.size.width;
    self.viewHeight = [UIScreen mainScreen].bounds.size.height;
    _animationStatus = None;
    self = [super initWithFrame:CGRectMake(self.viewWidth * 4, 0, self.viewWidth, self.viewHeight)];
    if (self) {
        [self addSubview:[self valueBackgroundImageView]];
        [self initScreen2];
    }
    return self;
}

/**
 * show the view2 in animation
 */
-(void) showView {
    if (_animationStatus != None)
        _animationStatus = Running;
    [UIView animateWithDuration:0.8f delay:0.5f options:UIViewAnimationOptionCurveEaseOut animations:^{
        _valueLabelText2.alpha = 1;
    } completion:^(BOOL finished) {}];
    
    CGRect frame = [self getFrameSize];
    
    CGFloat desizedHeight = CGRectGetWidth(frame) * 1009.0/580.0;
    CGRect targetFrame = CGRectMake(CGRectGetMinX(frame), CGRectGetMinY(frame), CGRectGetWidth(frame), desizedHeight);
    if (desizedHeight > CGRectGetHeight(frame)) {
        CGFloat desizedWidth = CGRectGetHeight(frame) * 580.0/1009.0;
        targetFrame = CGRectMake((self.viewWidth - desizedWidth)/2, CGRectGetMinY(frame), desizedWidth, CGRectGetHeight(frame));
    }
    [UIView animateWithDuration:1.5f delay:1.5f options:UIViewAnimationOptionOverrideInheritedCurve animations:^{
        _valueHuongCheckOut.alpha = 1;
        _valueHuongCheckOut.frame = targetFrame;
    } completion:^(BOOL finished) {
        if (finished) {
            if (_animationStatus == None) {
                [self performSelector:@selector(goToNextPage) withObject:nil afterDelay:2.0f];
            }
            _animationStatus = Done;
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
    self.valueLabelText2.alpha = 0;
    self.valueHuongCheckOut.alpha = 0;
    [self.valueLabelText2.layer removeAllAnimations];
    [self.valueHuongCheckOut.layer removeAllAnimations];
}

/**
 * Hide the view and animation
 */
-(void)stopAnmationAndShowView {
    
    [self.valueLabelText2.layer removeAllAnimations];
    [self.valueHuongCheckOut.layer removeAllAnimations];
    
    self.valueLabelText2.alpha = 1;
    self.valueHuongCheckOut.alpha = 1;

}

@end
