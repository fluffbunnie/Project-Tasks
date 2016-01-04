//
//  DatePickerViewController.m
//  Magpie
//
//  Created by minh thao nguyen on 5/21/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import "DatePickerViewController.h"
#import "CrossCloseButton.h"
#import "FontColor.h"
#import "TripDetailViewController.h"
#import <QuartzCore/QuartzCore.h>

static CGFloat CONTENT_HEIGHT = 422;
static NSString * DEFAULT_BACKGROUND_IMAGE_LIGHT = @"DefaultBackgroundImageLight";
static NSString * INSTRUCTION_LABEL_TEXT = @"Please pick the dates you want to stay at %@’s place";

static NSString * PREV_MONTH_ICON = @"DatePickerPrevMonthIcon";
static NSString * NEXT_MONTH_ICON = @"DatePickerNextMonthIcon";

static NSString *BACK_BUTTON_IMAGE_HIGHLIGHT = @"NavigationBarSwipeViewBackIconHighlight";
static NSString *BACK_BUTTON_IMAGE_NORMAL = @"NavigationBarSwipeViewBackIconNormal";

@interface DatePickerViewController ()
@property (nonatomic, assign) CGFloat screenWidth;
@property (nonatomic, assign) CGFloat screenHeight;

@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UILabel *instructionlabel;
@property (nonatomic, strong) UIView *calendarContainner;
@property (nonatomic, strong) UIView *calendarMonthHeader;

@property (nonatomic, strong) UIButton *prevMonthButton;
@property (nonatomic, strong) UIButton *nextMonthButton;
@property (nonatomic, strong) UIButton *doneButton;

@property (nonatomic, strong) UIView *calendarOverlay;
@property (nonatomic, strong) PMCalendarController *pmCalendar;
@end

@implementation DatePickerViewController
#pragma mark - initiation
/**
 * Lazily init the background image view
 * @return UIImageView
 */
-(UIImageView *)backgroundImageView {
    if (_backgroundImageView == nil) {
        _backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.screenWidth, self.screenHeight)];
        _backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
        _backgroundImageView.image = [UIImage imageNamed:DEFAULT_BACKGROUND_IMAGE_LIGHT];
    }
    return _backgroundImageView;
}

/**
 * Lazily init the back button
 * @return UIButton
 */
-(UIButton *)backButton {
    if (_backButton == nil) {
        _backButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 20, 44, 44)];
        [_backButton setImage:[UIImage imageNamed:BACK_BUTTON_IMAGE_NORMAL] forState:UIControlStateNormal];
        [_backButton setImage:[UIImage imageNamed:BACK_BUTTON_IMAGE_HIGHLIGHT] forState:UIControlStateHighlighted];
        
        [_backButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}

/**
 * Lazily init the instruction label
 * @return UILabel
 */
-(UILabel *)instructionlabel {
    if (_instructionlabel == nil) {
        _instructionlabel = [[UILabel alloc] initWithFrame:CGRectMake(40, (self.screenHeight - CONTENT_HEIGHT) / 2, self.screenWidth - 80, 50)];
        _instructionlabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:14];
        _instructionlabel.textColor = [FontColor titleColor];
        _instructionlabel.textAlignment = NSTextAlignmentCenter;
        _instructionlabel.numberOfLines = 0;
        _instructionlabel.text = [NSString stringWithFormat:INSTRUCTION_LABEL_TEXT, self.targetUserName];
    }
    return _instructionlabel;
}

/**
 * Lazily init the calendar container
 * @return UIView
 */
-(UIView *)calendarContainner {
    if (_calendarContainner == nil) {
        _calendarContainner = [[UIView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.instructionlabel.frame) + 30, self.screenWidth - 40, 342)];
        _calendarContainner.backgroundColor = [UIColor whiteColor];
        _calendarContainner.layer.cornerRadius = 20;
        _calendarContainner.layer.masksToBounds = YES;
        _calendarContainner.clipsToBounds = YES;
    }
    return _calendarContainner;
}

/**
 * Lazily init the calendar's header
 * @return UIView
 */
-(UIView *)calendarMonthHeader {
    if (_calendarMonthHeader == nil) {
        _calendarMonthHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.screenWidth - 40, 50)];
        _calendarMonthHeader.backgroundColor = [FontColor defaultBackgroundColor];
    }
    return _calendarMonthHeader;
}

/**
 * Lazily init the back button
 * @return UIButton
 */
