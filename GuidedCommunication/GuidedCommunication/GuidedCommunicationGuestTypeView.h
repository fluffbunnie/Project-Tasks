//
//  GuidedCommunicationGuestTypeView.h
//  GuidedCommunication
//
//  Created by minh thao nguyen on 4/4/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GuidedCommunicationGuestTypeViewDelegate <NSObject>
-(void)onGuestTypeSelection:(NSInteger)guestType;
@end

@interface GuidedCommunicationGuestTypeView : UIView

@property (nonatomic, weak) id<GuidedCommunicationGuestTypeViewDelegate> guestTypeDelegate;

-(void)setGuestType:(NSInteger)guestType;

@end
