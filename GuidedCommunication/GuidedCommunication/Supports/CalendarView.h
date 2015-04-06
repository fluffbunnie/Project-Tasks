//
//  CalendarView.h
//  GuidedCommunication
//
//  Created by minh thao nguyen on 4/4/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CalendarViewDelegate <NSObject>

-(void)dateTapped:(NSDate *)date;  //tell the super view that the user tapped on a specific date
-(void)changedMonth; // tell the super view that the month has changed, so readjust the frame in parent view if necessary

@end

@interface CalendarView : UIView
@property (nonatomic, weak) id<CalendarViewDelegate> calendarDelegate;

//this function help enable and disable the submit button
-(void)enableSubmitButton:(BOOL)enable;

//this will calculate the view height so we can aligned it better in the parent's view
-(CGFloat)viewHeight;

-(void)setStartDate:(NSDate *)startDate;
-(void)setEndDate:(NSDate *)endDate;

@end
