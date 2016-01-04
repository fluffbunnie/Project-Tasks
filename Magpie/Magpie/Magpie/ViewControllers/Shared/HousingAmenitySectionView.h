//
//  HousingAmenitySectionView.h
//  Magpie
//
//  Created by minh thao nguyen on 5/19/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AmenityDisplayTableViewCell.h"
#import "AmenityItem.h"

@interface HousingAmenitySectionView : UIView <UITableViewDataSource, UITableViewDelegate>
-(void)setAmenities:(NSArray *)amenities;
@end
