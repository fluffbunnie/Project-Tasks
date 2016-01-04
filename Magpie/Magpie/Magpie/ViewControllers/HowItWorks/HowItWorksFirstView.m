//
//  ValuePropFirstView.m
//  Magpie
//
//  Created by kakalot on 7/29/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import "HowItWorksFirstView.h"
#import "Device.h"
#import "TTTAttributedLabel.h"
#import "UIImage+ImageEffects.h"

static NSString * VALUE_BACKGROUND_SCREEN_1 = @"Background_Screen_1";
static NSString * VALUE_PROP_ICON = @"Dani_Avatar_291";

static NSString * FIRST_LINE_TEXT = @"Meet Dani";
static NSString * SECOND_LINE_TEXT = @"Female Founder";
static NSString * THIRD_LINE_TEXT = @"Became a happy Magpie since Fall, 2014";

static NSString * FONTNAME = @"AvenirNext-Medium";

static NSString * IMAGE_ANIMATION = @"airplane.png";

@interface HowItWorksFirstView()

@property (nonatomic, assign) CGFloat viewWidth;
@property (nonatomic, assign) CGFloat viewHeight;
@property (nonatomic, strong) UIImageView *valuePropImageView;
@property (nonatomic, strong) UIImageView *valuePropIcon;

@property (nonatomic, strong) TTTAttributedLabel *valuePropText1;
@property (nonatomic, strong) TTTAttributedLabel *valuePropText2;
@property (nonatomic, strong) TTTAttributedLabel *valuePropText3;

@end

@implementation HowItWorksFirstView
#pragma mark - initiation
/**
 * Lazily init the value prop image
 * @return UIImageView
 */
-(UIImageView *)valueBackgroundImageView {
    if (_valuePropImageView == nil) {
        CGFloat height = self.viewWidth * (1334.0/750.0);
        CGRect frame = CGRectMake(0, 0, self.viewWidth, self.viewHeight);
        if (height > self.viewHeight) frame = CGRectMake(0, self.viewHeight - height, self.viewWidth, height);
        
        _valuePropImageView = [[UIImageView alloc] initWithFrame:frame];
        _valuePropImageView.contentMode = UIViewContentModeScaleAspectFill;
        _valuePropImageView.backgroundColor = [UIColor whiteColor];
        _valuePropImageView.image = [UIImage imageNamed:VALUE_BACKGROUND_SCREEN_1];
    }
    return _valuePropImageView;
}

/**
 * Lazily init the value prop icon
 * @return UIImageView
 */
