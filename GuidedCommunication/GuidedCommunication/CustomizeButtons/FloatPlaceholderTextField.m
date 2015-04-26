//
//  RadioButton.m
//  GuidedCommunication
//
//  Created by Quynh Cao on 4/5/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import "FloatPlaceholderTexField.h"
#import "FontColor.h"

@interface FloatPlaceholderTexField()

@property (nonatomic, strong) UIView *viewBackground;
@property (nonatomic, strong) UILabel *floatPlaceholder;
@property (nonatomic, strong) NSString * placeHolderStr;
@end

@implementation FloatPlaceholderTexField

-(id)initWithPlaceHolder:(NSString *)placeholder andFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setPlaceholder:placeholder];
        [self setFont:[UIFont fontWithName:@"AvenirNext-Regular" size:14]];
        self.layer.masksToBounds = NO;
        
        self.placeHolderStr = placeholder;
        
        [self addSubview:[self viewBackground]];
        [self createFloatPlaceholder:placeholder];
        [self addSubview:self.floatPlaceholder];
    }
    return self;
}

/**
 * init view backgroud textfield
 * @return view background
 */
-(UIView *)viewBackground{
    if (_viewBackground == nil) {
        CGRect frame = self.frame;
        frame.origin.x = 0;
        frame.origin.y = 0;
        _viewBackground = [[UIView alloc] initWithFrame:frame];
        _viewBackground.backgroundColor = [UIColor clearColor];
        _viewBackground.layer.borderWidth = 1;
        _viewBackground.layer.borderColor = [[FontColor defaultBackgroundColor] CGColor];
        _viewBackground.layer.cornerRadius = self.frame.size.height / 2.0;
        _viewBackground.userInteractionEnabled = NO;
    }
    return _viewBackground;
}

/**
 * create float placeholder
 */
-(void)createFloatPlaceholder:(NSString *)placeHolderStr {
    if (_floatPlaceholder == nil) {
        
        _floatPlaceholder = [[UILabel alloc] init];
        _floatPlaceholder.font = [UIFont fontWithName:@"AvenirNext-Regular" size:12];
        _floatPlaceholder.text = placeHolderStr;
        
        [_floatPlaceholder sizeToFit];
        CGRect frame = _floatPlaceholder.frame;
        frame.origin.y = -8;
        frame.origin.x = 25;
        frame.size.height = 16;
        frame.size.width += 10;
        _floatPlaceholder.frame = frame;
        
        _floatPlaceholder.textAlignment = NSTextAlignmentCenter;
        _floatPlaceholder.textColor = [FontColor themeColor];
        _floatPlaceholder.backgroundColor = [UIColor whiteColor];
        _floatPlaceholder.alpha = 0.0;
    }
}

/**
 * Show float place holder
 * @param animated
 */
- (void)showFloatPlaceholder:(BOOL)animated
{
    if(_floatPlaceholder.alpha == 1.0)
        return;
    void (^showBlock)() = ^{
        _floatPlaceholder.alpha = 1.0;
    };
    
    if (animated) {
        [UIView animateWithDuration:0.2
                              delay:0.0f
                            options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseOut
                         animations:showBlock
                         completion:nil];
    }
    else {
        showBlock();
    }
}

/**
 * Hide float place holder
 * @param animated
 */
- (void)hideFloatingLabel:(BOOL)animated
{
    if (_floatPlaceholder.alpha == 0.0)
        return;
    void (^hideBlock)() = ^{
        _floatPlaceholder.alpha = 0.0;
    };
    
    if (animated) {
        [UIView animateWithDuration:0.2
                              delay:0.0f
                            options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseOut
                         animations:hideBlock
                         completion:nil];
    }
    else {
        hideBlock();
    }
}

/**
 * Update color, visible elements
 */
- (void) updateView{
    [self updateFloatPlaceholder];
    [self updateViewBackground];
}

/**
 * Update float place holder
 */
- (void) updateFloatPlaceholder{
    BOOL firstResponder = self.isFirstResponder;
    
    if (firstResponder) {
        if (self.placeholder.length>0)
            self.placeholder = @"";
        [self updateColorFloatPlaceHolder:[FontColor themeColor]];
        [self showFloatPlaceholder:YES];
    }
    else {
        if (!self.text || self.text.length == 0) {
            if (!self.placeholder || self.placeholder.length==0)
                self.placeholder = self.placeHolderStr;
            [self hideFloatingLabel:YES];
        }
        else{
            [self updateColorFloatPlaceHolder:[FontColor descriptionColor]];
            [self showFloatPlaceholder:YES];
        }
    }
}

/**
 * Update color placehodler if change
 */

-(void) updateColorFloatPlaceHolder: (UIColor *) newColor{
    UIColor * oldColor = _floatPlaceholder.textColor;
    
    CGFloat redOld = 0.0, greenOld = 0.0, blueOld = 0.0, alphaOld =0.0;
    [oldColor getRed:&redOld green:&greenOld blue:&blueOld alpha:&alphaOld];
    
    CGFloat redNew = 0.0, greenNew = 0.0, blueNew = 0.0, alphaNew =0.0;
    [newColor getRed:&redNew green:&greenNew blue:&blueNew alpha:&alphaNew];
    
    if (redOld != redNew) {
        _floatPlaceholder.textColor = newColor;
        return;
    }
    if (greenOld != greenNew) {
        _floatPlaceholder.textColor = newColor;
        return;
    }
    if (blueOld != blueNew) {
        _floatPlaceholder.textColor = newColor;
        return;
    }
}

/**
 * Update view background
 */
- (void) updateViewBackground{
    BOOL firstResponder = self.isFirstResponder;
    if (firstResponder)
        self.viewBackground.layer.borderColor = [[FontColor themeColor] CGColor];
    else if (self.enabled)
        self.viewBackground.layer.borderColor = [[FontColor defaultBackgroundColor] CGColor];
    else
        self.viewBackground.layer.borderColor = [[FontColor themeColor] CGColor];
}

/**
 * Override the textRectForBounds method to define padding text content
 */
- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectMake(bounds.origin.x + 25,
                      bounds.origin.y + 8,
                      bounds.size.width - 50,
                      bounds.size.height - 16);
}

/**
 * Override the textRectForBounds menthod to define padding text editting content
 */
- (CGRect)editingRectForBounds:(CGRect)bounds {
    return [self textRectForBounds:bounds];
}

/**
 * Override the layoutSubviews menthod to call update views
 */
- (void)layoutSubviews
{
    [super layoutSubviews];
    [self updateView];
}
@end
