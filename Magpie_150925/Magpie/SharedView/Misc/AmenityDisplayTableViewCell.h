//
//  AmenityDisplayTableViewCell.h
//  Magpie
//
//  Created by minh thao nguyen on 5/18/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AmenityItem.h"

@interface AmenityDisplayTableViewCell : UITableViewCell
-(void)setAmenityItem:(AmenityItem *)item;
+(CGFloat)heightForAmenity:(AmenityItem *)item;
@end
