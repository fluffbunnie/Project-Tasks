//
//  ValuePropFirstView.m
//  Magpie
//
//  Created by minh thao nguyen on 7/29/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import "HowItWorksFirstView.h"
#import "Device.h"
#import "TTTAttributedLabel.h"
#import "UIImage+ImageEffects.h"

static NSString * VALUE_PROP_ICON = @"Dani_Avatar_291";

static NSString * AVATAR1_IMAGE = @"avatar1";
static NSString * AVATAR2_IMAGE = @"avatar2";
static NSString * AVATAR3_IMAGE = @"avatar3";
static NSString * DOOR_IMAGE = @"Door_164";
static NSString * STICK_IMAGE = @"stick";

static NSString * FIRST_LINE_TEXT = @"Meet Dani";
static NSString * SECOND_LINE_TEXT = @"Female Founder";
static NSString * THIRD_LINE_TEXT = @"Became a happy Magpie since Fall, 2014";

static NSString * FIRST_INTRODUCE_LINE_TEXT = @"Through Magpie,";
static NSString * SECOND_INTRODUCE_LINE_TEXT = @"She hosted some cool travelers in her NewYork apartment";

static NSString * FONTNAME = @"AvenirNext-Medium";

static NSString * IMAGE_ANIMATION =@"airplane.png";//@"avion.png"; //@"carmodel.png" //@"air_cartoon.png";

@interface HowItWorksFirstView()

@property (nonatomic, assign) CGFloat viewWidth;
@property (nonatomic, assign) CGFloat viewHeight;
@property (nonatomic, strong) UIImageView *valuePropImageView;
@property (nonatomic, strong) UIImageView *valuePropIcon;

@property (nonatomic, strong) UIImageView *avatar1ImageView;
@property (nonatomic, strong) UIImageView *avatar2ImageView;
@property (nonatomic, strong) UIImageView *avatar3ImageView;

@property (nonatomic, strong) UIImageView *doorImage;
@property (nonatomic, strong) UIImageView *stick;

@property (nonatomic, strong) TTTAttributedLabel *valuePropText1;
@property (nonatomic, strong) TTTAttributedLabel *valuePropText2;
@property (nonatomic, strong) TTTAttributedLabel *valuePropText3;

@property (nonatomic, strong) TTTAttributedLabel *valueIntroMagpieText1;
@property (nonatomic, strong) TTTAttributedLabel *valueIntroMagpieText2;

@end

@implementation HowItWorksFirstView
#pragma mark - initiation
/**
 * Lazily init the value prop image
 * @return UIImageView
 */
//-(UIImageView *)valuePropImageView {
//    if (_valuePropImageView == nil) {
//        _valuePropImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.viewWidth, self.viewHeight)];
//        _valuePropImageView.contentMode = UIViewContentModeScaleAspectFill;
//        _valuePropImageView.backgroundColor = [UIColor whiteColor];
//        _valuePropImageView.image = [UIImage imageNamed:Background_Screen_1];
//    }
//    return _valuePropImageView;
//}

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
        _valuePropIcon.alpha = 1;
    }
    return _valuePropIcon;
}

/**
 * Lazily init the value prop image
 * @return UIImageView
 */
