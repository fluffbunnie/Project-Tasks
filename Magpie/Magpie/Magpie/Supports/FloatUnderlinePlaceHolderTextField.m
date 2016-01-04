//
//  FloatUnderlinePlaceHolderTextField.m
//  Magpie
//
//  Created by minh thao nguyen on 7/20/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import "FloatUnderlinePlaceHolderTextField.h"
#import "FontColor.h"

@interface FloatUnderlinePlaceHolderTextField()

@property (nonatomic, strong) UIView *viewUnderline;
@property (nonatomic, strong) UILabel *floatPlaceholder;
@property (nonatomic, strong) NSString *placeHolderStr;
@end

@implementation FloatUnderlinePlaceHolderTextField

/**
 * init view backgroud textfield
 * @return view background
 */
-(UIView *)viewUnderline{
    if (_viewUnderline == nil) {
        CGRect frame = CGRectMake(0, self.frame.size.height - 7, self.frame.size.width, 1);
        _viewUnderline = [[UIView alloc] initWithFrame:frame];
        _viewUnderline.backgroundColor = [UIColor whiteColor];
        _viewUnderline.userInteractionEnabled = NO;
    }
    return _viewUnderline;
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
        frame.origin.y = -12;
        frame.origin.x = 0;
        frame.size.height = 16;
        frame.size.width += 4;
        _floatPlaceholder.frame = frame;
        
        _floatPlaceholder.textAlignment = NSTextAlignmentCenter;
        _floatPlaceholder.textColor = [FontColor tableSeparatorColor];
        _floatPlaceholder.alpha = 0.0;
    }
}

#pragma mark - public method
-(id)initWithPlaceHolder:(NSString *)placeholder andFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.returnKeyType = UIReturnKeyDone;
        self.placeholder = placeholder;
        self.placeHolderStr = placeholder;
        
        self.layer.masksToBounds = NO;
        self.font = [UIFont fontWithName:@"AvenirNext-Regular" size:18];
        self.textColor = [UIColor whiteColor];
        self.autocorrectionType = UITextAutocorrectionTypeNo;
        
        [self addSubview:[self viewUnderline]];
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
 * Update float place holder
 */
- (void) updateFloatPlaceholder{
    BOOL firstResponder = self.isFirstResponder;
    
    if (firstResponder) {
        self.placeholder = @"";
        [self showFloatPlaceholder:YES];
    } else {
        self.placeholder = self.placeHolderStr;
        if (!self.text || self.text.length == 0) [self hideFloatingLabel:YES];
        else [self showFloatPlaceholder:YES];
    }
}


/**
 * draw placeholder in rect
 * @param CGRect
 */
- (void)drawPlaceholderInRect:(CGRect)rect {
    [self.placeholder drawInRect:rect withAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor], NSFontAttributeName:[UIFont fontWithName:@"AvenirNext-Regular" size:19]}];
}

/**
 * Override the textRectForBounds method to define padding text content
 */
- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectMake(bounds.origin.x + 2,
                      bounds.origin.y + 10,
                      bounds.size.width - 4,
                      bounds.size.height - 10);
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
    [self updateFloatPlaceholder];
}
@end
