//
//  MyPlaceListViewController.h
//  Magpie
//
//  Created by minh thao nguyen on 5/6/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "Mixpanel.h"

@interface MyPlaceListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) PFObject *userObj;
@end
