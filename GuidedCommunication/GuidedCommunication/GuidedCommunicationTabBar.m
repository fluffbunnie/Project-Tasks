//
//  GuidedCommunicationTabBar.m
//  GuidedCommunication
//
//  Created by minh thao nguyen on 4/5/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import "GuidedCommunicationTabBar.h"
#import "UIVerticalButton.h"
#import "FontColor.h"

#define TAB_BAR_HEIGHT 58.0

static NSString * GUEST_TYPE_BUTTON_TITLE = @"Type";
static NSString * NUM_GUEST_BUTTON_TITLE = @"Party";
static NSString * DATE_PICKER_BUTTON_TITLE = @"Date";

static NSString * GUEST_TYPE_ICON_NAME_NORMAL = @"TabBarGuestTypeIcon";
static NSString * GUEST_TYPE_ICON_NAME_HIGHLIGHT = @"TabBarGuestTypeIconHighlight";
static NSString * NUM_GUESTS_ICON_NAME_NORMAL = @"TabBarNumGuestsIcon";
static NSString * NUM_GUESTS_ICON_NAME_HIGHLIGHT = @"TabBarNumGuestsIconHighlight";
static NSString * DATE_PICKER_ICON_NAME_NORMAL = @"TabBarDatePickerIcon";
static NSString * DATE_PICKER_ICON_NAME_HIGHLIGHT = @"TabBarDatePickerIconHighlight";

@implementation GuidedCommunicationTabBar
#pragma mark - initiation
/** 
 * lazily init the guest type tab bar button
 * @return guest type button
 */
-(UIButton *)guestTypeButton {
    if (_guestTypeButton == nil) {
        float screenWidth = [[UIScreen mainScreen] bounds].size.width;
        float buttonWidth = screenWidth / 3.0;
        _guestTypeButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, buttonWidth, TAB_BAR_HEIGHT)];
        
        _guestTypeButton.titleLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:11];
        [_guestTypeButton setTitle:GUEST_TYPE_BUTTON_TITLE forState:UIControlStateNormal];
        [_guestTypeButton setTitleColor:[FontColor propertyImageBackgroundColor] forState:UIControlStateNormal];
        [_guestTypeButton setTitleColor:[FontColor themeColor] forState:UIControlStateHighlighted];
        [_guestTypeButton setTitleColor:[FontColor themeColor] forState:UIControlStateDisabled];
        
        [_guestTypeButton setImage:[UIImage imageNamed:GUEST_TYPE_ICON_NAME_NORMAL] forState:UIControlStateNormal];
        [_guestTypeButton setImage:[UIImage imageNamed:GUEST_TYPE_ICON_NAME_HIGHLIGHT] forState:UIControlStateHighlighted];
        [_guestTypeButton setImage:[UIImage imageNamed:GUEST_TYPE_ICON_NAME_HIGHLIGHT] forState:UIControlStateDisabled];
        
        [_guestTypeButton centerVerticallyWithPadding:2];
        
        [_guestTypeButton addTarget:self action:@selector(guestTypeButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _guestTypeButton;
}

/**
 * Lazily init the num guest tab bar button
 * @return num guest button
 */
-(UIButton *)numGuestButton {
    if (_numGuestButton == nil) {
        float screenWidth = [[UIScreen mainScreen] bounds].size.width;
        float buttonWidth = screenWidth / 3.0;
        _numGuestButton = [[UIButton alloc] initWithFrame:CGRectMake(buttonWidth, 0, buttonWidth, TAB_BAR_HEIGHT)];
        
        _numGuestButton.titleLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:11];
        [_numGuestButton setTitle:NUM_GUEST_BUTTON_TITLE forState:UIControlStateNormal];
        [_numGuestButton setTitleColor:[FontColor propertyImageBackgroundColor] forState:UIControlStateNormal];
        [_numGuestButton setTitleColor:[FontColor themeColor] forState:UIControlStateHighlighted];
        [_numGuestButton setTitleColor:[FontColor themeColor] forState:UIControlStateDisabled];
        
        [_numGuestButton setImage:[UIImage imageNamed:NUM_GUESTS_ICON_NAME_NORMAL] forState:UIControlStateNormal];
        [_numGuestButton setImage:[UIImage imageNamed:NUM_GUESTS_ICON_NAME_HIGHLIGHT] forState:UIControlStateHighlighted];
        [_numGuestButton setImage:[UIImage imageNamed:NUM_GUESTS_ICON_NAME_HIGHLIGHT] forState:UIControlStateDisabled];
        
        [_numGuestButton centerVerticallyWithPadding:2];
        
        [_numGuestButton addTarget:self action:@selector(numGuestButtonClick) forControlEvents:UIControlEventTouchUpInside];

    }
    return _numGuestButton;
}

/**
 * Lazily init the date picker button
 * @return date picker button
 */
