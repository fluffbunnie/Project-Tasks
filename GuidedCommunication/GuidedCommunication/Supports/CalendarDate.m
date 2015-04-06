//
//  CalendarDate.m
//  Easyswap
//
//  Created by minh thao nguyen on 12/24/14.
//  Copyright (c) 2014 Easyswap Inc. All rights reserved.
//

#import "CalendarDate.h"

int const JANUARY = 1;
int const FEBRUARY = 2;
int const MARCH = 3;
int const APRIL = 4;
int const MAY = 5;
int const JUNE = 6;
int const JULY = 7;
int const AUGUST = 8;
int const SEPTEMBER = 9;
int const OCTOBER = 10;
int const NOVEMBER = 11;
int const DECEMBER = 12;

int const SUNDAY = 0;
int const MONDAY = 1;
int const TUESDAY = 2;
int const WEDNESDAY = 3;
int const THURSDAY = 4;
int const FRIDAY = 5;
int const SATURDAY = 6;

@implementation CalendarDate

/**
 * Get the current month
 * @return month
 */
+(int)getCurrentMonth {
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    format.dateFormat = @"MM";
    NSDate *date = [[NSDate alloc] init];
    return [[format stringFromDate:date] intValue];
}

/**
 * Get the current year
 * @return year
 */
+(int)getCurrentYear {
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    format.dateFormat = @"yyyy";
    NSDate *date = [[NSDate alloc] init];
    return [[format stringFromDate:date] intValue];
}

/**
 * Get the name of month and year
 * @param month
 * @param year
 * @return month name
 */
+(NSString *)getMonthAndYearNameFromMonth:(int)month andYear:(int)year {
    NSMutableString *monthName = [[NSMutableString alloc] init];
    switch (month) {
        case JANUARY:
            [monthName appendString:@"January"];
            break;
            
        case FEBRUARY:
            [monthName appendString:@"February"];
            break;
            
        case MARCH:
            [monthName appendString:@"March"];
            break;
            
        case APRIL:
            [monthName appendString:@"April"];
            break;
        
        case MAY:
            [monthName appendString:@"May"];
            break;
            
        case JUNE:
            [monthName appendString:@"June"];
            break;
            
        case JULY:
            [monthName appendString:@"July"];
            break;
            
        case AUGUST:
            [monthName appendString:@"August"];
            break;
            
        case SEPTEMBER:
            [monthName appendString:@"September"];
            break;
            
        case OCTOBER:
            [monthName appendString:@"October"];
            break;
            
        case NOVEMBER:
            [monthName appendString:@"November"];
            break;
        
        case DECEMBER:
            [monthName appendString:@"December"];
            break;
            
        default:
            break;
    }
    
    [monthName appendFormat:@" %d", year];
    
    return monthName;
}

/**
 * Get the previous day of a given day
 * @param day
 * @param month
 * @param year
 * @return day
 */
+(int)getPreviousDayOfDay:(int)day month:(int)month andYear:(int)year {
    if (day > 1) return day - 1;
    else {
        int lastMonth = [CalendarDate getPrevMonthFromMonth:month];
        return [CalendarDate getNumberOfDayInMonth:lastMonth andYear:year];
    }
}

/**
 * Get the next day of a given day
 * @param day
 * @param month
 * @param year
 */
+(int)getNextDayOfDay:(int)day month:(int)month andYear:(int)year {
    if (day != [CalendarDate getNumberOfDayInMonth:month andYear:year]) return day + 1;
    else return 1;
}

/**
 * Get the next month of the given month
 * @param month
 * @return next month
 */
+(int)getNextMonthFromMonth:(int)month {
    if (month == DECEMBER) return JANUARY;
    else return month + 1;
}

/**
 * Get the prev month of the given month
 * @param month
 * @return previous month
 */
+(int)getPrevMonthFromMonth:(int)month {
    if (month == JANUARY) return DECEMBER;
    else return month - 1;
}

/**
 * Get the year of the next month
 * @param month
 * @param year of month
 * @return year of next month
 */
+(int)getYearOfNextMonthFromCurrentMonth:(int)currentMonth andYear:(int)year {
    if (currentMonth == DECEMBER) return year + 1;
    else return year;
}

/**
 * Get the year of the previous month 
 * @param month
 * @param year of month
 * @return year of prev month
 */
+(int)getYearOfPrevMonthFromCurrentMonth:(int)currentMonth andYear:(int)year {
    if (currentMonth == JANUARY) return year - 1;
    else return year;
}

/**
 * Get the calendar date string for a given date
 * @param day
 * @param month
 * @param year
 * @return date string
 */
+(NSString *)getCalendarDateStringFromDay:(int)day month:(int)month andYear:(int)year {
    NSMutableString *dateString = [[NSMutableString alloc] initWithFormat:@"%d", year];
    if (month < OCTOBER) [dateString appendFormat:@"0%d", month];
    else [dateString appendFormat:@"%d",month];
    if (day < 10) [dateString appendFormat:@"0%d", day];
    else [dateString appendFormat:@"%d", day];
    return dateString;
}

/**
 * Get the next calendar date from the given calendar date
 * @param calendar date
 * @return calendar date
 */
