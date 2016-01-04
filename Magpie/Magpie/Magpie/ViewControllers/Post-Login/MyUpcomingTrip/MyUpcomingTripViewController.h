//
//  MyUpcomingTripViewController.h
//  Magpie
//
//  Created by minh thao nguyen on 5/6/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "MyUpcomingTripEmptyView.h"

@interface MyUpcomingTripViewController : UIViewController <MyUpcomingTripEmptyViewDelegate, UITableViewDataSource, UITableViewDelegate>
-(void)sendTripResponseForTrip:(PFObject *)tripObj withType:(NSString *)type;
@end
