//
//  HostPopup.h
//  Magpie
//
//  Created by minh thao nguyen on 5/29/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@protocol HostPopupDelegate <NSObject>
-(void)hostApprovedTripObj:(PFObject *)tripObj;
@end

@interface HostPopup : UIView 
@property (nonatomic, weak) id<HostPopupDelegate> hostPopupDelegate;
-(void)showInView:(UIView *)view;
-(void)setNewTripObj:(PFObject *)tripObj;
-(void)dismiss;
@end
