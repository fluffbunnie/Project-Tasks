//
//  MyPlaceAmenitySectionView.h
//  Magpie
//
//  Created by minh thao nguyen on 5/25/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "MyPlaceAmenityItemTableViewCell.h"

@interface MyPlaceAmenitySectionView : UIView <UITableViewDataSource, UITableViewDelegate, MyPlaceAmenityItemTableViewCellDelegate>
-(void)setAmenityObj:(PFObject *)amenityObj andAmenitySectionType:(NSInteger)type;
-(NSMutableArray *)getAllAmentityItem;
@end
