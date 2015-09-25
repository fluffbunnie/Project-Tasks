//
//  DatePickerViewController.h
//  Magpie
//
//  Created by minh thao nguyen on 5/21/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PMCalendar.h"

@interface DatePickerViewController : UIViewController <PMCalendarControllerDelegate> 

@property (nonatomic, strong) NSString *targetUserName;
@property (nonatomic, strong) PMPeriod * currentPeriod;


@end
