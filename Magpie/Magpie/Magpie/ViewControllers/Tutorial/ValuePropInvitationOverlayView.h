//
//  ValuePropInvitationOverlayView.h
//  Magpie
//
//  Created by minh thao nguyen on 8/6/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ValuePropInvitationOverlayViewDelegate <NSObject>
-(void)goToSignup;
-(void)goToRequestCode;
@end

@interface ValuePropInvitationOverlayView : UIView
@property (nonatomic, weak) id<ValuePropInvitationOverlayViewDelegate> delegate;
-(void)showInParent;
-(void)dismiss;
@end
