//
//  ValuePropThirdView.m
//  Magpie
//
//  Created by kakalot on 7/29/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import "HowItWorksNinethView.h"
#import "Device.h"
#import "TTTAttributedLabel.h"
#import "FontColor.h"

static NSString * VALUE_LABEL_TEXT_6 = @"That’s how Dani stayed at Kat’s lovely victorian house for free, and met a good friend";

static NSString * VALUE_BACKGROUND_SCREEN_3 = @"Background_Screen_3";
static NSString * VALUE_DANI_AVATAR_IMAGE = @"Dani_Avatar_291";
static NSString * VALUE_HOUSE_IMAGE = @"House_layer";
static NSString * VALUE_KAT_AVATAR_IMAGE = @"Kat_Avatar_221";

@interface HowItWorksNinethView()

@property (nonatomic, assign) CGFloat viewWidth;
@property (nonatomic, assign) CGFloat viewHeight;

@property (nonatomic, strong) UIImageView *valueBackgroundScreen;
@property (nonatomic, strong) UIImageView *valueHouseImage;
@property (nonatomic, strong) UIImageView *valueDaniAvatar;
@property (nonatomic, strong) UIImageView *valueKatAvatar;

@property (nonatomic, strong) TTTAttributedLabel *valueLabelText6;

@end

@implementation HowItWorksNinethView

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
        _valueBackgroundScreen.image = [UIImage imageNamed:VALUE_BACKGROUND_SCREEN_3];
    }
    return _valueBackgroundScreen;
}

#pragma mark - initiation screen 6

/**
* Lazily init the value prop text
* @return TTTAttributedLabel
*/

-(TTTAttributedLabel *)valueTitleText6 {
    if (_valueLabelText6 == nil) {
        CGRect frame = CGRectMake((self.viewWidth - 280)/2, 25, 280, 80);
        _valueLabelText6 = [[TTTAttributedLabel alloc] initWithFrame:frame];
        _valueLabelText6.textColor = [FontColor backgroundOverlayColor];
        _valueLabelText6.font = [UIFont fontWithName:@"AvenirNext-Medium" size:17];
        _valueLabelText6.lineSpacing = 5;
        _valueLabelText6.numberOfLines = 0;
        _valueLabelText6.textAlignment = NSTextAlignmentCenter;
        _valueLabelText6.alpha = 0;
        _valueLabelText6.text = VALUE_LABEL_TEXT_6;
    }
    return _valueLabelText6;
}

/**
 * Lazily init the value prop image
 * @return UIImageView
 */

-(UIImageView *)valueDaniAvatarImage{
    if (_valueDaniAvatar == nil) {
        _valueDaniAvatar = [[UIImageView alloc] initWithFrame:CGRectMake((self.viewWidth - 280)/2, 140, 120, 120)];
        _valueDaniAvatar.contentMode = UIViewContentModeScaleAspectFill;
        _valueDaniAvatar.backgroundColor = [UIColor clearColor];
        _valueDaniAvatar.image = [UIImage imageNamed:VALUE_DANI_AVATAR_IMAGE];
        _valueDaniAvatar.alpha = 0.0f;

    }
    return _valueDaniAvatar;
}

/**
 * Lazily init the value prop image
 * @return UIImageView
 */

-(UIImageView *)valueHouseKatImage{
    if (_valueHouseImage == nil) {
        CGFloat width = self.viewWidth * 0.3;
        CGFloat height = width * 225.0/150.0;
        _valueHouseImage = [[UIImageView alloc] initWithFrame:CGRectMake(self.viewWidth * 0.25, self.viewHeight - height, width, height)];
        _valueHouseImage.contentMode = UIViewContentModeScaleAspectFill;
        _valueHouseImage.backgroundColor = [UIColor clearColor];
        _valueHouseImage.image = [UIImage imageNamed:VALUE_HOUSE_IMAGE];
        _valueHouseImage.alpha = 0.0f;
    }
    return _valueHouseImage;
}

/**
 * Lazily init the value Kat Avatar image
 * @return UIImageView
 */

-(UIImageView *)valueKatAvatarImage{
    if (_valueKatAvatar == nil) {
    
        _valueKatAvatar = [[UIImageView alloc] init];
//        _valueKatAvatar.contentMode = UIViewContentModeScaleAspectFill;
        _valueKatAvatar.backgroundColor = [UIColor clearColor];
        _valueKatAvatar.image = [UIImage imageNamed:VALUE_KAT_AVATAR_IMAGE];
        _valueKatAvatar.alpha = 0.0f;
    }
    return _valueKatAvatar;
}

-(void) initScreen6 {
    [self addSubview:[self valueTitleText6]];
    [self addSubview:[self valueKatAvatarImage]];
    [self addSubview:[self valueDaniAvatarImage]];
    [self addSubview:[self valueHouseKatImage]];
}

#pragma mark - public method
-(id)init {
    self.viewWidth = [UIScreen mainScreen].bounds.size.width;
    self.viewHeight = [UIScreen mainScreen].bounds.size.height;
    _animationStatus = None;
    self = [super initWithFrame:CGRectMake(8 * self.viewWidth, 0, self.viewWidth, self.viewHeight)];
    if (self) {
        [self addSubview:[self valueBackgroundImageView]];
        [self initScreen6];
    }
    return self;
}

/**
 * Lazily init the value prop image
 * @return UIImageView
 */