-(UIImageView *)valuePropIcon {
    if (_valuePropIcon == nil) {
        CGRect frame = CGRectMake(self.viewWidth *0.07, self.viewHeight*0.447, 145, 145);
        if ([Device isIphone4])
            frame = CGRectMake(self.viewWidth *0.07, self.viewHeight * 0.4, self.viewWidth *0.3, self.viewHeight *0.22);
        if ([Device isIphone5] )  {
            frame = CGRectMake(self.viewWidth *0.07, self.viewHeight * 0.4, self.viewWidth *0.33, self.viewHeight *0.22);
        }
        _valuePropIcon = [[UIImageView alloc] initWithFrame:frame];
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

-(TTTAttributedLabel *)firstLine {
    if (_valuePropText1 == nil) {
        CGRect frame;
        int fontSize = 22;
        if ([Device isIphone5])  {
            frame = CGRectMake(self.viewWidth *0.52, self.viewHeight*0.33, self.viewWidth*0.4, self.viewWidth*0.4);
            fontSize = 18;
        }
        
        else if ([Device isIphone4])  {
            frame = CGRectMake(self.viewWidth *0.52, self.viewHeight*0.31, self.viewWidth*0.4, self.viewWidth*0.4);
            fontSize = 17;
        }
        else frame = CGRectMake(self.viewWidth *0.526, self.viewHeight*0.32, self.viewWidth*0.4, self.viewHeight*0.35);
        _valuePropText1 = [[TTTAttributedLabel alloc] initWithFrame:frame];
        _valuePropText1.lineSpacing = 10;
        _valuePropText1.font = [UIFont fontWithName:FONTNAME size:fontSize]; //[UIFont boldSystemFontOfSize:24] ;@"AvenirNext-Bold"
        _valuePropText1.textColor = [UIColor whiteColor];
        _valuePropText1.textAlignment = NSTextAlignmentLeft;
        _valuePropText1.numberOfLines = 4;
        _valuePropText1.shadowColor = [UIColor colorWithWhite:0 alpha:0.3];
        _valuePropText1.shadowRadius = 1;
        _valuePropText1.shadowOffset = CGSizeMake(0, 1);
        _valuePropText1.text = FIRST_LINE_TEXT;
        _valuePropText1.alpha = 0;
    }
    return _valuePropText1;
}

/**
 * Lazily init the value prop text
 * @return TTTAttributedLabel
 */

-(TTTAttributedLabel *)secondLine {
    if (_valuePropText2 == nil) {
        CGRect frame ;
        int fontSize = 14;
        
        if ([Device isIphone5])  {
            frame = CGRectMake(self.viewWidth *0.52, self.viewHeight*0.34 + 20, self.viewWidth*0.4, self.viewWidth*0.4);
            fontSize = 13;
        }
        
        else if ([Device isIphone4])  {
            frame = CGRectMake(self.viewWidth *0.52, self.viewHeight*0.32 + 20, self.viewWidth*0.4, self.viewWidth*0.4);
            fontSize = 12;
        }
        
        else frame = CGRectMake(self.viewWidth *0.526, self.viewHeight*0.33 + 10 , self.viewWidth*0.3, self.viewHeight*0.4);
            
        _valuePropText2 = [[TTTAttributedLabel alloc] initWithFrame:frame];
        _valuePropText2.lineSpacing = 10;
        _valuePropText2.font = [UIFont fontWithName:FONTNAME size:fontSize];
        _valuePropText2.textColor = [UIColor whiteColor];
        _valuePropText2.textAlignment = NSTextAlignmentLeft;
        _valuePropText2.shadowColor = [UIColor colorWithWhite:0 alpha:0.3];
        _valuePropText2.shadowRadius = 1;
        _valuePropText2.shadowOffset = CGSizeMake(0, 1);
        _valuePropText2.text = SECOND_LINE_TEXT;
        _valuePropText2.alpha = 0;
    }
    return _valuePropText2;
}

/**
 * Lazily init the value prop text
 * @return TTTAttributedLabel
 */

-(TTTAttributedLabel *)thirdLine {
    if (_valuePropText3 == nil) {
        CGRect frame = CGRectMake(self.viewWidth *0.526, self.viewHeight*0.34 + 36, self.viewWidth*0.5, self.viewHeight*0.4);
        int fontSize = 14;
        if ([Device isIphone5])  {
            frame = CGRectMake(self.viewWidth *0.52, self.viewHeight*0.34 + 50, self.viewWidth*0.5, self.viewWidth*0.4);
            fontSize = 14;
        }
        
        else if ([Device isIphone4])  {
            frame = CGRectMake(self.viewWidth *0.52, self.viewHeight*0.32 + 48, self.viewWidth*0.5, self.viewWidth*0.4);
            fontSize = 12;
        }
       
        else if ([Device isIphone6Plus])  {
            frame = CGRectMake(self.viewWidth *0.526, self.viewHeight*0.33 + 45, self.viewWidth*0.4, self.viewHeight*0.4);
        }
        UIFont *font = [UIFont fontWithName:FONTNAME size:fontSize];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.minimumLineHeight = 1.22 * font.lineHeight;
//        paragraphStyle.maximumLineHeight = 5 * font.lineHeight;
        NSDictionary *attributes = @{NSFontAttributeName:font,
                                     NSForegroundColorAttributeName:[UIColor whiteColor],
                                     NSBackgroundColorAttributeName:[UIColor clearColor],
                                     NSParagraphStyleAttributeName:paragraphStyle,
                                     };
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:THIRD_LINE_TEXT attributes:attributes];
        [attStr addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, attStr.length)];
        _valuePropText3 = [[TTTAttributedLabel alloc] initWithFrame:frame];
        _valuePropText3.lineSpacing = 10;
        _valuePropText3.textColor = [UIColor whiteColor];
        _valuePropText3.textAlignment = NSTextAlignmentLeft;
        _valuePropText3.numberOfLines = 2;
        _valuePropText3.lineHeightMultiple = 20;
        _valuePropText3.shadowColor = [UIColor colorWithWhite:0 alpha:0.3];
        _valuePropText3.shadowRadius = 1;
        _valuePropText3.shadowOffset = CGSizeMake(0, 1);
        _valuePropText3.text = attStr;
        _valuePropText3.alpha = 0;
    }
    return _valuePropText3;
}

