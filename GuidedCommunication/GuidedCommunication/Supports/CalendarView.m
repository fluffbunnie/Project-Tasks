//
//  CalendarView.m
//  GuidedCommunication
//
//  Created by minh thao nguyen on 4/4/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import "CalendarView.h"
#import "CalendarDate.h"
#import "FontColor.h"

#define CELL_RATIO 0.75

@interface CalendarView()
@property (nonatomic) int currentMonth; //current month is between 1 - 12
@property (nonatomic) int currentYear; //in format of YYYYY
@property (nonatomic, strong) NSArray *datesInMonth;

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UILabel *monthLabel;
@property (nonatomic, strong) UIView *gridView;
@property (nonatomic, strong) UIView *border;
@end

@implementation CalendarView

#pragma mark - view init
-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.currentMonth = [CalendarDate getCurrentMonth];
        self.currentYear = [CalendarDate getCurrentYear];
        
        self.datesInMonth = [self getDatesInMonth];
        [self initContainerView];
        [self initMonthLabel];
        [self initNextMonthButton];
        [self initPrevMonthButton];
        [self initGridView];
        [self initViewBorder];
    }
    return self;
}


/**
 * Get the array of all the days in the month
 * @return array
 */
-(NSArray *)getDatesInMonth {
    NSArray *datesInMonth = [CalendarDate getCalendarDatesForMonth:self.currentMonth andYear:self.currentYear];
    for (NSArray *datesInWeek in datesInMonth) {
        for (CalendarDate *date in datesInWeek) {
            //date.booked = [self containsObject:date.date];
        }
    }
    
    return datesInMonth;
}

#pragma mark - init view components

/**
 * Init the container view
 */
-(void)initContainerView {
    float screenWidth = [[UIScreen mainScreen] bounds].size.width;
    self.containerView = [[UIView alloc] initWithFrame:CGRectMake(20, 68, screenWidth - 40, [self getContainerViewHeight])];
    
    self.containerView.backgroundColor = [UIColor whiteColor];
    
    [self.containerView.layer setCornerRadius:20];
    [self.containerView.layer setMasksToBounds:NO];
    [self.containerView.layer setShadowColor:[[UIColor blackColor] CGColor]];
    [self.containerView.layer setShadowRadius:2];
    [self.containerView.layer setShadowOffset:CGSizeMake(0, 2)];
    [self.containerView.layer setShadowOpacity:0.1f];
    
    [self addSubview:self.containerView];
}

/**
 * Init the month label
 */
-(void)initMonthLabel {
    float screenWidth = [[UIScreen mainScreen] bounds].size.width;
    self.monthLabel = [[UILabel alloc] initWithFrame:CGRectMake((screenWidth - 170)/2, 15, 130, 23)];
    self.monthLabel.text = [CalendarDate getMonthAndYearNameFromMonth:self.currentMonth andYear:self.currentYear];
    self.monthLabel.textColor = [FontColor titleColor];
    self.monthLabel.font = [UIFont fontWithName:@"AvenirNext-Medium" size:14];
    self.monthLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.monthLabel];
    
}

/**
 * Init next month button
 */
-(void)initNextMonthButton {
    float screenWidth = [[UIScreen mainScreen] bounds].size.width;
    UIButton *nextMonthButton = [[UIButton alloc] initWithFrame:CGRectMake(screenWidth/2 + 45, 5, 43, 43)];
    [nextMonthButton setBackgroundImage:[UIImage imageNamed:@"PropertyCalendarNextMonth"] forState:UIControlStateNormal];
    [nextMonthButton addTarget:self action:@selector(goToNextMonth) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:nextMonthButton];
}

/**
 * Init the previous month button
 */
-(void)initPrevMonthButton {
    float screenWidth = [[UIScreen mainScreen] bounds].size.width;
    UIButton *prevMonthButton = [[UIButton alloc] initWithFrame:CGRectMake(screenWidth/2 - 128, 5, 43, 43)];
    [prevMonthButton setBackgroundImage:[UIImage imageNamed:@"PropertyCalendarPreviousMonth"] forState:UIControlStateNormal];
    [prevMonthButton addTarget:self action:@selector(goToPreviousMonth) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:prevMonthButton];
}

/**
 * Init the grid view
 */
-(void)initGridView {
    self.gridView = [[UIView alloc] init];
    [self setupGridView];
    [self.containerView addSubview:self.gridView];
}

/**
 * Init the view border
 */
-(void)initViewBorder {
    float screenWidth = [[UIScreen mainScreen] bounds].size.width;
    self.border = [[UIView alloc] initWithFrame:CGRectMake(20, [self viewHeight] - 1, screenWidth - 40, 1)];
    self.border.backgroundColor = [FontColor tableSeparatorColor];
    
    [self addSubview:self.border];
}

#pragma mark - height of each view
/**
 * Get the height of entire view
 * @return height
 */
-(CGFloat)viewHeight {
    return 25 + 23 + 20 + [self getContainerViewHeight] + 30;
}

/**
 * Get the grid cell width
 * @return width of grid cell
 */
-(float)getGridCellWidth {
    float screenWidth = [[UIScreen mainScreen] bounds].size.width;
    return (screenWidth - 60)/7.0;
}

/**
 * Get the grid cell height
 * @return height of grid cell
 */
-(float)getGridCellHeight {
    return CELL_RATIO * [self getGridCellWidth] + 1;
}

/**
 * Get the grid view height
 * @return height of grid
 */
-(float)getGridViewHeight {
    return (self.datesInMonth.count + 1) * [self getGridCellHeight];
}

/**
 * Get the container view height
 * @return height of container view
 */
