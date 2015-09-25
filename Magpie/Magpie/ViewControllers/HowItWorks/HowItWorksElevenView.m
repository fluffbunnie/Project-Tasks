//
//  ValuePropThirdView.m
//  Magpie
//
//  Created by Quynh Cao on 7/29/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import "HowItWorksElevenView.h"
#import "Device.h"
#import "TTTAttributedLabel.h"
#import "FontColor.h"

static NSString * VALUE_LABEL_TEXT = @"Now it’s your turn to join Magpie and start traveling for free!";

static NSString * VALUE_BUTTON_TEXT = @"See more testinomials";

static NSString * VALUE_LOGO_MAGPIE_IMAGE = @"magpie_logo_with_name";

@interface HowItWorksElevenView()

@property (nonatomic, assign) CGFloat viewWidth;
@property (nonatomic, assign) CGFloat viewHeight;

@property (nonatomic, strong) UIImageView *valueMagpieLogoImage;
@property (nonatomic, strong) UIButton *valueTestinomialsButton;
@property (nonatomic, strong) TTTAttributedLabel *valueLabelText;

@end

@implementation HowItWorksElevenView

#pragma mark - initiation screen 1

/**
 * Lazily init the value prop text
 * @return TTTAttributedLabel
 */

-(TTTAttributedLabel *)valueTitleText {
    if (_valueLabelText == nil) {
        CGRect frame = CGRectMake(self.viewWidth *0.1, self.viewHeight*0.41, self.viewWidth*0.8, self.viewHeight*0.09);
        int fontSize = 16;
        
        if ([Device isIphone5])  {
            frame = CGRectMake(self.viewWidth *0.1, self.viewHeight*0.41, self.viewWidth*0.8, self.viewHeight*0.09);
            fontSize = 14;
        }
        
        if ([Device isIphone4] )  {
            frame = CGRectMake(self.viewWidth *0.1, self.viewHeight*0.48, self.viewWidth*0.8, self.viewHeight*0.09);
            fontSize = 12;
        }
        
        UIColor *textColor = [UIColor colorWithRed:222.0f/255 green:80.0f/255 blue:87.0f/255 alpha:100.0f];

        UIFont *font = [UIFont fontWithName:@"AvenirNext-Medium" size:fontSize];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.minimumLineHeight = 1.3 * font.lineHeight;
        [paragraphStyle setAlignment:NSTextAlignmentCenter];
        NSDictionary *attributes = @{NSFontAttributeName:font,
                                     NSForegroundColorAttributeName:[UIColor clearColor],
                                     NSBackgroundColorAttributeName:[UIColor clearColor],
                                     NSParagraphStyleAttributeName:paragraphStyle,
                                     };
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:VALUE_LABEL_TEXT attributes:attributes];
        [attStr addAttribute:NSForegroundColorAttributeName value:textColor range:NSMakeRange(0, attStr.length)];
        
        _valueLabelText = [[TTTAttributedLabel alloc] initWithFrame:frame];
        _valueLabelText.lineSpacing = 10;
        _valueLabelText.numberOfLines = 2;
        _valueLabelText.lineHeightMultiple = 20;
        _valueLabelText.shadowRadius = 1;
        _valueLabelText.shadowOffset = CGSizeMake(0, 1);
        _valueLabelText.text = attStr;
        _valueLabelText.alpha = 0;
    }
    return _valueLabelText;
}

/**
 * Lazily init the value Logo Mapge image
 * @return UIImageView
 */
-(UIImageView *)valueMagpieLogoImage{
    if (_valueMagpieLogoImage == nil) {
        
        CGRect frame4;
        if ([Device isIphone5])  frame4 = CGRectMake(self.viewWidth * 0.4, self.viewHeight*0.179, 70, 90);
        else if ([Device isIphone4]) frame4 = CGRectMake(self.viewWidth * 0.4, self.viewHeight*0.179, 70, 90);
        else frame4 = CGRectMake(self.viewWidth * 0.4, self.viewHeight * 0.16, 70, 90);// 150, 225);
        _valueMagpieLogoImage = [[UIImageView alloc] initWithFrame:frame4];
        _valueMagpieLogoImage.contentMode = UIViewContentModeScaleAspectFill;
        _valueMagpieLogoImage.backgroundColor = [UIColor clearColor];
        _valueMagpieLogoImage.image = [UIImage imageNamed:VALUE_LOGO_MAGPIE_IMAGE];
        _valueMagpieLogoImage.alpha = 0.0f;
    }
    return _valueMagpieLogoImage;
}

