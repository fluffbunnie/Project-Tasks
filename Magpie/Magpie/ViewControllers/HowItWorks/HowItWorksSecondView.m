//
//  ValuePropSecondView.m
//  Magpie
//
//  Created by minh thao nguyen on 7/29/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import "HowItWorksSecondView.h"
#import "Device.h"
#import "TTTAttributedLabel.h"
#import "UIImage+ImageEffects.h"

static NSString * VALUE_LABEL_TEXT_1 = @"Feburary 2015,";
static NSString * VALUE_LABEL_TEXT_2 = @"Dani came to San Francisco for a conference";

static NSString * VALUE_BACKGROUND_SCREEN = @"Background_Screen_2";
static NSString * VALUE_SANFRANCISCO = @"San_Francisco";
static NSString * VALUE_BOARD_IMAGE = @"board";
static NSString * VALUE_LABEL_IMAGE = @"Feburary_2015_label";
static NSString * ANIMATION_IMAGE = @"airplane.png";//@"avion.png"; //@"carmodel.png" //@"air_cartoon.png";

@interface HowItWorksSecondView()
@property (nonatomic, assign) CGFloat viewWidth;
@property (nonatomic, assign) CGFloat viewHeight;
@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) UIImageView *valueSFImageView;
@property (nonatomic, strong) UIImageView *valueBoardImageView;

@property (nonatomic, strong) TTTAttributedLabel *valueLabelText1;
@property (nonatomic, strong) TTTAttributedLabel *valueLabelText2;
@property (nonatomic, strong) CALayer *car;
@property (nonatomic, strong) CAShapeLayer *centerline;

@end

@implementation HowItWorksSecondView
#pragma mark - initiation
/**
 * Lazily init the value prop image
 * @return UIImageView
 */
-(UIImageView *)valueBackgroundImageView {
    if (_backgroundImageView == nil) {
        _backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.viewWidth, self.viewHeight)];
        _backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
        _backgroundImageView.backgroundColor = [UIColor whiteColor];
        _backgroundImageView.image = [UIImage imageNamed:VALUE_BACKGROUND_SCREEN];
    }
    return _backgroundImageView;
}

/**
 * Lazily init the value prop blur image view
 * @return UIImageView
 */
-(UIImageView *)valueSanFranImageView {
    if (_valueSFImageView == nil) {
        CGRect frame = CGRectMake(self.viewWidth * 0.4, self.viewHeight *0.05, 180, 40);
        if ([Device isIphone4] || [Device isIphone5])  {
            frame = CGRectMake(self.viewWidth * 0.5, self.viewHeight *0.04, 90, 20);
        }
        _valueSFImageView = [[UIImageView alloc] initWithFrame:frame];
        _valueSFImageView.contentMode = UIViewContentModeScaleAspectFill;
        _valueSFImageView.image = [UIImage imageNamed:VALUE_SANFRANCISCO];
        _valueSFImageView.backgroundColor = [UIColor whiteColor];
        _valueSFImageView.alpha = 0;
    }
    return _valueSFImageView;
}

/**
 * Lazily init the value prop icon
 * @return UIImageView
 */
-(UIImageView *)valueBoardIcon {
    if (_valueBoardImageView == nil) {
        CGRect frame;
        if ([Device isIphone4])  {
            frame = CGRectMake(self.viewWidth * 0.52, self.viewHeight *0.15, 100, 140);
        }
        else if ([Device isIphone5])  {
            frame = CGRectMake(self.viewWidth * 0.54, self.viewHeight *0.16, 120, 192);
        }
        else
            frame =CGRectMake(self.viewWidth * 0.55, self.viewHeight *0.165, 128, 209);
        _valueBoardImageView = [[UIImageView alloc] initWithFrame:frame];
        
        _valueBoardImageView.contentMode = UIViewContentModeScaleAspectFill;
        _valueBoardImageView.image = [UIImage imageNamed:VALUE_BOARD_IMAGE];
        _valueBoardImageView.backgroundColor = [UIColor whiteColor];
        _valueBoardImageView.alpha = 0;
    }
    return _valueBoardImageView;

}

/**
 * Lazily init the value prop text
 * @return TTTAttributedLabel
 */

