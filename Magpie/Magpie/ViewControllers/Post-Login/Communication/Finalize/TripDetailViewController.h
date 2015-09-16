//
//  TripDetailViewController.h
//  Magpie
//
//  Created by minh thao nguyen on 5/21/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "TripDetailPlaceView.h"
#import "PMCalendar.h"
#import "ImportNudgePopup.h"

@interface TripDetailViewController : UIViewController <TripDetailPlaceViewDelegate, UITextFieldDelegate, ImportNudgePopupDelegate>
@property (nonatomic, strong) PFObject *senderObj;
@property (nonatomic, strong) PFObject *receiverObj;
@property (nonatomic, strong) PFObject *propertyObj;

-(void)setNewPropertyObj:(PFObject *)propertyObj;
-(void)setTripDuration:(PMPeriod *)period;

@end
