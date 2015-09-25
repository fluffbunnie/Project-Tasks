//
//  TripReasonPickerView.h
//  Magpie
//
//  Created by minh thao nguyen on 9/20/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString * const TRIP_REASON_VACATION = @"Vacation";
static NSString * const TRIP_REASON_CONFERENCE = @"Event or conference";
static NSString * const TRIP_REASON_OTHER = @"Other";

@protocol TripReasonPickerViewDelegate <NSObject>
-(void)pickedOption:(NSString *)option;
@end

@interface TripReasonPickerView : UIView
@property (nonatomic, weak) id<TripReasonPickerViewDelegate> delegate;
@end