-(TTTAttributedLabel *)storyFirstLine {
    if (_valueLabelText1 == nil) {
        CGRect frame = CGRectMake(self.viewWidth *0.05, self.viewHeight*0.3, self.viewWidth*0.5, self.viewHeight*0.4);
        int fontSize = 14;
        if ([Device isIphone4] || [Device isIphone5])  {
            frame = CGRectMake(self.viewWidth *0.08, self.viewHeight*0.29, self.viewHeight*0.5, self.viewHeight*0.4);
            fontSize = 12;
        }
        if ([Device isIphone6Plus])  {
            frame = CGRectMake(self.viewWidth *0.05, self.viewHeight*0.3, self.viewWidth*0.5, self.viewHeight*0.4);
            fontSize = 16;
        }
        
        _valueLabelText1 = [[TTTAttributedLabel alloc] initWithFrame:frame];
        _valueLabelText1.lineSpacing = 10;
        _valueLabelText1.font = [UIFont fontWithName:@"AvenirNext-Medium" size:fontSize];
        _valueLabelText1.textColor = [UIColor colorWithRed:118.0f/255 green:197.0f/255 blue:202.0f/255 alpha:1.0f];
        _valueLabelText1.textAlignment = NSTextAlignmentLeft;
        _valueLabelText1.shadowRadius = 1;
        _valueLabelText1.shadowOffset = CGSizeMake(0, 1);
        _valueLabelText1.text = VALUE_LABEL_TEXT_1;
        _valueLabelText1.alpha = 0;
    }
    return _valueLabelText1;
}

/**
 * Lazily init the value prop text
 * @return TTTAttributedLabel
 */

-(TTTAttributedLabel *)storySecondLine {
    if (_valueLabelText2 == nil) {
        CGRect frame = CGRectMake(self.viewWidth *0.05, self.viewHeight*0.34 + 5, self.viewWidth*0.5, self.viewHeight*0.4);
        int fontSize = 14;
        if ([Device isIphone4] || [Device isIphone5])  {
            
            frame = CGRectMake(self.viewWidth *0.08, self.viewHeight*0.34 + 8, self.viewWidth*0.5, self.viewHeight*0.4);
            fontSize = 12;
        }
        if ([Device isIphone6Plus])  {
            frame = CGRectMake(self.viewWidth *0.05, self.viewHeight*0.34 + 8, self.viewWidth*0.5, self.viewHeight*0.4);
            fontSize = 16;
        }
        UIColor *textColor = [UIColor colorWithRed:118.0f/255 green:197.0f/255 blue:202.0f/255 alpha:1.0f];
        
        UIFont *font = [UIFont fontWithName:@"AvenirNext-Medium" size:fontSize];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        //        paragraphStyle.paragraphSpacing = 5 * font.lineHeight;
        paragraphStyle.minimumLineHeight = 1.3 * font.lineHeight;
        NSDictionary *attributes = @{NSFontAttributeName:font,
                                     NSForegroundColorAttributeName:[UIColor whiteColor],
                                     NSBackgroundColorAttributeName:[UIColor clearColor],
                                     NSParagraphStyleAttributeName:paragraphStyle,
                                     };
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:VALUE_LABEL_TEXT_2 attributes:attributes];
        [attStr addAttribute:NSForegroundColorAttributeName value:textColor range:NSMakeRange(0, attStr.length)];
        
        _valueLabelText2 = [[TTTAttributedLabel alloc] initWithFrame:frame];
        _valueLabelText2.lineSpacing = 10;
        _valueLabelText2.textAlignment = NSTextAlignmentLeft;
        _valueLabelText2.numberOfLines = 2;
        _valueLabelText2.lineHeightMultiple = 20;
//        _valueLabelText2.shadowColor = [UIColor colorWithWhite:0 alpha:0.3];
        _valueLabelText2.shadowRadius = 1;
        _valueLabelText2.shadowOffset = CGSizeMake(0, 1);
        _valueLabelText2.text = attStr;
        _valueLabelText2.alpha = 0;
    }
    return _valueLabelText2;
}

// add linepath and car

- (void) addLinePathAndCar {
    
    _car = [CALayer layer];
    _car.bounds =CGRectMake(0, 0, 44.0, 20.0);
    _car.position = CGPointMake(-_viewWidth, -_viewHeight);
    _car.contents = (id)([UIImage imageNamed:ANIMATION_IMAGE].CGImage);
    //    car.contents = (id)([UIImage imageNamed:@"plane-b.png"].CGImage);

    //Setup the path for the animation - this is very similar as the code the draw the line
    //instead of drawing to the graphics context, instead we draw lines on a CGPathRef
    
    UIBezierPath *trackPath = [UIBezierPath bezierPath];
    [trackPath moveToPoint:CGPointMake(0, _viewHeight *0.5)];
    
    [trackPath addCurveToPoint:CGPointMake(_viewWidth * 0.56, _viewHeight *0.35)
                 controlPoint1:CGPointMake(_viewWidth * 0.35, _viewHeight * 0.34)
                 controlPoint2:CGPointMake(_viewWidth * 0.54, _viewHeight *0.36)];
    //				 controlPoint2:P(viewWidth * 0.5, viewHeight *0.352)];
    
    //    [trackPath moveToPoint:P(viewWidth *0.56, viewHeight *0.35)];
    
    [trackPath addCurveToPoint:CGPointMake(_viewWidth * 0.8, _viewHeight *0.1)
                 controlPoint1:CGPointMake(_viewWidth * 0.59, _viewHeight *0.349)
                 controlPoint2:CGPointMake(_viewWidth * 0.8, _viewHeight *0.3)];
    
//    CAShapeLayer *
    _centerline = [CAShapeLayer layer];
    _centerline.path = trackPath.CGPath ;
    _centerline.strokeColor = [UIColor colorWithRed:118.0f/255 green:197.0f/255 blue:202.0f/255 alpha:1.0f].CGColor;
    _centerline.fillColor = [UIColor clearColor].CGColor;
    _centerline.lineWidth = 3.0;
    _centerline.lineDashPattern = [NSArray arrayWithObjects:[NSNumber numberWithInt:6], [NSNumber numberWithInt:5], nil];
    [self.layer addSublayer:_centerline];
    [self.layer addSublayer:_car];
    _car.hidden = YES;
    _centerline.hidden = YES;
}

