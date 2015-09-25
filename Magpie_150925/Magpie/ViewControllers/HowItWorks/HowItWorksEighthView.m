//
//  ValuePropThirdView.m
//  Magpie
//
//  Created by minh thao nguyen on 7/29/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import "HowItWorksEighthView.h"
#import "Device.h"
#import "TTTAttributedLabel.h"
#import "FontColor.h"

static NSString * VALUE_LABEL_TEXT_5 = @"They communicated on Magpie to get more details straightened out";
static NSString * VALUE_CHAT_ROW_1 = @"Chat_Row_1";
static NSString * VALUE_CHAT_ROW_2 = @"Chat_Row_2";
static NSString * VALUE_CHAT_ROW_3 = @"Chat_Row_3";

static NSString * VALUE_BACKGROUND_SCREEN_2 = @"Background_Screen_2";

@interface HowItWorksEighthView()

@property (nonatomic, assign) CGFloat viewWidth;
@property (nonatomic, assign) CGFloat viewHeight;

@property (nonatomic, strong) UIImageView *valueBackgroundScreen;

@property (nonatomic, strong) UIImageView *chatRow1Image;
@property (nonatomic, strong) UIImageView *chatRow2Image;
@property (nonatomic, strong) UIImageView *chatRow3Image;

@property (nonatomic, strong) TTTAttributedLabel *valueLabelText5;


@end

@implementation HowItWorksEighthView

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

#pragma mark - initiation screen 5

/**
 * Lazily init the value prop text
 * @return TTTAttributedLabel
 */

-(TTTAttributedLabel *)valueTitleText5 {
    if (_valueLabelText5 == nil) {
        CGRect frame = CGRectMake((self.viewWidth - 280)/2, 25, 280, 55);
        _valueLabelText5 = [[TTTAttributedLabel alloc] initWithFrame:frame];
        _valueLabelText5.textColor = [FontColor backgroundOverlayColor];
        _valueLabelText5.font = [UIFont fontWithName:@"AvenirNext-Medium" size:17];
        _valueLabelText5.lineSpacing = 5;
        _valueLabelText5.numberOfLines = 0;
        _valueLabelText5.textAlignment = NSTextAlignmentCenter;
        _valueLabelText5.alpha = 0;
        _valueLabelText5.text = VALUE_LABEL_TEXT_5;
    }
    return _valueLabelText5;
}

/**
 * Lazily init the value prop blur image view
 * @return UIImageView
 */
-(UIImageView *)valueChatRow1Image {
    if (_chatRow1Image == nil) {
        CGFloat width = self.viewWidth * 0.8;
        CGFloat height = width/294.5 * 55.0;
        CGRect frame = CGRectMake(0.05 * self.viewWidth, CGRectGetMaxY(self.valueLabelText5.frame) + 40, width, height);
        
        _chatRow1Image = [[UIImageView alloc] initWithFrame:frame];
        _chatRow1Image.contentMode = UIViewContentModeScaleAspectFill;
        _chatRow1Image.image = [UIImage imageNamed:VALUE_CHAT_ROW_1];
        _chatRow1Image.backgroundColor = [UIColor clearColor];
        _chatRow1Image.alpha = 0;
    }
    return _chatRow1Image;
    
}

/**
 * Lazily init the value prop blur image view
 * @return UIImageView
 */
-(UIImageView *)valueChatRow2Image {
    if (_chatRow2Image == nil) {
        CGFloat width = self.viewWidth * 0.8 * (272.0/294.5);
        CGFloat height = width/272.0 * 85.0;
        CGRect frame = CGRectMake(self.viewWidth * 0.95 - width, CGRectGetMaxY(self.chatRow1Image.frame) + 20, width, height);
        _chatRow2Image = [[UIImageView alloc] initWithFrame:frame];
        _chatRow2Image.contentMode = UIViewContentModeScaleAspectFill;
        _chatRow2Image.image = [UIImage imageNamed:VALUE_CHAT_ROW_2];
        _chatRow2Image.backgroundColor = [UIColor clearColor];
        _chatRow2Image.alpha = 0;
    }
    return _chatRow2Image;
    
}

