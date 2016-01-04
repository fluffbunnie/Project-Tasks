//
//  TripReasonPickerView.m
//  Magpie
//
//  Created by minh thao nguyen on 9/20/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import "TripReasonPickerView.h"
#import "RadioButton.h"
#import "FontColor.h"

static NSString * const FLOAT_LABEL_TEXT = @"Reason for Traveling";

@interface TripReasonPickerView()
@property (nonatomic, assign) CGFloat viewWidth;
@property (nonatomic, assign) CGFloat viewHeight;

@property (nonatomic, strong) UIView *borderView;
@property (nonatomic, strong) UILabel *floatLabel;
@property (nonatomic, strong) RadioButton *vacationOption;
@property (nonatomic, strong) RadioButton *conferenceOption;
//@property (nonatomic, strong) RadioButton *eventOption;
@property (nonatomic, strong) RadioButton *otherButton;
@end

@implementation TripReasonPickerView
#pragma mark - initiation
/**
 * Lazily init the border view
 * @return UIView
 */
-(UIView *)borderView {
    if (_borderView == nil) {
        _borderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.viewWidth, self.viewHeight)];
        _borderView.layer.borderWidth = 1;
        _borderView.layer.borderColor = [[FontColor defaultBackgroundColor] CGColor];
        _borderView.layer.cornerRadius = 5;
    }
    return _borderView;
}

/**
 * Lazily init the float label
 * @return UILabel
 */
-(UILabel *)floatLabel {
    if (_floatLabel == nil) {
        _floatLabel = [[UILabel alloc] init];
        _floatLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:12];
        _floatLabel.text = FLOAT_LABEL_TEXT;
        
        [_floatLabel sizeToFit];
        CGRect frame = _floatLabel.frame;
        frame.origin.y = -8;
        frame.origin.x = 15;
        frame.size.height = 16;
        frame.size.width += 10;
        _floatLabel.frame = frame;
        
        _floatLabel.textAlignment = NSTextAlignmentCenter;
        _floatLabel.textColor = [FontColor descriptionColor];
        _floatLabel.backgroundColor = [UIColor whiteColor];
    }
    return _floatLabel;
}

/**
 * Lazily init the vacation option
 * @return RadioButton
 */
-(RadioButton *)vacationOption {
    if (_vacationOption == nil) {
        _vacationOption = [[RadioButton alloc] initWithFrame:CGRectMake(20, 20, self.viewWidth - 40, 30)];
        [_vacationOption setTitle:TRIP_REASON_VACATION];
        [_vacationOption addTarget:self action:@selector(vacationOptionClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _vacationOption;
}

/**
 * Lazily init the conference option
 * @return RadioButton
 */
-(RadioButton *)conferenceOption {
    if (_conferenceOption == nil) {
        _conferenceOption = [[RadioButton alloc] initWithFrame:CGRectMake(20, 60, self.viewWidth - 40, 30)];
        [_conferenceOption setTitle:TRIP_REASON_CONFERENCE];
        [_conferenceOption addTarget:self action:@selector(conferenceOptionClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _conferenceOption;
}

/**
 * Lazily init the other option
 * @return RadioButton
 */
-(RadioButton *)otherButton {
    if (_otherButton == nil) {
        _otherButton = [[RadioButton alloc] initWithFrame:CGRectMake(20, 100, self.viewWidth - 40, 30)];
        [_otherButton setTitle:TRIP_REASON_OTHER];
        [_otherButton addTarget:self action:@selector(otherOptionClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _otherButton;
}

#pragma mark - public method
-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.viewWidth = frame.size.width;
        self.viewHeight = frame.size.height;
        self.layer.masksToBounds = NO;
        
        [self addSubview:[self borderView]];
        [self addSubview:[self floatLabel]];
        [self addSubview:[self vacationOption]];
        [self addSubview:[self conferenceOption]];
        [self addSubview:[self otherButton]];
    }
    return self;
}

#pragma mark - UI interaction
/**
 * Reset all the picked option
 */
-(void)resetPickedOption {
    self.vacationOption.enabled = YES;
    self.conferenceOption.enabled = YES;
    self.otherButton.enabled = YES;
}

/**
 * Handle the behavior when the vacation option button is clicked
 */
-(void)vacationOptionClicked {
    [self resetPickedOption];
    self.vacationOption.enabled = NO;
    [self.delegate pickedOption:TRIP_REASON_VACATION];
}

/**
 * Handle the behavior when the conference option button is clicked
 */
-(void)conferenceOptionClicked {
    [self resetPickedOption];
    self.conferenceOption.enabled = NO;
    [self.delegate pickedOption:TRIP_REASON_CONFERENCE];
}

/**
 * Handle the other button clicked
 */
-(void)otherOptionClicked {
    [self resetPickedOption];
    self.otherButton.enabled = NO;
    [self.delegate pickedOption:TRIP_REASON_OTHER];
}



@end
