//
//  PropertyDetailLocationTableViewCell.h
//  Easyswap
//
//  Created by minh thao nguyen on 12/21/14.
//  Copyright (c) 2014 Easyswap Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface PropertyDetailLocationTableViewCell : UITableViewCell

-(void)setPropertyObject:(PFObject *)propertyObj;
-(CGFloat)viewHeight;

@end