-(void) addValueAvatarKat{
    
//    CGRect frame =CGRectMake(self.viewWidth * 0.1, self.viewHeight * 0.266, self.viewWidth *0.38, self.viewHeight *0.21);
    
    if ([Device isIphone5] )  {
        _valueKatAvatar.frame = CGRectMake(self.viewWidth *0.12, self.viewHeight * 0.266, self.viewWidth *0.35, self.viewHeight *0.2);
    }
    else if ([Device isIphone4])  {
        _valueKatAvatar.frame = CGRectMake(self.viewWidth *0.15, self.viewHeight * 0.266, self.viewWidth *0.32, self.viewHeight *0.18);
    }
    else _valueKatAvatar.frame = CGRectMake(self.viewWidth * 0.1, self.viewHeight * 0.266, self.viewWidth *0.38, self.viewHeight *0.21);;
    _valueKatAvatar.alpha = 1.0f;
}

/**
 * show the view6 in animation
 */
-(void) showView {
    
    if (_animationStatus != None)
        _animationStatus = Running;
    
    if ([Device isIphone5] )  {
        _valueKatAvatar.frame = CGRectMake(- self.viewWidth *2.12, self.viewHeight * 0.266, self.viewWidth *0.35, self.viewHeight *0.2);
    }
    else if ([Device isIphone4])  {
        _valueKatAvatar.frame = CGRectMake(- self.viewWidth *2.15, self.viewHeight * 0.266, self.viewWidth *0.32, self.viewHeight *0.18);
    }
    else
        _valueKatAvatar.frame = CGRectMake(- self.viewWidth * 2.1, self.viewHeight * 0.266, self.viewWidth *0.38, self.viewHeight *0.21);
    
    [UIView animateWithDuration:0.8f delay:0.0f options:UIViewAnimationOptionTransitionFlipFromTop animations:^{
        _valueLabelText6.alpha = 1;
//        [self addValueAvatarKat];
        if ([Device isIphone5] )  {
            _valueKatAvatar.frame = CGRectMake(self.viewWidth *0.12, self.viewHeight * 0.266, self.viewWidth *0.35, self.viewHeight *0.2);
        }
        else if ([Device isIphone4])  {
            _valueKatAvatar.frame = CGRectMake(self.viewWidth *0.15, self.viewHeight * 0.266, self.viewWidth *0.32, self.viewHeight *0.18);
        }
        else _valueKatAvatar.frame = CGRectMake(self.viewWidth * 0.1, self.viewHeight * 0.266, self.viewWidth *0.38, self.viewHeight *0.21);
        
        _valueKatAvatar.alpha = 1.0f;
        
    } completion:^(BOOL finished) {
        if (finished) {
            
            if ([Device isIphone5] )  {
                _valueDaniAvatar.frame = CGRectMake(self.viewWidth *2.57, self.viewHeight * 0.266, self.viewWidth *0.29, self.viewHeight *0.19);
            }
            else if ([Device isIphone4])  {
                _valueDaniAvatar.frame = CGRectMake(self.viewWidth *2.54, self.viewHeight * 0.256, self.viewWidth *0.3, self.viewHeight *0.2);
            }
            else
                _valueDaniAvatar.frame = CGRectMake(self.viewWidth * 2.58, self.viewHeight * 0.266, self.viewWidth *0.3, self.viewHeight *0.2);
            
            [UIView animateWithDuration:1.0f delay:0.0f options:UIViewAnimationOptionCurveLinear animations:^{
                _valueDaniAvatar.alpha = 1;
                if ([Device isIphone5] )  {
                    _valueDaniAvatar.frame = CGRectMake(self.viewWidth *0.57, self.viewHeight * 0.266, self.viewWidth *0.29, self.viewHeight *0.19);
                }
                else if ([Device isIphone4])  {
                    _valueDaniAvatar.frame = CGRectMake(self.viewWidth *0.54, self.viewHeight * 0.256, self.viewWidth *0.3, self.viewHeight *0.2);
                }
                else
                    _valueDaniAvatar.frame = CGRectMake(self.viewWidth * 0.58, self.viewHeight * 0.266, self.viewWidth *0.3, self.viewHeight *0.2);
                
                
            } completion:^(BOOL finished) {
                if (finished) {
                    [UIView animateWithDuration:1.0f delay:0.0f options:UIViewAnimationOptionOverrideInheritedCurve animations:^{
                        _valueHouseImage.alpha = 1;
                    } completion:^(BOOL finished) {
                        if (finished) {
                            if (_animationStatus == None) {
                                [self performSelector:@selector(goToNextPage) withObject:nil afterDelay:1.2f];
                            }
                            _animationStatus = Done;
                        }
                    }];
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
    self.valueLabelText6.alpha = 0;
    self.valueHouseImage.alpha = 0;
    self.valueDaniAvatar.alpha = 0;
    self.valueKatAvatar.alpha = 0;
    
    [self.valueLabelText6.layer removeAllAnimations];
    [self.valueHouseImage.layer removeAllAnimations];
    [self.valueDaniAvatar.layer removeAllAnimations];
    [self.valueKatAvatar.layer removeAllAnimations];

}

/**
 * Hide the view and stop animation
 */
-(void)stopAnmationAndShowView {
    //screen hide all
    [self.valueLabelText6.layer removeAllAnimations];
    [self.valueHouseImage.layer removeAllAnimations];
    [self.valueDaniAvatar.layer removeAllAnimations];
    [self.valueKatAvatar.layer removeAllAnimations];
    
    self.valueLabelText6.alpha = 1;
    self.valueHouseImage.alpha = 1;
    self.valueDaniAvatar.alpha = 1;
    self.valueKatAvatar.alpha = 1;
}

@end