#pragma mark - public method
-(id)init {
    self.viewWidth = [UIScreen mainScreen].bounds.size.width;
    self.viewHeight = [UIScreen mainScreen].bounds.size.height;
    self = [super initWithFrame:CGRectMake(self.viewWidth, 0, self.viewWidth, self.viewHeight)];
    if (self) {
//        [self addSubview:[self valueBackgroundImageView]];
        //animation pathline
        [self addSubview:[self storyFirstLine]];
        [self addSubview:[self storySecondLine]];
        [self addSubview:[self valueSanFranImageView]];
        [self addLinePathAndCar];
        [self addSubview:[self valueBoardIcon]];
        
    }
    return self;
}

/**
 * Show the view in animation
 */
-(void)showView {
    
    //Setup the path for the animation - this is very similar as the code the draw the line
    //instead of drawing to the graphics context, instead we draw lines on a CGPathRef
    
    UIBezierPath *trackPath = [UIBezierPath bezierPath];
    [trackPath moveToPoint:CGPointMake(0, _viewHeight *0.5)];
    
    [trackPath addCurveToPoint:CGPointMake(_viewWidth * 0.56, _viewHeight *0.35)
                 controlPoint1:CGPointMake(_viewWidth * 0.35, _viewHeight * 0.34)
                 controlPoint2:CGPointMake(_viewWidth * 0.54, _viewHeight *0.36)];
    
    //    [trackPath moveToPoint:P(viewWidth *0.56, viewHeight *0.35)];
    
    [trackPath addCurveToPoint:CGPointMake(_viewWidth * 0.8, _viewHeight *0.1)
                 controlPoint1:CGPointMake(_viewWidth * 0.59, _viewHeight *0.349)
                 controlPoint2:CGPointMake(_viewWidth * 0.8, _viewHeight *0.3)];
    
    //Prepare the animation - we use keyframe animation for animations of this complexity
    CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    //Set some variables on the animation
    pathAnimation.calculationMode = kCAAnimationPaced;
    //We want the animation to persist - not so important in this case - but kept for clarity
    //If we animated something from left to right - and we wanted it to stay in the new position,
    //then we would need these parameters
    pathAnimation.fillMode = kCAFillModeForwards;
    pathAnimation.removedOnCompletion = YES;
    pathAnimation.duration = 3.0f;
    //Lets loop continuously for the demonstration
    pathAnimation.repeatCount = 0;
    
    //Now we have the path, we tell the animation we want to use this path - then we release the path
    pathAnimation.path = trackPath.CGPath;
    pathAnimation.rotationMode = kCAAnimationRotateAuto;
    [_car addAnimation:pathAnimation forKey:@"travepath"];
    _car.hidden = NO;
    _centerline.hidden = NO;
    
    [UIView animateWithDuration:0.5f delay:0.5f options:UIViewAnimationOptionShowHideTransitionViews animations:^{
        self.valueLabelText1.alpha = 1;
        self.valueLabelText2.alpha = 1;
    } completion:^(BOOL finished) {
        if (finished) {
            
            [UIView animateWithDuration:2.0f delay:1.5f options:UIViewAnimationOptionLayoutSubviews animations:^{
                self.valueSFImageView.alpha =1;
                self.valueBoardImageView.alpha = 1;
            } completion:^(BOOL finished) {
                if (finished) {
                    [_car removeAllAnimations];
                    _car.hidden = YES;
                    _centerline.hidden = YES;
                    [self.howItWorksViewDelegate gotoNextPage];
                }
            }];
        }
    }];
}

/**
 * Hide the view in animation
 */
-(void)hideView {
    self.valueBoardImageView.alpha = 0;
    self.valueLabelText1.alpha = 0;
    self.valueLabelText2.alpha = 0;
    self.valueSFImageView.alpha =0;
    self.valueBoardImageView.alpha = 0;

    
    [self.valueBoardImageView.layer removeAllAnimations];
    [self.valueLabelText1.layer removeAllAnimations];
    [self.valueLabelText2.layer removeAllAnimations];
    [self.valueSFImageView.layer removeAllAnimations];
    [self.valueBoardImageView.layer removeAllAnimations];
    
}

@end
