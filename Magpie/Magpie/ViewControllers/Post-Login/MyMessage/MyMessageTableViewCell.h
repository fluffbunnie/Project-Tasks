//
//  MyMessageTableViewCell.h
//  Magpie
//
//  Created by minh thao nguyen on 5/17/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface MyMessageTableViewCell : UITableViewCell
-(void)setMessageObj:(PFObject *)messageObj;
@end
