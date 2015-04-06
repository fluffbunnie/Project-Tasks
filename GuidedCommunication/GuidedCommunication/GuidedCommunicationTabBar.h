//
//  GuidedCommunicationTabBar.h
//  GuidedCommunication
//
//  Created by minh thao nguyen on 4/5/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GuidedCommunicationTabBarDelegate <NSObject>

-(void)showGuestTypeView;
-(void)showNumGuestsView;
-(void)showDatePickerView;

@end

@interface GuidedCommunicationTabBar : UIView

@property (nonatomic, weak) id<GuidedCommunicationTabBarDelegate> tabBarDelegate;

@property (nonatomic, strong) UIButton *guestTypeButton;
@property (nonatomic, strong) UIButton *numGuestButton;
@property (nonatomic, strong) UIButton *datePickerButton;

-(void)showViewAnimated:(BOOL)animate;
-(void)hideViewAnimated:(BOOL)animate;

//and simple class to highlight the tab button
-(void)highlightGuestTypeButton;
-(void)highlightNumGuestsButton;
-(void)highlightDatePickerButton;

@end