/**
 * Lazily init the See more testinomials button
 * @return UIButton
 */
-(UIButton *)testinomialsButton {
    if (_valueTestinomialsButton == nil) {
        CGRect frame = CGRectMake((_viewWidth - 250)/2, _viewHeight * 0.62, 250, 50);
        if ([Device isIphone4]) frame = CGRectMake(25, _viewHeight * 0.7, _viewWidth - 50, 50);
        _valueTestinomialsButton = [[UIButton alloc] initWithFrame:frame];
        _valueTestinomialsButton.titleLabel.font = [UIFont fontWithName:@"AvenirNext-Medium" size:15];
        _valueTestinomialsButton.layer.cornerRadius = 25;
        _valueTestinomialsButton.layer.masksToBounds = YES;
        _valueTestinomialsButton.alpha = 0;
//        if ([Device isIphone4]) [_valueTestinomialsButton setTitle:@"Import your place" forState:UIControlStateNormal];
//        else
//            [_valueTestinomialsButton setTitle:@"Import" forState:UIControlStateNormal];
        [_valueTestinomialsButton setTitle:VALUE_BUTTON_TEXT forState:UIControlStateNormal];
        [_valueTestinomialsButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_valueTestinomialsButton setBackgroundImage:[FontColor imageWithColor:[FontColor themeColor]] forState:UIControlStateNormal];
        [_valueTestinomialsButton setBackgroundImage:[FontColor imageWithColor:[FontColor darkThemeColor]] forState:UIControlStateHighlighted];
        
        [_valueTestinomialsButton addTarget:self action:@selector(testinomialsButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _valueTestinomialsButton;
}

/**
 * testinomialsButtonClick
 * Go to the sign up code screen
 */
-(void)testinomialsButtonClick {
    [_howItWorksViewDelegate closeSlideShow];
}
#pragma mark Init screens
/**
 * Inititialize all screen
 */

#pragma mark - public method
-(id)init {
    self.viewWidth = [UIScreen mainScreen].bounds.size.width;
    self.viewHeight = [UIScreen mainScreen].bounds.size.height;
    self = [super initWithFrame:CGRectMake(self.viewWidth * 3, 0, self.viewWidth, self.viewHeight)];
    if (self) {
        [self addSubview:[self valueTitleText]];
        [self addSubview:[self valueMagpieLogoImage]];
        [self addSubview:[self testinomialsButton]];
    }
    return self;
}

/**
 * Show the view in animation
 */
-(void)showView {

    [UIView animateWithDuration:1.0f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        _valueMagpieLogoImage.alpha = 1;
    } completion:^(BOOL finished) {
            if (finished) {
                [UIView animateWithDuration:1.0f delay:0.0f options:UIViewAnimationOptionOverrideInheritedCurve animations:^{
                    _valueLabelText.alpha = 1;
                } completion:^(BOOL finished) {
                    if (finished) {
                        [UIView animateWithDuration:1.0f delay:0.0f options:UIViewAnimationOptionAllowAnimatedContent animations:^{
                            _valueTestinomialsButton.alpha = 1;
                        } completion:^(BOOL finished) {
                            if (finished) {
                                NSLog(@"Done with slide show");
//                                    [self.howItWorksViewDelegate repeatSlideshow];
//                                [_howItWorksViewDelegate showRepeatButton];
                            }
                        }];
                    }
                }];
            }
    }];
}

/**
 * Hide the view and animation
 */
-(void)hideView {
    //screen hide all
    self.valueLabelText.alpha = 0;
    self.valueMagpieLogoImage.alpha = 0;
    self.valueTestinomialsButton.alpha = 0;
    [self.valueLabelText.layer removeAllAnimations];
    [self.valueMagpieLogoImage.layer removeAllAnimations];
    [self.valueTestinomialsButton.layer removeAllAnimations];
}

@end