-(void) addAvatarAndDoor {
    
    if (_avatar1ImageView == nil) {
        CGRect frame1 = CGRectMake(self.viewWidth * 0.3, self.viewHeight * 0.08, 71, 71);
        if ([Device isIphone4]) frame1 = CGRectMake(self.viewWidth * 0.3, self.viewHeight * 0.06, 52, 52);
        if ([Device isIphone5]) frame1 = CGRectMake(self.viewWidth * 0.3, self.viewHeight * 0.06, 64, 64);
        _avatar1ImageView = [[UIImageView alloc] initWithFrame:frame1];
        _avatar1ImageView.contentMode = UIViewContentModeScaleAspectFill;
        _avatar1ImageView.backgroundColor = [UIColor clearColor];
        _avatar1ImageView.image = [UIImage imageNamed:AVATAR1_IMAGE];
        _avatar1ImageView.alpha = 0;
    }
    
    if (_avatar2ImageView == nil) {
        CGRect frame2 =CGRectMake(self.viewWidth * 0.5, self.viewHeight * 0.15, 104, 104);
        if ([Device isIphone4]) frame2 = CGRectMake(self.viewWidth * 0.5, self.viewHeight * 0.14, 64, 64);
        if ([Device isIphone5]) frame2 = CGRectMake(self.viewWidth * 0.5, self.viewHeight * 0.14, 80, 80);
        _avatar2ImageView = [[UIImageView alloc] initWithFrame:frame2];
        _avatar2ImageView.contentMode = UIViewContentModeScaleAspectFill;
        _avatar2ImageView.backgroundColor = [UIColor clearColor];
        _avatar2ImageView.image = [UIImage imageNamed:AVATAR2_IMAGE];
        _avatar2ImageView.alpha = 0;
    }
    
    if (_avatar3ImageView == nil) {
        CGRect frame3 =CGRectMake(self.viewWidth * 0.2, self.viewHeight * 0.2, 86, 86);
        if ([Device isIphone4]) frame3 = CGRectMake(self.viewWidth * 0.2, self.viewHeight * 0.2, 58, 58);
        if ([Device isIphone5]) frame3 = CGRectMake(self.viewWidth * 0.2, self.viewHeight * 0.2, 68, 68);
        _avatar3ImageView = [[UIImageView alloc] initWithFrame:frame3];
        _avatar3ImageView.contentMode = UIViewContentModeScaleAspectFill;
        _avatar3ImageView.backgroundColor = [UIColor clearColor];
        _avatar3ImageView.image = [UIImage imageNamed:AVATAR3_IMAGE];
        _avatar3ImageView.alpha = 0;
    }
    
    if (_doorImage == nil) {
        CGRect frame4 =CGRectMake(self.viewWidth/2 -20, self.viewHeight-129, 82, 129);
        if ([Device isIphone4] || [Device isIphone5]) frame4 = CGRectMake(self.viewWidth*0.4, self.viewHeight-129, 82, 129);
        if ([Device isIphone6Plus])
            frame4 =CGRectMake(self.viewWidth/2 -20, self.viewHeight-170, 120, 190);
        _doorImage = [[UIImageView alloc] initWithFrame:frame4];
        _doorImage.contentMode = UIViewContentModeScaleAspectFill;
        _doorImage.backgroundColor = [UIColor clearColor];
        _doorImage.image = [UIImage imageNamed:DOOR_IMAGE];
        _doorImage.alpha = 0;
    }
    
    if (_stick == nil) {
        CGRect frame5 =CGRectMake(self.viewWidth/2 - 60, self.viewHeight - 237, 82, 130);
        
        if ([Device isIphone4]) frame5 = CGRectMake(self.viewWidth/2 - 70, self.viewHeight - 192, 65, 90);
        
        if ([Device isIphone5]) frame5 = CGRectMake(self.viewWidth/2 - 60, self.viewHeight - 230, 65, 140);
        
        if ([Device isIphone6Plus]) frame5 = CGRectMake(self.viewWidth/2 - 50, self.viewHeight - 280, 65, 140);
        
        _stick = [[UIImageView alloc] initWithFrame:frame5];
        _stick.contentMode = UIViewContentModeScaleAspectFill;
        _stick.backgroundColor = [UIColor clearColor];
        _stick.image = [UIImage imageNamed:STICK_IMAGE];
        _stick.alpha = 0;
    }
    
    [self addSubview:_avatar1ImageView];
    [self addSubview:_avatar2ImageView];
    [self addSubview:_avatar3ImageView];
    [self addSubview:_doorImage];
    [self addSubview:_stick];
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

/**
 * Lazily init the value prop text
 * @return TTTAttributedLabel
 */

-(TTTAttributedLabel *)introMagpieFirstLine {
    if (_valueIntroMagpieText1 == nil) {
        CGRect frame = CGRectMake(self.viewWidth *0.526, self.viewHeight*0.3, self.viewWidth*0.4, self.viewHeight*0.4);
        int fontSize = 14;
        if ([Device isIphone5])  {
            frame = CGRectMake(self.viewWidth *0.52, self.viewHeight*0.25, self.viewHeight*0.4, self.viewHeight*0.4);
        }
        
        if ([Device isIphone4] )  {
            frame = CGRectMake(self.viewWidth *0.52, self.viewHeight*0.25, self.viewHeight*0.4, self.viewHeight*0.4);
            fontSize = 12;
        }
        _valueIntroMagpieText1 = [[TTTAttributedLabel alloc] initWithFrame:frame];
        _valueIntroMagpieText1.lineSpacing = 10;
        _valueIntroMagpieText1.font = [UIFont fontWithName:FONTNAME size:fontSize];
        _valueIntroMagpieText1.textColor = [UIColor whiteColor];
        _valueIntroMagpieText1.textAlignment = NSTextAlignmentLeft;
        _valueIntroMagpieText1.shadowColor = [UIColor colorWithWhite:0 alpha:0.3];
        _valueIntroMagpieText1.shadowRadius = 1;
        _valueIntroMagpieText1.shadowOffset = CGSizeMake(0, 1);
        _valueIntroMagpieText1.text = FIRST_INTRODUCE_LINE_TEXT;
        _valueIntroMagpieText1.alpha = 0;
    }
    return _valueIntroMagpieText1;
}

/**
 * Lazily init the value prop text
 * @return TTTAttributedLabel	
 */

-(TTTAttributedLabel *)introMagpieSecondLine {
    if (_valueIntroMagpieText2 == nil) {
        CGRect frame;
        int fontSize = 14;
        if ([Device isIphone6Plus] )  {
            frame = CGRectMake(self.viewWidth *0.526, self.viewHeight*0.34 + 15, self.viewWidth*0.4, self.viewHeight*0.4);
        }
        else if ( [Device isIphone5])  {
            frame = CGRectMake(self.viewWidth *0.52, self.viewHeight*0.25 + 42, self.viewWidth*0.45, self.viewHeight*0.4);
        }
        else if ([Device isIphone4] )  {
            frame = CGRectMake(self.viewWidth *0.52, self.viewHeight*0.25 + 38, self.viewWidth*0.5, self.viewHeight*0.4);
            fontSize = 12;
        } else frame = CGRectMake(self.viewWidth *0.526, self.viewHeight*0.34 + 20, self.viewWidth*0.5, self.viewHeight*0.4);
        
        
        UIFont *font = [UIFont fontWithName:FONTNAME size:fontSize];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        //        paragraphStyle.paragraphSpacing = 5 * font.lineHeight;
        paragraphStyle.minimumLineHeight = 1.2 * font.lineHeight;
        NSDictionary *attributes = @{NSFontAttributeName:font,
                                     NSForegroundColorAttributeName:[UIColor whiteColor],
                                     NSBackgroundColorAttributeName:[UIColor clearColor],
                                     NSParagraphStyleAttributeName:paragraphStyle,
                                     };
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:SECOND_INTRODUCE_LINE_TEXT attributes:attributes];
        [attStr addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, attStr.length)];
        _valueIntroMagpieText2 = [[TTTAttributedLabel alloc] initWithFrame:frame];
        _valueIntroMagpieText2.lineSpacing = 10;
        _valueIntroMagpieText2.textColor = [UIColor whiteColor];
        _valueIntroMagpieText2.textAlignment = NSTextAlignmentLeft;
        _valueIntroMagpieText2.numberOfLines = 3;
        _valueIntroMagpieText2.lineHeightMultiple = 20;
        _valueIntroMagpieText2.shadowColor = [UIColor colorWithWhite:0 alpha:0.3];
        _valueIntroMagpieText2.shadowRadius = 1;
        _valueIntroMagpieText2.shadowOffset = CGSizeMake(0, 1);
        _valueIntroMagpieText2.text = attStr;
        _valueIntroMagpieText2.alpha = 0;
    }
    return _valueIntroMagpieText2;
}