-(float)getContainerViewHeight {
    return 15 + 23 + 15 + [self getGridViewHeight] + 30;
}

#pragma mark - setting up
/**
 * set up the grid view
 */
-(void)setupGridView {
    float screenWidth = [[UIScreen mainScreen] bounds].size.width;
    self.gridView.frame = CGRectMake(10, 53, screenWidth - 60, [self getGridViewHeight]);
    
    //add the border
    for (int i = 0; i <= 7; i++) {
        UIView *borderView = [[UIView alloc] initWithFrame:CGRectMake(i * [self getGridCellWidth], 0, 1, [self getGridViewHeight])];
        borderView.backgroundColor = [FontColor tableSeparatorColor];
        [self.gridView addSubview:borderView];
    }
    
    for (int i = 0; i <= self.datesInMonth.count + 1; i++) {
        UIView *borderView = [[UIView alloc] initWithFrame:CGRectMake(0, i * [self getGridCellHeight], screenWidth - 60, 1)];
        borderView.backgroundColor = [FontColor tableSeparatorColor];
        [self.gridView addSubview:borderView];
    }
    
    //add the color header for the date name
    UIView *headerColor = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth - 60, [self getGridCellHeight])];
    headerColor.backgroundColor = [FontColor tableSeparatorColor];
    [self.gridView addSubview:headerColor];
    
    //now add the view for the date indicator
    for (int col = 0; col < 7; col++) {
        UILabel *dateLabel = [[UILabel alloc] initWithFrame:[self getFrameOfGridCellAtRow:0 andColumn:col]];
        if (col == SUNDAY) dateLabel.text = @"Sn";
        if (col == MONDAY) dateLabel.text = @"M";
        if (col == TUESDAY) dateLabel.text = @"T";
        if (col == WEDNESDAY) dateLabel.text = @"W";
        if (col == THURSDAY) dateLabel.text = @"Th";
        if (col == FRIDAY) dateLabel.text = @"F";
        if (col == SATURDAY) dateLabel.text = @"S";
        
        dateLabel.textColor = [FontColor titleColor];
        dateLabel.font = [UIFont fontWithName:@"AvenirNext-Medium" size:13];
        dateLabel.textAlignment = NSTextAlignmentCenter;
        [self.gridView addSubview:dateLabel];
    }
    
    //now we go ahead and add in the dates
    for (int row = 1; row <= self.datesInMonth.count; row++) {
        NSArray *datesInWeek = self.datesInMonth[row - 1];
        for (int col = 0; col < 7; col++) {
            CalendarDate *calendarDate = datesInWeek[col];
            UILabel *dateLabel = [[UILabel alloc] initWithFrame:[self getFrameOfGridCellAtRow:row andColumn:col]];
            dateLabel.text = [NSString stringWithFormat:@"%d", [[calendarDate.date substringFromIndex:6] intValue] ];
            dateLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:13.5];
            dateLabel.textAlignment = NSTextAlignmentCenter;
            
            if (calendarDate.inMonth && !calendarDate.booked) dateLabel.textColor = [FontColor descriptionColor];
            else if (calendarDate.inMonth && calendarDate.booked) {
                dateLabel.textColor = [FontColor subTitleColor];
                dateLabel.backgroundColor = [FontColor tableSeparatorColor];
                dateLabel.layer.borderColor = [[FontColor tableSeparatorColor] CGColor];
                dateLabel.layer.borderWidth = 1;
                
            } else dateLabel.textColor = [FontColor subTitleColor];
            
            [self.gridView addSubview:dateLabel];
        }
    }
}

/**
 * Get the frame of the grid view cell at ith row and jth column
 * @param row
 * @param column
 * @return CGRect
 */
-(CGRect)getFrameOfGridCellAtRow:(int)row andColumn:(int)column {
    return CGRectMake(column * [self getGridCellWidth] + 1, row * [self getGridCellHeight] + 1, [self getGridCellWidth] - 1, [self getGridCellHeight] -1);
}


#pragma mark - calendar navigation and button selector
/**
 * Go to the next month in the calendar
 */
-(void)goToNextMonth {
    self.currentYear = [CalendarDate getYearOfNextMonthFromCurrentMonth:self.currentMonth andYear:self.currentYear];
    self.currentMonth = [CalendarDate getNextMonthFromMonth:self.currentMonth];
    self.datesInMonth = [self getDatesInMonth];
    [self redrawViews];
}

/**
 * Go to the previous month in the calendar
 */
-(void)goToPreviousMonth {
    self.currentYear = [CalendarDate getYearOfPrevMonthFromCurrentMonth:self.currentMonth andYear:self.currentYear];
    self.currentMonth = [CalendarDate getPrevMonthFromMonth:self.currentMonth];
    self.datesInMonth = [self getDatesInMonth];
    [self redrawViews];
}

/**
 * redraw the views
 */
-(void)redrawViews {
    float screenWidth = [[UIScreen mainScreen] bounds].size.width;
    
    //change the container view frame
    self.containerView.frame = CGRectMake(20, 68, screenWidth - 40, [self getContainerViewHeight]);
    
    //change the label
    self.monthLabel.text = [CalendarDate getMonthAndYearNameFromMonth:self.currentMonth andYear:self.currentYear];
    
    //clean the calendar grid and reposition it
    for (UIView *subview in [self.gridView subviews])
        [subview removeFromSuperview];
    [self setupGridView];
    
    //reposition the border
    self.border.frame = CGRectMake(20, [self viewHeight] - 1, screenWidth - 40, 1);
    
    //finally ask the table view to refresh itself
    [self.calendarDelegate changedMonth];
}


@end