+(CalendarDate *)getNextCalendarDate:(CalendarDate *)calendarDate {
    NSString *currentCalendarDate = calendarDate.date;
    //we first separate to get the year, month, and day
    int currentYear = [[currentCalendarDate substringToIndex:4] intValue];
    int currentMonth = [[currentCalendarDate substringWithRange:NSMakeRange(4, 2)] intValue];
    int currentDay = [[currentCalendarDate substringFromIndex:6] intValue];
    
    int nextDay = [CalendarDate getNextDayOfDay:currentDay month:currentMonth andYear:currentYear];
    int month = currentMonth;
    if (nextDay == 1) month = [CalendarDate getNextMonthFromMonth:currentMonth];
    int year = currentYear;
    if (month == 1 && nextDay == 1) year++;
    
    CalendarDate *nextCalendarDate = [[CalendarDate alloc] init];
    nextCalendarDate.date = [CalendarDate getCalendarDateStringFromDay:nextDay month:month andYear:year];
    if (month != currentMonth ) nextCalendarDate.inMonth = !calendarDate.inMonth;
    else nextCalendarDate.inMonth = calendarDate.inMonth;
    
    return nextCalendarDate;
}

/**
 * Get the previous calendar date of a given calendar date
 * @param calendar date
 * @return calendar date
 */
+(CalendarDate *)getPreviousCalendarDate:(CalendarDate *)calendarDate {
    NSString *currentCalendarDate = calendarDate.date;
    //we first separate to get the year, month, and day
    int currentYear = [[currentCalendarDate substringToIndex:4] intValue];
    int currentMonth = [[currentCalendarDate substringWithRange:NSMakeRange(4, 2)] intValue];
    int currentDay = [[currentCalendarDate substringFromIndex:6] intValue];
    
    int prevDay = [CalendarDate getPreviousDayOfDay:currentDay month:currentMonth andYear:currentYear];
    int month = currentMonth;
    if (currentDay == 1) month = [CalendarDate getPrevMonthFromMonth:currentMonth];
    int year = currentYear;
    if (currentMonth == 1 && currentDay == 1) year--;
    
    CalendarDate *prevCalendarDate = [[CalendarDate alloc] init];
    prevCalendarDate.date = [CalendarDate getCalendarDateStringFromDay:prevDay month:month andYear:year];
    if (month != currentMonth ) prevCalendarDate.inMonth = !calendarDate.inMonth;
    else prevCalendarDate.inMonth = calendarDate.inMonth;
    
    return prevCalendarDate;
}

/**
 * Get the number of days in a given month
 * @param month
 * @param year
 * @return number
 */
+(int)getNumberOfDayInMonth:(int)month andYear:(int)year {
    if (month == APRIL || month == JUNE || month == SEPTEMBER || month == NOVEMBER) return 30;
    if (month == FEBRUARY && (year % 4 == 0)) return 29;
    if (month == FEBRUARY && (year % 4 != 0)) return 28;
    
    return 31;
}

/**
 * Get the date from its year, month, and day
 * @param day
 * @param month
 * @param year
 * @return year
 */
+(NSDate *)dateWithDay:(int)day month:(int)month andYear:(int)year {
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    dateFormat.dateFormat = @"yyyyMMdd";

    return [dateFormat dateFromString:[CalendarDate getCalendarDateStringFromDay:day month:month andYear:year]];
}

/**
 * Get the day in the week of a given date
 * @param day
 * @param month
 * @param year
 * @param number
 */
+(int)getDateInWeekOfDay:(int)day month:(int)month andYear:(int)year {
    NSDate *date = [CalendarDate dateWithDay:day month:month andYear:year];
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    format.dateFormat = @"EEE";
    
    NSString *todayDateName = [[format stringFromDate:date] uppercaseString];
    NSArray *dateNamesInWeek = [[NSArray alloc] initWithObjects:@"SUN", @"MON", @"TUE", @"WED", @"THU", @"FRI", @"SAT", nil];
    for (int i = 0; i < [dateNamesInWeek count]; i++) {
        NSString *dateName = [dateNamesInWeek objectAtIndex:i];
        if ([todayDateName isEqualToString:dateName]) {
            return i;
        }
    }
    return 0;
}

/**
 * Get the number of weeks in a given month
 * @param month
 * @param year
 * @return number
 */
+(int)getNumWeeksInMonth:(int)month andYear:(int)year {
    //get the number of date in the first row
    int numDaysInFirstWeek = 7 - [CalendarDate getDateInWeekOfDay:1 month:month andYear:year];
    int numDaysInMonth = [CalendarDate getNumberOfDayInMonth:month andYear:year];
    int numDaysInRemainingWeeks = numDaysInMonth - numDaysInFirstWeek;
    
    int numWeeks = 1 + (numDaysInRemainingWeeks / 7);
    if (numDaysInRemainingWeeks % 7 != 0) numWeeks++;
    
    return numWeeks;
}

/**
 * Get the calendar dates for a given month
 * @param month
 * @param year
 * @return array of calendar dates;
 */
+(NSArray *)getCalendarDatesForMonth:(int)month andYear:(int)year {
    NSMutableArray *monthDates = [[NSMutableArray alloc] init];
    int numWeeksInMonth = [CalendarDate getNumWeeksInMonth:month andYear:year];
    CalendarDate *date = [[CalendarDate alloc] init];
    date.date = [CalendarDate getCalendarDateStringFromDay:1 month:month andYear:year];
    date.inMonth = YES;
    
    //now we travel back the to get the first calendar date in this week display in calendar
    int dateInWeek = [CalendarDate getDateInWeekOfDay:1 month:month andYear:year];
    
    for (int i = 0; i <= dateInWeek; i++)
        date = [CalendarDate getPreviousCalendarDate:date];
    
    for (int i = 0; i < numWeeksInMonth; i++) {
        NSMutableArray *weekDates = [[NSMutableArray alloc] init];
        for (int j = 0; j < 7; j++) {
            CalendarDate *nextDay = [CalendarDate getNextCalendarDate:date];
            [weekDates addObject:nextDay];
            date = nextDay;
        }
        
        [monthDates addObject:weekDates];
    }
    return monthDates;
}

@end
