//
//  MyUpcomingTripHostTableViewCell.h
//  Magpie
//
//  Created by minh thao nguyen on 5/29/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface MyUpcomingTripHostTableViewCell : UITableViewCell
-(void)setTripObj:(PFObject *)tripObj;
@end
