//
//  FloatPlaceHolderTextField.m
//  Magpie
//
//  Created by minh thao nguyen on 7/20/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import "FloatPlaceholderTextField.h"
#import "FontColor.h"

@interface FloatPlaceholderTextField()

@property (nonatomic, strong) UIView *viewBackground;
@property (nonatomic, strong) UILabel *floatPlaceholder;
@property (nonatomic, strong) NSString *placeHolderStr;
@end

@implementation FloatPlaceholderTextField

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
        frame.origin.x = self.frame.size.height/2;
        frame.size.height = 16;
        frame.size.width += 10;
        _floatPlaceholder.frame = frame;
        
        _floatPlaceholder.textAlignment = NSTextAlignmentCenter;
        _floatPlaceholder.textColor = [FontColor themeColor];
        _floatPlaceholder.backgroundColor = [UIColor whiteColor];
        _floatPlaceholder.alpha = 0.0;
    }
}

#pragma mark - public method
-(id)initWithPlaceHolder:(NSString *)placeholder andFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.returnKeyType = UIReturnKeyDone;
        self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholder attributes:@{NSForegroundColorAttributeName:[FontColor defaultBackgroundColor],
                                                                                                                            NSFontAttributeName:[UIFont fontWithName:@"AvenirNext-Regular" size:14]}];
        
        self.layer.masksToBounds = NO;
        self.font = [UIFont fontWithName:@"AvenirNext-Regular" size:14];
        self.textColor = [FontColor titleColor];
        
        self.placeHolderStr = placeholder;
        
        [self addSubview:[self viewBackground]];
        [self createFloatPlaceholder:placeholder];
        [self addSubview:self.floatPlaceholder];
    }
    return self;
}

/**
 * Show float place holder
 * @param animated
 */
- (void)showFloatPlaceholder:(BOOL)animated {
    if(_floatPlaceholder.alpha == 1.0) return;
    

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
    else showBlock();
}

/**
 * Hide float place holder
 * @param animated
 */
- (void)hideFloatingLabel:(BOOL)animated {
    if (_floatPlaceholder.alpha == 0.0) return;
    
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
    else hideBlock();
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
        self.floatPlaceholder.textColor = [FontColor themeColor];
        [self showFloatPlaceholder:YES];
    }
    else {
        if (!self.text || self.text.length == 0) {
            if (!self.attributedPlaceholder || self.attributedPlaceholder.length==0)
                self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.placeHolderStr attributes:@{NSForegroundColorAttributeName:[FontColor defaultBackgroundColor],
                                                                                                                 NSFontAttributeName:[UIFont fontWithName:@"AvenirNext-Regular" size:14]}];
            [self hideFloatingLabel:YES];
        } else {
            self.floatPlaceholder.textColor = [FontColor descriptionColor];
            [self showFloatPlaceholder:YES];
        }
    }
}

/**
 * Update view background
 */
- (void)updateViewBackground{
    if (self.isFirstResponder)
        self.viewBackground.layer.borderColor = [[FontColor themeColor] CGColor];
    else if (self.enabled)
        self.viewBackground.layer.borderColor = [[FontColor defaultBackgroundColor] CGColor];
    else self.viewBackground.layer.borderColor = [[FontColor themeColor] CGColor];
}

/**
 * Override the textRectForBounds method to define padding text content
 */
- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectMake(bounds.origin.x + self.frame.size.height/2 + 5,
                      bounds.origin.y + 8,
                      bounds.size.width - self.frame.size.height - 10,
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
- (void)layoutSubviews {
    [super layoutSubviews];
    [self updateView];
}
@end
