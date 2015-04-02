//
//  HousingPlanView.h
//  HousingPlan
//
//  Created by minh thao nguyen on 4/1/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HousingPlanViewDelegate <NSObject>

// There are essentially 6 items in the housing plan, namely:
//          * living room
//          * bedroom
//          * bathroom
//          * kitchen/diningroom
//          * network and communications
//          * and all others stuffs that doesn't fit into any of the category
//
// This is the call back function when any of the items got clicked
-(void)onLivingRoomItemClicked;
-(void)onBedroomItemClick;
-(void)onBathroomItemClick;
-(void)onKitchenAndDiningItemClick;
-(void)onNetworkAndCommunicationItemClick;
-(void)onOthersClick;

@end

@interface HousingPlanView : UIView

//the delegate to handle all the call back
@property (nonatomic, weak) id<HousingPlanViewDelegate> planDelegate;

//these are the button for each of the bucket items
@property (nonatomic, strong) UIButton *livingRoomButton;
@property (nonatomic, strong) UIButton *bedroomButton;
@property (nonatomic, strong) UIButton *bathroomButton;
@property (nonatomic, strong) UIButton *kitchenAndDiningRoomButton;
@property (nonatomic, strong) UIButton *communicationButton;
@property (nonatomic, strong) UIButton *othersButton;

@end