/**
 * Lazily add three lines
 * about Magpie
 */

- (void) addIntroduceAboutMagpie {
    [self addSubview:[self introMagpieFirstLine]];
    [self addSubview:[self introMagpieSecondLine]];

}

#pragma mark - public method
-(id)init {
    self.viewWidth = [UIScreen mainScreen].bounds.size.width;
    self.viewHeight = [UIScreen mainScreen].bounds.size.height;
    self = [super initWithFrame:CGRectMake(0, 0, self.viewWidth, self.viewHeight)];
    if (self) {
//        [self addSubview:[self valuePropImageView]];
        [self addSubview:[self valuePropIcon]];
        [self addDesciptionAboutDani];
        [self addIntroduceAboutMagpie];
        [self addAvatarAndDoor];
    }
    return self;
}

/**
 * Show the view in animation
 */

- (void) addAnimationForScreen2 {
    [UIView animateWithDuration:1.0f animations:^{
        self.valuePropText3.alpha = 0;
        self.valuePropText2.alpha = 0;
        self.valuePropText1.alpha = 0;
    }completion:^(BOOL finished) {
        if (finished) {
            self.valueIntroMagpieText1.alpha = 1;
            self.valueIntroMagpieText2.alpha = 1;
            [self addAvatarsArray];
        }
    }];
}

/**
 * Show avatarArray in animation
 */

