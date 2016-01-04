//
//  TripPlaceSelectTableViewController.h
//  Magpie
//
//  Created by minh thao nguyen on 5/27/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface TripPlaceSelectTableViewController : UITableViewController
@property (nonatomic, strong) PFObject *userObj;
@end