/**
 * Lazily init the value prop blur image view
 * @return UIImageView
 */
-(UIImageView *)valueChatRow3Image {
    if (_chatRow3Image == nil) {
        CGFloat width = self.viewWidth * 0.8;
        CGFloat height = width/294.5 * 55.0;
        CGRect frame = CGRectMake(0.05 * self.viewWidth, CGRectGetMaxY(self.chatRow2Image.frame) + 20, width, height);
        
        _chatRow3Image = [[UIImageView alloc] initWithFrame:frame];
        _chatRow3Image.contentMode = UIViewContentModeScaleAspectFill;
        _chatRow3Image.image = [UIImage imageNamed:VALUE_CHAT_ROW_3];
        _chatRow3Image.backgroundColor = [UIColor clearColor];
        _chatRow3Image.alpha = 0;
    }
    return _chatRow3Image;
    
}

// initialize screen 5
-(void) initScreen5 {
    [self addSubview:[self valueTitleText5]];
    [self addSubview:[self valueChatRow1Image]];
    [self addSubview:[self valueChatRow2Image]];
    [self addSubview:[self valueChatRow3Image]];
}

#pragma mark - public method
-(id)init {
    self.viewWidth = [UIScreen mainScreen].bounds.size.width;
    self.viewHeight = [UIScreen mainScreen].bounds.size.height;
    _animationStatus = None ;
    self = [super initWithFrame:CGRectMake(7 * self.viewWidth, 0, self.viewWidth, self.viewHeight)];
    if (self) {
        [self addSubview:[self valueBackgroundImageView]];
        [self initScreen5];

    }
    return self;
}

/**
 * show the view5 in animation
 */

-(void) showView {
    if (_animationStatus != None)
        _animationStatus = Running;
    [UIView animateWithDuration:1.0f delay:0.0f options:UIViewAnimationOptionTransitionFlipFromTop animations:^{
        _valueLabelText5.alpha =1;
        _chatRow1Image.alpha = 1;
    } completion:^(BOOL finished) {
        if (finished) {
            [UIView animateWithDuration:1.0f delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^{
                _chatRow2Image.alpha = 1;
            } completion:^(BOOL finished) {
                if (finished) [UIView animateWithDuration:1.0f delay:0.5f options:UIViewAnimationOptionCurveLinear animations:^{
                    _chatRow3Image.alpha = 1;
                } completion:^(BOOL finished) {
                    if (_animationStatus == None) {
//                        [_howItWorksViewDelegate gotoNextPage];
                        [self performSelector:@selector(goToNextPage) withObject:nil afterDelay:1.0f];
                        
                    }
                    _animationStatus = Done;
//                    if (finished) [_howItWorksViewDelegate gotoNextPage];
                }];
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
    self.valueLabelText5.alpha = 0;
    self.chatRow1Image.alpha = 0;
    self.chatRow2Image.alpha = 0;
    self.chatRow3Image.alpha = 0;
    [self.valueLabelText5.layer removeAllAnimations];
    [self.chatRow1Image.layer removeAllAnimations];
    [self.chatRow2Image.layer removeAllAnimations];
    [self.chatRow3Image.layer removeAllAnimations];

}

/**
 * Hide the view and stop animation
 */
-(void)stopAnmationAndShowView {
    [self.valueLabelText5.layer removeAllAnimations];
    [self.chatRow1Image.layer removeAllAnimations];
    [self.chatRow2Image.layer removeAllAnimations];
    [self.chatRow3Image.layer removeAllAnimations];
    
    self.valueLabelText5.alpha = 1;
    self.chatRow1Image.alpha = 1;
    self.chatRow2Image.alpha = 1;
    self.chatRow3Image.alpha = 1;

}

@end