- (void) addAvatarsArray {
    
    if (_avatar1ImageView != nil) {
        if ([Device isIphone5]) _avatar1ImageView.frame = CGRectMake(- self.viewWidth * 1.3, - self.viewHeight * 1.8, 64, 64);
        else if ([Device isIphone4]) _avatar1ImageView.frame = CGRectMake(-self.viewWidth * 0.3, - self.viewHeight * 1.8, 52, 52);
        else _avatar1ImageView.frame = CGRectMake(-self.viewWidth * 1.3, - self.viewHeight * 1.8, 71, 71);
    }
    
    if (_avatar2ImageView != nil) {
        
        if ([Device isIphone5]) _avatar2ImageView.frame = CGRectMake(self.viewWidth * 0.5, - self.viewHeight * 1.8, 80, 80);
        else if ([Device isIphone4]) _avatar2ImageView.frame = CGRectMake(self.viewWidth * 0.5, - self.viewHeight * 1.8, 64, 64);
        else _avatar2ImageView.frame =CGRectMake(self.viewWidth * 0.5, - self.viewHeight * 1.5, 104, 104);
    }
    if (_avatar3ImageView != nil) {
        
        if ([Device isIphone5]) _avatar3ImageView.frame = CGRectMake(self.viewWidth * 0.2,  - self.viewHeight * 1.2, 68, 68);
        else if ([Device isIphone4]) _avatar3ImageView.frame = CGRectMake(self.viewWidth * 0.2,  - self.viewHeight * 1.2, 58, 58);
        else _avatar3ImageView.frame =CGRectMake(self.viewWidth * 0.2, - self.viewHeight * 1.2, 86, 86);
    }
    
    [UIView animateWithDuration:1.0 delay:0.0f options:UIViewAnimationOptionAllowAnimatedContent animations:^{
        
        if ([Device isIphone5]) _avatar1ImageView.frame = CGRectMake(self.viewWidth * 0.3, self.viewHeight * 0.06, 64, 64);
        else if ([Device isIphone4]) _avatar1ImageView.frame = CGRectMake(self.viewWidth * 0.3, self.viewHeight * 0.06, 52, 52);
        else _avatar1ImageView.frame = CGRectMake(self.viewWidth * 0.3, self.viewHeight * 0.08, 71, 71);
        _avatar1ImageView.alpha = 1;
    }completion:^(BOOL finished) {
        [UIView animateWithDuration:0.8 delay:0.0f options:UIViewAnimationOptionTransitionCurlUp animations:^{
            
            if ([Device isIphone5]) _avatar2ImageView.frame = CGRectMake(self.viewWidth * 0.5, self.viewHeight * 0.14, 80, 80);
            else if ([Device isIphone4]) _avatar2ImageView.frame = CGRectMake(self.viewWidth * 0.5, self.viewHeight * 0.14, 64, 64);
            else _avatar2ImageView.frame =CGRectMake(self.viewWidth * 0.5, self.viewHeight * 0.15, 104, 104);
            _avatar2ImageView.alpha = 1;
        }completion:^(BOOL finished) {
            [UIView animateWithDuration:0.8 delay:0.0f options:UIViewAnimationOptionOverrideInheritedDuration animations:^{
                
                if ([Device isIphone5]) _avatar3ImageView.frame = CGRectMake(self.viewWidth * 0.2, self.viewHeight * 0.2, 68, 68);
                else if ([Device isIphone4]) _avatar3ImageView.frame = CGRectMake(self.viewWidth * 0.2, self.viewHeight * 0.2, 58, 58);
                else _avatar3ImageView.frame =CGRectMake(self.viewWidth * 0.2, self.viewHeight * 0.2, 86, 86);
                _avatar3ImageView.alpha = 1;
            }completion:^(BOOL finished) {
                [UIView animateWithDuration:0.5 delay:0.0f options:UIViewAnimationOptionCurveLinear animations:^{
                    _stick.alpha = 1;
                }completion:^(BOOL finished) {
//                    [self animationLinePath];
                    [UIView animateWithDuration:0.8f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
                        _doorImage.alpha = 1;
                    }completion:^(BOOL finished) {
                        _valueIntroMagpieText1.alpha = 0;
                        _valueIntroMagpieText2.alpha = 0;
                        [self animationLinePath];
                        
                    }];
                    
                }];
            }];
        }];
        
    }];
}