/**
 * Lazily add three lines
 * about Dani
 */

- (void) addDesciptionAboutDani {
    [self addSubview:[self firstLine]];
    [self addSubview:[self secondLine]];
    [self addSubview:[self thirdLine]];
}

#pragma mark - public method
-(id)init {
    self.viewWidth = [UIScreen mainScreen].bounds.size.width;
    self.viewHeight = [UIScreen mainScreen].bounds.size.height;
    _animationStatus = None;
    self = [super initWithFrame:CGRectMake(0, 0, self.viewWidth, self.viewHeight)];
    if (self) {
        [self addSubview:[self valueBackgroundImageView]];
        [self addSubview:[self valuePropIcon]];
        [self addDesciptionAboutDani];
    }
    return self;
}

/**
 * Show the view in animation
 */
-(void)showView {
    if (_animationStatus != None)
        _animationStatus = Running;
    
    if ([Device isIphone5] )
        _valuePropIcon.frame = CGRectMake(-self.viewWidth *2, self.viewHeight * 0.4, self.viewWidth *0.33, self.viewHeight *0.22);
    else if ([Device isIphone4])
        _valuePropIcon.frame = CGRectMake(- self.viewWidth *2, self.viewHeight * 0.4, self.viewWidth *0.3, self.viewHeight *0.22);
    else
        _valuePropIcon.frame = CGRectMake(-self.viewWidth *2, self.viewHeight*0.447, 145, 145);
    
    [UIView animateWithDuration:1 delay:0.0f options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
        
        if ([Device isIphone5] )
            _valuePropIcon.frame = CGRectMake(self.viewWidth *0.07, self.viewHeight * 0.4, self.viewWidth *0.33, self.viewHeight *0.22);
        
        else if ([Device isIphone4])
            _valuePropIcon.frame = CGRectMake(self.viewWidth *0.07, self.viewHeight * 0.4, self.viewWidth *0.3, self.viewHeight *0.22);
        else
            _valuePropIcon.frame = CGRectMake(self.viewWidth *0.07, self.viewHeight*0.447, 145, 145);
        
        _valuePropIcon.alpha = 1;
    } completion:^(BOOL finished) {
        if (finished) {
            [UIView animateWithDuration:0.8 delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^{
                _valuePropText1.alpha = 1;
            }completion:^(BOOL finished) {
                if (finished) {
                    [UIView animateWithDuration:0.8 delay:0.0f options:UIViewAnimationOptionAllowAnimatedContent animations:^{
                        _valuePropText2.alpha = 1;
                    }completion:^(BOOL finished) {
                        if (finished) {
                            [UIView animateWithDuration:1.0 delay:0.0f options:UIViewAnimationOptionTransitionCurlUp animations:^{
                                _valuePropText3.alpha = 1;
                            }completion:^(BOOL finished) {
                                if (finished) {
                                    if (_animationStatus == None) {
                                        [self performSelector:@selector(goToNextPage) withObject:nil afterDelay:1.0f];

                                    }
                                    _animationStatus = Done;
                                }
                            }];
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
 * Hide the view in animation
 */
-(void)hideView {
    self.valuePropText1.alpha = 0;
    self.valuePropText2.alpha = 0;
    self.valuePropText3.alpha = 0;
    self.valuePropIcon.alpha = 0;
    
    [self.valuePropText1.layer removeAllAnimations];
    [self.valuePropText2.layer removeAllAnimations];
    [self.valuePropText3.layer removeAllAnimations];
    [self.valuePropIcon.layer removeAllAnimations];
}

/**
 * Stop animation and show detail view
 */
-(void)stopAnmationAndShowView {
    
    [self.valuePropText1.layer removeAllAnimations];
    [self.valuePropText2.layer removeAllAnimations];
    [self.valuePropText3.layer removeAllAnimations];
    [self.valuePropIcon.layer removeAllAnimations];
    
    self.valuePropText1.alpha = 1;
    self.valuePropText2.alpha = 1;
    self.valuePropText3.alpha = 1;
    self.valuePropIcon.alpha = 1;
}

@end
