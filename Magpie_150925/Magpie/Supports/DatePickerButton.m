//
//  DatePickerButton.m
//  Magpie
//
//  Created by minh thao nguyen on 5/22/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import "DatePickerButton.h"
#import "FontColor.h"

static NSString *PLACEHOLDER_TEXT = @"Travel dates";

static NSString *DATE_PICKER_DATE_ICON_NORMAL = @"DatePickerDateIconNormal";
static NSString *DATE_PICKER_DATE_ICON_HIGHLIGHT = @"DatePickerDateIconHighlight";

@interface DatePickerButton()
@property (nonatomic, strong) UIView *backgroundBorderView;
@property (nonatomic, strong) UILabel *floatPlaceholder;
@property (nonatomic, strong) UILabel *normalPlaceHolder;
@end

@implementation DatePickerButton
/**
 * Lazily init the background view
 * @return UIView
 */
-(UIView *)backgroundBorderView {
    if (_backgroundBorderView == nil) {
        _backgroundBorderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _backgroundBorderView.layer.borderWidth = 1;
        _backgroundBorderView.layer.borderColor = [[FontColor defaultBackgroundColor] CGColor];
        _backgroundBorderView.layer.cornerRadius = 5;
        _backgroundBorderView.userInteractionEnabled = NO;
        
    }
    return _backgroundBorderView;
}
/**
 * Lazily init the float place holder
 * @return UILabel
 */
-(UILabel *)floatPlaceholder {
    if (_floatPlaceholder == nil) {
        _floatPlaceholder = [[UILabel alloc] init];
        _floatPlaceholder.font = [UIFont fontWithName:@"AvenirNext-Regular" size:12];
        _floatPlaceholder.text = PLACEHOLDER_TEXT;
        
        [_floatPlaceholder sizeToFit];
        CGRect frame = _floatPlaceholder.frame;
        frame.origin.y = -8;
        frame.origin.x = 15;
        frame.size.height = 16;
        frame.size.width += 10;
        _floatPlaceholder.frame = frame;
        
        _floatPlaceholder.textAlignment = NSTextAlignmentCenter;
        _floatPlaceholder.textColor = [FontColor themeColor];
        _floatPlaceholder.backgroundColor = [UIColor whiteColor];
        _floatPlaceholder.hidden = YES;
    }
    return _floatPlaceholder;
}

/**
 * Lazily init the normal place holder
 * @return UILabel
 */
-(UILabel *)normalPlaceHolder {
    if (_normalPlaceHolder == nil) {
        _normalPlaceHolder = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 120, self.frame.size.height)];
        _normalPlaceHolder.font = [UIFont fontWithName:@"AvenirNext-Regular" size:15];
        _normalPlaceHolder.textColor = [FontColor descriptionColor];
        _normalPlaceHolder.text = PLACEHOLDER_TEXT;
    }
    return _normalPlaceHolder;
}

#pragma mark - public method
-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:15];
        [self setTitleColor:[FontColor titleColor] forState:UIControlStateNormal];
        [self setTitleColor:[FontColor themeColor] forState:UIControlStateHighlighted];
        [self setImage:[UIImage imageNamed:DATE_PICKER_DATE_ICON_NORMAL] forState:UIControlStateNormal];
        [self setImage:[UIImage imageNamed:DATE_PICKER_DATE_ICON_HIGHLIGHT] forState:UIControlStateHighlighted];
        
        self.titleEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
        self.imageEdgeInsets = UIEdgeInsetsMake(0, frame.size.width - 40, 0, 0);
        
        [self addSubview:[self backgroundBorderView]];
        [self addSubview:[self floatPlaceholder]];
        [self addSubview:[self normalPlaceHolder]];
    }
    return self;
}

/**
 * Set the picked date in the format of the string
 * @param NSString
 */
-(void)setDatePicked:(NSString *)date {
    [self setTitle:date forState:UIControlStateNormal];
    self.floatPlaceholder.hidden = NO;
    self.normalPlaceHolder.hidden = YES;
}

#pragma mark - override
-(void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    if (highlighted) {
        self.floatPlaceholder.textColor = [FontColor themeColor];
        self.normalPlaceHolder.textColor = [FontColor themeColor];
        self.backgroundBorderView.layer.borderColor = [FontColor themeColor].CGColor;
    } else {
        self.floatPlaceholder.textColor = [FontColor descriptionColor];
        self.normalPlaceHolder.textColor = [FontColor descriptionColor];
        self.backgroundBorderView.layer.borderColor = [FontColor defaultBackgroundColor].CGColor;
    }
}

@end
