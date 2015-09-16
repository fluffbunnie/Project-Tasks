//
//  PropertyDetailHousingPlanTableViewCell.h
//  Magpie
//
//  Created by minh thao nguyen on 4/29/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HousingLayoutView.h"

@protocol PropertyDetailHousingPlanDelegate <NSObject>
-(void)housingLayoutButtonClickAtIndex:(NSInteger)index;
@end

@interface PropertyDetailHousingPlanTableViewCell : UITableViewCell <HousingLayoutViewDelegate>
@property (nonatomic, weak) id<PropertyDetailHousingPlanDelegate> housingPlanDelegate;
-(CGFloat)viewHeight;
@end
