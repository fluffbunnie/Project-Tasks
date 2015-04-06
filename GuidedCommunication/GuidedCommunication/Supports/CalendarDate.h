//
//  CalendarDate.h
//  Easyswap
//
//  Created by minh thao nguyen on 12/24/14.
//  Copyright (c) 2014 Easyswap Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

extern int const JANUARY;
extern int const FEBRUARY;
extern int const MARCH;
extern int const APRIL;
extern int const MAY;
extern int const JUNE;
extern int const JULY;
extern int const AUGUST;
extern int const SEPTEMBER;
extern int const OCTOBER;
extern int const NOVEMBER;
extern int const DECEMBER;

extern int const SUNDAY;
extern int const MONDAY;
extern int const TUESDAY;
extern int const WEDNESDAY;
extern int const THURSDAY;
extern int const FRIDAY;
extern int const SATURDAY;

@interface CalendarDate : NSObject

@property (nonatomic, strong) NSString *date; //in format of YYYYMMdd
@property (nonatomic) BOOL inMonth;
@property (nonatomic) BOOL booked;


//public method
+(int)getCurrentMonth;
+(int)getCurrentYear;
+(NSString *)getMonthAndYearNameFromMonth:(int)month andYear:(int)year;
+(int)getPreviousDayOfDay:(int)day month:(int)month andYear:(int)year;
+(int)getNextDayOfDay:(int)day month:(int)month andYear:(int)year;
+(int)getNextMonthFromMonth:(int)month;
+(int)getPrevMonthFromMonth:(int)month;
+(int)getYearOfNextMonthFromCurrentMonth:(int)currentMonth andYear:(int)year;
+(int)getYearOfPrevMonthFromCurrentMonth:(int)currentMonth andYear:(int)year;
+(NSString *)getCalendarDateStringFromDay:(int)day month:(int)month andYear:(int)year;
+(CalendarDate *)getNextCalendarDate:(CalendarDate *)currentCalendarDate;
+(CalendarDate *)getPreviousCalendarDate:(CalendarDate *)currentCalendarDate;

+(int)getNumberOfDayInMonth:(int)month andYear:(int)year;
+(NSDate *)dateWithDay:(int)day month:(int)month andYear:(int)year;
+(int)getDateInWeekOfDay:(int)day month:(int)month andYear:(int)year;
+(int)getNumWeeksInMonth:(int)month andYear:(int)year;

+(NSArray *)getCalendarDatesForMonth:(int)month andYear:(int)year;

@end
