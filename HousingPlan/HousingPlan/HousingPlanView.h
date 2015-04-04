//
//  HousingPlanView.h
//  HousingPlan
//
//  Created by minh thao nguyen on 4/1/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import <UIKit/UIKit.h>

#define FRAME_SCALE_RATIO 65.0/67.0

@protocol HousingPlanViewDelegate <NSObject>

// There are essentially 5 items in the housing plan, namely:
//          * living room
//          * bedroom
//          * bathroom
//          * kitchen/diningroom
//          * and all others stuffs that doesn't fit into any of the category
//
// This is the call back function when any of the items got clicked
-(void)onLivingRoomItemClicked;
-(void)onBedroomItemClick;
-(void)onBathroomItemClick;
-(void)onKitchenAndDiningItemClick;
-(void)onOthersClick;

@end

@interface HousingPlanView : UIView

//the delegate to handle all the call back
@property (nonatomic, weak) id<HousingPlanViewDelegate> planDelegate;

@end
