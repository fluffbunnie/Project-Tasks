//
//  RadioButton.m
//  GuidedCommunication
//
//  Created by Quynh Cao on 4/5/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import "FloatPlaceholderTextView.h"
#import "FontColor.h"

@interface FloatPlaceholderTextView()

@property (nonatomic, strong) UIView *viewBackground;
@property (nonatomic, strong) UILabel *floatPlaceholder;
@property (nonatomic, strong) NSString * placeHolderStr;
@end

@implementation FloatPlaceholderTextView

#pragma mark - initiation
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
        _viewBackground.layer.cornerRadius = 10;
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
        frame.origin.x = 10;
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
-(id)initWithPlaceHolder:(NSString *)placeholderString andFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.placeHolderStr = placeholderString;
        
        self.layer.masksToBounds = NO;
        self.font = [UIFont fontWithName:@"AvenirNext-Regular" size:15];
        self.text = placeholderString;
        self.textColor = [FontColor descriptionColor];
        self.textContainerInset = UIEdgeInsetsMake(15, 10, 15, 10);
        
        [self addSubview:[self viewBackground]];
        [self createFloatPlaceholder:placeholderString];
        [self addSubview:self.floatPlaceholder];
        [self setScrollEnabled:NO];
    }
    return self;
}

/**
 * Get the current typed text
 * @return text
 */
-(NSString *)getText {
    if (self.text.length > 0 && ![self.text isEqualToString:self.placeHolderStr])
        return self.text;
    else return nil;
}

#pragma mark - override methods
/**
 * Override the layoutSubviews menthod to call update views
 */
- (void)layoutSubviews {
    [super layoutSubviews];
    [self updateView];
}

/**
 * Override the set frame function
 * @param frame
 */
-(void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    self.viewBackground.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
}

#pragma mark - private helpers
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
    } else showBlock();
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
    } else hideBlock();
}

/**
 * Update color, visible elements
 */
- (void) updateView {
    [self updateFloatPlaceholder];
    [self updateViewBackground];
}

/**
 * Update float place holder
 */
- (void) updateFloatPlaceholder{
    if (self.isFirstResponder) {
        self.textColor = [FontColor titleColor];
        self.floatPlaceholder.textColor = [FontColor themeColor];
        
        if ([self.text isEqualToString:self.placeHolderStr]) self.text = @"";
        [self showFloatPlaceholder:YES];
    } else {
        if (self.text.length == 0) self.text = self.placeHolderStr;
        
        if ([self.text isEqualToString:self.placeHolderStr]) {
            self.textColor = [FontColor propertyImageBackgroundColor];
            [self hideFloatingLabel:YES];
        } else {
            self.textColor = [FontColor titleColor];
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
    else self.viewBackground.layer.borderColor = [[FontColor defaultBackgroundColor] CGColor];
}
@end
