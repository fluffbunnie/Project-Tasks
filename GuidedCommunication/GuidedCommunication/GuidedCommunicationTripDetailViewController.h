//
//  GuidedCommunicationTripDetailViewController.h
//  GuidedCommunication
//
//  Created by minh thao nguyen on 4/4/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GuidedCommunicationTabBar.h"
#import "GuidedCommunicationGuestTypeView.h"

extern const NSInteger GUEST_TYPE_UNDEFINE;
extern const NSInteger GUEST_TYPE_GUEST;
extern const NSInteger GUEST_TYPE_ONLY_HOST;


@interface GuidedCommunicationTripDetailViewController : UIViewController <GuidedCommunicationTabBarDelegate, UIScrollViewDelegate, GuidedCommunicationGuestTypeViewDelegate>

@property (nonatomic, assign) NSInteger guestType;
@property (nonatomic, strong) NSString *numGuests;
@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) NSDate *endDate;
@end
