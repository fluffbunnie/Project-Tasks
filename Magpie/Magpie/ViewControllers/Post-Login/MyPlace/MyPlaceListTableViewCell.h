//
//  MyPlaceListTableViewCell.h
//  Magpie
//
//  Created by minh thao nguyen on 5/10/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface MyPlaceListTableViewCell : UITableViewCell
-(void)setPlace:(PFObject *)placeObj;
@end
