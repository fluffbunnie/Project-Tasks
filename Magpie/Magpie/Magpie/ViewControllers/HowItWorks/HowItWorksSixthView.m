//
//  ValuePropThirdView.m
//  Magpie
//
//  Created by kakalot on 7/29/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import "HowItWorksSixthView.h"
#import "Device.h"
#import "TTTAttributedLabel.h"
#import "FontColor.h"

static NSString * VALUE_LABEL_TEXT_3 = @"She sent a stay request to Kat’s house";
static NSString * VALUE_BACKGROUND_SCREEN_2 = @"Background_Screen_2";
static NSString * VALUE_STAY_REQ_IMAGE = @"Dani_stay_request";

@interface HowItWorksSixthView()

@property (nonatomic, assign) CGFloat viewWidth;
@property (nonatomic, assign) CGFloat viewHeight;
@property (nonatomic, strong) UIImageView *valueBackgroundScreen;
@property (nonatomic, strong) UIImageView *valueStayRequestImage;
@property (nonatomic, strong) TTTAttributedLabel *valueLabelText3;

@end

@implementation HowItWorksSixthView

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

#pragma mark - initiation screen 3

/**
 * Lazily init the value prop text
 * @return TTTAttributedLabel
 */
-(TTTAttributedLabel *)valueTitleText3 {
    if (_valueLabelText3 == nil) {
        CGRect frame = CGRectMake((self.viewWidth - 220)/2, 25, 220, 55);
        _valueLabelText3 = [[TTTAttributedLabel alloc] initWithFrame:frame];
        _valueLabelText3.textColor = [FontColor backgroundOverlayColor];
        _valueLabelText3.font = [UIFont fontWithName:@"AvenirNext-Medium" size:17];
        _valueLabelText3.lineSpacing = 5;
        _valueLabelText3.numberOfLines = 0;
        _valueLabelText3.textAlignment = NSTextAlignmentCenter;
        _valueLabelText3.alpha = 0;
        _valueLabelText3.text = VALUE_LABEL_TEXT_3;
    }
    return _valueLabelText3;
}

/**
 * Lazily init the value prop image
 * @return UIImageView
 */

-(UIImageView *)valueStayRequest{
    if (_valueStayRequestImage == nil) {

        CGRect frame;
        CGFloat availableWidth = self.viewWidth - 30;
        CGFloat availableHeight = self.viewHeight - 140;
        CGFloat widthScale = (availableWidth - 10)/(2.0 * 300.0);
        CGFloat heightScale = (availableHeight - 10)/(992.0);
        
        if (heightScale < widthScale) {
            frame = CGRectMake((self.viewWidth - (heightScale * 600.0 + 10))/2.0, 110, heightScale * 600.0 + 10, availableHeight);
        } else frame = CGRectMake(15, 110, availableWidth, widthScale * 992.0 + 15);
        
        CGFloat width = (frame.size.width - 10)/2.0;
        CGFloat height = width * 510.0 / 300.0;
        CGFloat height1 = height * 1009.0/580.0;
        
        _valueStayRequestImage = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(frame), CGRectGetMinY(frame) +10, CGRectGetWidth(frame), height1)];
        _valueStayRequestImage.contentMode = UIViewContentModeScaleAspectFill;
        _valueStayRequestImage.backgroundColor = [UIColor clearColor];
        _valueStayRequestImage.image = [UIImage imageNamed:VALUE_STAY_REQ_IMAGE];
        _valueStayRequestImage.alpha = 0.0f;
    }
    return _valueStayRequestImage;
}

-(void) initScreen3 {
    [self addSubview:[self valueTitleText3]];
    [self addSubview:[self valueStayRequest]];
}

#pragma mark - public method
-(id)init {
    self.viewWidth = [UIScreen mainScreen].bounds.size.width;
    self.viewHeight = [UIScreen mainScreen].bounds.size.height;
    _animationStatus = None ;
    self = [super initWithFrame:CGRectMake(5 * self.viewWidth, 0, self.viewWidth, self.viewHeight)];
    if (self) {
        [self addSubview:[self valueBackgroundImageView]];
        [self initScreen3];
    }
    return self;
}


-(void) showView {
    if (_animationStatus != None)
        _animationStatus = Running;
    [UIView animateWithDuration:1.0f delay:0.5f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _valueLabelText3.alpha = 1;
    } completion:^(BOOL finished) {}];
    
//    _valueStayRequestImage.frame = _valueHuongCheckOut.frame;
    [UIView animateWithDuration:1.5f delay:1.0f options:UIViewAnimationOptionTransitionFlipFromRight animations:^{
        _valueStayRequestImage.alpha = 1;
    } completion:^(BOOL finished) {
        if (finished) {
            if (_animationStatus == None) {
//                [_howItWorksViewDelegate gotoNextPage];
                [self performSelector:@selector(goToNextPage) withObject:nil afterDelay:2.0f];
            }
            _animationStatus = Done;
//            [_howItWorksViewDelegate gotoNextPage];
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
    self.valueLabelText3.alpha = 0;
    self.valueStayRequestImage.alpha = 0;
    
    [self.valueLabelText3.layer removeAllAnimations];
    [self.valueStayRequestImage.layer removeAllAnimations];
}

/**
 * Hide the view and stop animation
 */
-(void)stopAnmationAndShowView {
    
    [self.valueLabelText3.layer removeAllAnimations];
    [self.valueStayRequestImage.layer removeAllAnimations];
    
    self.valueLabelText3.alpha = 1;
    self.valueStayRequestImage.alpha = 1;
    
}
@end
