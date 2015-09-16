//
//  GuestPopup.h
//  Magpie
//
//  Created by minh thao nguyen on 5/28/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "TTTAttributedLabel.h"

@protocol GuestPopupDelegate <NSObject>
-(void)cancelTripObj:(PFObject *)tripObj;
@end

@interface GuestPopup : UIView <TTTAttributedLabelDelegate, UIGestureRecognizerDelegate>
@property (nonatomic, weak) id<GuestPopupDelegate> guestPopupDelegate;
-(void)showInView:(UIView *)view;
-(void)setNewTripObj:(PFObject *)tripObj;
-(void)dismiss;
@end