-(void) animationLinePath{
    CALayer *flyImage = [CALayer layer];
    CAShapeLayer *centerline = [CAShapeLayer layer];
    
    flyImage.bounds =CGRectMake(0, 0, 44.0, 20.0);
    flyImage.position = CGPointMake(-_viewWidth, -_viewHeight);
    flyImage.contents = (id)([UIImage imageNamed:IMAGE_ANIMATION].CGImage);
    //    car.contents = (id)([UIImage imageNamed:@"plane-b.png"].CGImage);
    
    //Setup the path for the animation - this is very similar as the code the draw the line
    //instead of drawing to the graphics context, instead we draw lines on a CGPathRef
    CGMutablePathRef curvedPath = CGPathCreateMutable();
    if ([Device isIphone6Plus])
        CGPathMoveToPoint(curvedPath, NULL, _viewWidth *0.42 , _viewHeight * 0.55);

    else if ([Device isIphone5])
        CGPathMoveToPoint(curvedPath, NULL, _viewWidth *0.4 , _viewHeight * 0.55);

    else if ([Device isIphone6])
        CGPathMoveToPoint(curvedPath, NULL, _viewWidth *0.44 , _viewHeight * 0.6);
    else
        CGPathMoveToPoint(curvedPath, NULL, _viewWidth *0.35 , _viewHeight * 0.55);

    CGPathAddQuadCurveToPoint(curvedPath, NULL, _viewWidth *2.0, _viewHeight*0.4, _viewWidth * 0.8, -_viewHeight*0.4 );
    
    //Prepare the animation - we use keyframe animation for animations of this complexity
    CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    //Set some variables on the animation
    pathAnimation.calculationMode = kCAAnimationPaced;
    //We want the animation to persist - not so important in this case - but kept for clarity
    //If we animated something from left to right - and we wanted it to stay in the new position,
    //then we would need these parameters
    pathAnimation.fillMode = kCAFillModeForwards;
    pathAnimation.removedOnCompletion = YES;
    pathAnimation.duration = 6.0f;
    //Lets loop continuously for the demonstration
    pathAnimation.repeatCount = 0;
    
    //Now we have the path, we tell the animation we want to use this path - then we release the path
    pathAnimation.path = curvedPath;
    pathAnimation.rotationMode = kCAAnimationRotateAuto;
    
    centerline.path = curvedPath ;
    centerline.strokeColor = [UIColor whiteColor].CGColor;
    centerline.fillColor = [UIColor clearColor].CGColor;
    centerline.lineWidth = 3.0;
    centerline.lineDashPattern = [NSArray arrayWithObjects:[NSNumber numberWithInt:10], [NSNumber numberWithInt:8], nil];
    [self.layer addSublayer:centerline];
    [self.layer addSublayer:flyImage];
    [flyImage addAnimation:pathAnimation forKey:@"animationLinePath"];
    CGPathRelease(curvedPath);
//    }completion:^(BOOL finished) {
    
    [UIView animateWithDuration:1.8f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _doorImage.alpha = 0;
        _stick.alpha = 0;
    }completion:^(BOOL finished) {
        [_howItWorksViewDelegate gotoNextPage];
        [flyImage removeAllAnimations];
        [flyImage removeFromSuperlayer];
        [centerline removeFromSuperlayer];
    }];

//    }];
}
/**
 * Show the view in animation
 */
-(void)showView {
        // set frame for icon
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
                                [self addAnimationForScreen2];
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
 * Hide the view in animation
 */
-(void)hideView {
    self.valuePropText1.alpha = 0;
    self.valuePropText2.alpha = 0;
    self.valuePropText3.alpha = 0;
    self.valuePropIcon.alpha = 0;
    self.avatar1ImageView.alpha = 0;
    self.avatar2ImageView.alpha = 0;
    self.avatar3ImageView.alpha = 0;
    self.stick.alpha = 0;
    self.doorImage.alpha = 0;
    self.valueIntroMagpieText1.alpha = 0;
    self.valueIntroMagpieText2.alpha = 0;
    
    [self.valuePropText1.layer removeAllAnimations];
    [self.valuePropText2.layer removeAllAnimations];
    [self.valuePropText3.layer removeAllAnimations];
    [self.valuePropIcon.layer removeAllAnimations];
    [self.avatar1ImageView.layer removeAllAnimations];
    [self.avatar2ImageView.layer removeAllAnimations];
    [self.avatar3ImageView.layer removeAllAnimations];
    [self.stick.layer removeAllAnimations];
    [self.doorImage.layer removeAllAnimations];
    [self.valueIntroMagpieText1.layer removeAllAnimations];
    [self.valueIntroMagpieText2.layer removeAllAnimations];
}


@end
