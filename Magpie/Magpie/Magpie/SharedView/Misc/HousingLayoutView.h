//
//  HousingLayoutView.h
//  Magpie
//
//  Created by minh thao nguyen on 4/28/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSInteger HOUSING_LAYOUT_HOME_INDEX = 0;
static NSInteger HOUSING_LAYOUT_BEDROOM_INDEX = 1;
static NSInteger HOUSING_LAYOUT_BATHROOM_INDEX = 2;
static NSInteger HOUSING_LAYOUT_LIVINGROOM_INDEX = 3;
static NSInteger HOUSING_LAYOUT_KITCHEN_INDEX = 4;

static NSString * HOUSING_LAYOUT_BATHROOM_HIGHLIGHT_IMG_NAME = @"HousingLayoutBathroomHighlight";
static NSString * HOUSING_LAYOUT_BATHROOM_NORMAL_IMG_NAME = @"HousingLayoutBathroomNormal";
static NSString * HOUSING_LAYOUT_BEDROOM_HIGHLIGHT_IMG_NAME = @"HousingLayoutBedroomHighlight";
static NSString * HOUSING_LAYOUT_BEDROOM_NORMAL_IMG_NAME = @"HousingLayoutBedroomNormal";
static NSString * HOUSING_LAYOUT_HOME_HIGHLIGHT_IMG_NAME = @"HousingLayoutHomeHighlight";
static NSString * HOUSING_LAYOUT_HOME_NORMAL_IMG_NAME = @"HousingLayoutHomeNormal";
static NSString * HOUSING_LAYOUT_KITCHEN_HIGHLIGHT_IMG_NAME = @"HousingLayoutKitchenHighlight";
static NSString * HOUSING_LAYOUT_KITCHEN_NORMAL_IMG_NAME = @"HousingLayoutKitchenNormal";
static NSString * HOUSING_LAYOUT_LIVINGROOM_HIGHLIGHT_IMG_NAME = @"HousingLayoutLivingroomHighlight";
static NSString * HOUSING_LAYOUT_LIVINGROOM_NORMAL_IMG_NAME = @"HousingLayoutLivingroomNormal";


@protocol HousingLayoutViewDelegate <NSObject>
-(void)housingLayoutButtonClickAtIndex:(NSInteger)index;
@end

@interface HousingLayoutView : UIView
@property (nonatomic, weak) id<HousingLayoutViewDelegate> housingLayoutDelegate;
@end