-(UIButton *)prevMonthButton {
    if (_prevMonthButton == nil) {
        _prevMonthButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.calendarContainner.frame), CGRectGetMinY(self.calendarContainner.frame), 59, 50)];
        [_prevMonthButton setImage:[UIImage imageNamed:PREV_MONTH_ICON] forState:UIControlStateNormal];
        [_prevMonthButton addTarget:self action:@selector(prevMonthClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _prevMonthButton;
}

/**
 * Lazily init the next button
 * @return UIButton
 */
-(UIButton *)nextMonthButton {
    if (_nextMonthButton == nil) {
        _nextMonthButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.calendarContainner.frame) - 59, CGRectGetMinY(self.calendarContainner.frame), 59, 50)];
        [_nextMonthButton setImage:[UIImage imageNamed:NEXT_MONTH_ICON] forState:UIControlStateNormal];
        [_nextMonthButton addTarget:self action:@selector(nextMonthClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nextMonthButton;
}

/**
 * Lazily init the calendar's done button
 * @return UIButton
 */
-(UIButton *)doneButton {
    if (_doneButton == nil) {
        _doneButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.calendarContainner.frame), CGRectGetMaxY(self.calendarContainner.frame) - 60, self.screenWidth - 40, 60)];
        _doneButton.titleLabel.font = [UIFont fontWithName:@"AvenirNext-Medium" size:15];
        [_doneButton setTitle:@"Done" forState:UIControlStateNormal];
        [_doneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_doneButton setBackgroundImage:[FontColor imageWithColor:[FontColor themeColor]] forState:UIControlStateNormal];
        
        UIBezierPath *maskPath;
        maskPath = [UIBezierPath bezierPathWithRoundedRect:_doneButton.bounds
                                         byRoundingCorners:(UIRectCornerBottomLeft|UIRectCornerBottomRight)
                                               cornerRadii:CGSizeMake(20, 20)];
        
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = _doneButton.bounds;
        maskLayer.path = maskPath.CGPath;
        _doneButton.layer.mask = maskLayer;
        
        [_doneButton addTarget:self action:@selector(doneButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _doneButton;
}

/**
 * Lazily init the calendar overlay
 * @return UIView
 */
-(UIView *)calendarOverlay {
    if (_calendarOverlay == nil) {
        _calendarOverlay = [[UIView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.instructionlabel.frame) + 30, self.screenWidth - 40, 1)];
        _calendarOverlay.userInteractionEnabled = NO;
    }
    return _calendarOverlay;
}


/**
 * Lazily init the pm calendar view
 * @return PMCalendarController
 */
-(PMCalendarController *)pmCalendar {
    if (_pmCalendar == nil) {
        _pmCalendar = [[PMCalendarController alloc] initWithThemeName:@"default" andSize:CGSizeMake(self.screenWidth - 40, 282)];
        _pmCalendar.mondayFirstDayOfWeek = NO;
        _pmCalendar.allowedPeriod = [PMPeriod periodWithStartDate:[[NSDate alloc] init] endDate:[[NSDate alloc] initWithTimeInterval:60*60*24*365*10 sinceDate:[[NSDate alloc] init]]]; //only 10 years in the future

        [_pmCalendar presentCalendarFromView:self.calendarOverlay
                    permittedArrowDirections:PMCalendarArrowDirectionDown
                                   isPopover:YES
                                    animated:NO];
        
        if (self.currentPeriod == nil) self.currentPeriod = [PMPeriod oneDayPeriodWithDate:[NSDate date]];
        _pmCalendar.period = self.currentPeriod;
    }
    return _pmCalendar;
}

#pragma mark - public method
- (void)viewDidLoad {
    [super viewDidLoad];
    self.screenWidth = [[UIScreen mainScreen] bounds].size.width;
    self.screenHeight = [[UIScreen mainScreen] bounds].size.height;
    
    [self.view addSubview:[self backgroundImageView]];
    [self.view addSubview:[self instructionlabel]];
    [self.view addSubview:[self calendarContainner]];
    [self.calendarContainner addSubview:[self calendarMonthHeader]];
    [self.view addSubview:[self calendarOverlay]];
    [self pmCalendar];
    
    [self.view addSubview:[self backButton]];
    [self.view addSubview:[self prevMonthButton]];
    [self.view addSubview:[self nextMonthButton]];
    [self.view addSubview:[self doneButton]];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarHidden = YES;
    [self.navigationController setNavigationBarHidden:YES animated:false];
}

#pragma mark - UI gesture
/**
 * Handle the behavior when user clicked on the close button
 */
-(void)goBack {
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 * Handle the behavior when user click on the done button
 */
-(void)doneButtonClicked {
    NSInteger currentViewControllerIndex = [self.navigationController.viewControllers indexOfObject:self];
    TripDetailViewController *tripDetailViewController = [self.navigationController.viewControllers objectAtIndex:currentViewControllerIndex-1];
    [tripDetailViewController setTripDuration:self.pmCalendar.period];
    
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 * Move the cursor to prev month when its icon got clicked
 */
-(void)prevMonthClicked {
    [self.pmCalendar prevMonthClicked];
}

/**
 * Move the cursor to next month when its icon got clicked
 */
-(void)nextMonthClicked {
    [self.pmCalendar nextMonthClicked];
}

@end