-(UIButton *)datePickerButton {
    if (_datePickerButton == nil) {
        float screenWidth = [[UIScreen mainScreen] bounds].size.width;
        float buttonWidth = screenWidth / 3.0;
        _datePickerButton = [[UIButton alloc] initWithFrame:CGRectMake(2 * buttonWidth, 0, buttonWidth, TAB_BAR_HEIGHT)];
        
        _datePickerButton.titleLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:11];
        [_datePickerButton setTitle:DATE_PICKER_BUTTON_TITLE forState:UIControlStateNormal];
        [_datePickerButton setTitleColor:[FontColor propertyImageBackgroundColor] forState:UIControlStateNormal];
        [_datePickerButton setTitleColor:[FontColor themeColor] forState:UIControlStateHighlighted];
        [_datePickerButton setTitleColor:[FontColor themeColor] forState:UIControlStateDisabled];

        
        [_datePickerButton setImage:[UIImage imageNamed:DATE_PICKER_ICON_NAME_NORMAL] forState:UIControlStateNormal];
        [_datePickerButton setImage:[UIImage imageNamed:DATE_PICKER_ICON_NAME_HIGHLIGHT] forState:UIControlStateHighlighted];
        [_datePickerButton setImage:[UIImage imageNamed:DATE_PICKER_ICON_NAME_HIGHLIGHT] forState:UIControlStateDisabled];
        
        [_datePickerButton centerVerticallyWithPadding:2];
        
        [_datePickerButton addTarget:self action:@selector(datePickerButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _datePickerButton;
}

#pragma mark - view delegate and public methods
-(id)init {
    float screenWidth = [[UIScreen mainScreen] bounds].size.width;
    float screenHeight = [[UIScreen mainScreen] bounds].size.height;
    
    self = [super initWithFrame:CGRectMake(0, screenHeight - TAB_BAR_HEIGHT, screenWidth, TAB_BAR_HEIGHT)];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:[self guestTypeButton]];
        [self addSubview:[self numGuestButton]];
        [self addSubview:[self datePickerButton]];
        
        [self highlightGuestTypeButton];
    }
    return self;
}

/**
 * Show the tabbar view 
 * @param should animate
 */
-(void)showViewAnimated:(BOOL)animate {
    float screenWidth = [[UIScreen mainScreen] bounds].size.width;
    float screenHeight = [[UIScreen mainScreen] bounds].size.height;
    
    CGRect newFrame = CGRectMake(0, screenHeight - TAB_BAR_HEIGHT, screenWidth, TAB_BAR_HEIGHT);
    
    if (!animate) self.frame = self.frame = newFrame;
    else {
        [UIView animateWithDuration:0.3 animations:^{
            self.frame = newFrame;
        }];
    }
}

/**
 * Hide the tabbar view
 * @param animate
 */
-(void)hideViewAnimated:(BOOL)animate {
    float screenWidth = [[UIScreen mainScreen] bounds].size.width;
    float screenHeight = [[UIScreen mainScreen] bounds].size.height;
    
    CGRect newFrame = CGRectMake(0, screenHeight, screenWidth, TAB_BAR_HEIGHT);
    
    if (!animate) self.frame = self.frame = newFrame;
    else {
        [UIView animateWithDuration:0.3 animations:^{
            self.frame = newFrame;
        }];
    }
}

/**
 * When highlight the guest type button, dehighlight other buttons
 */
-(void)highlightGuestTypeButton {
    [self.guestTypeButton setEnabled:NO];
    [self.numGuestButton setEnabled:YES];
    [self.datePickerButton setEnabled:YES];
}

/**
 * Highlight the num guests button
 */
-(void)highlightNumGuestsButton {
    [self.guestTypeButton setEnabled:YES];
    [self.numGuestButton setEnabled:NO];
    [self.datePickerButton setEnabled:YES];
}

/**
 * Highlight date picker button
 */
-(void)highlightDatePickerButton {
    [self.guestTypeButton setEnabled:YES];
    [self.numGuestButton setEnabled:YES];
    [self.datePickerButton setEnabled:NO];
}

#pragma mark - button action 
/**
 * Handle the action when guest type button is clicked
 * When this button is clicked, set it to the highlight state
 */
-(void)guestTypeButtonClick {
    [self highlightGuestTypeButton];
    [self.tabBarDelegate showGuestTypeView];
}

/**
 * Handle the action when num guests button is clicked
 * When this button is clicked, set it to the highlight state
 */
-(void)numGuestButtonClick {
    [self highlightNumGuestsButton];
    [self.tabBarDelegate showNumGuestsView];
}

/**
 * Handle the action when num is clicked
 * When this button is clicked, set it to the highlight state
 */
-(void)datePickerButtonClick {
    [self highlightDatePickerButton];
    [self.tabBarDelegate showDatePickerView];
}






@end
