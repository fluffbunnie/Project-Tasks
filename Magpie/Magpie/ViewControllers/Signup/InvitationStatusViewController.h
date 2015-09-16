//
//  InvitationStatusViewController.h
//  Magpie
//
//  Created by minh thao nguyen on 8/9/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RequestInvitationSuccessView.h"
#import <Parse/Parse.h>

@interface InvitationStatusViewController : UIViewController <RequestInvitationSuccessViewDelegate>
@property (nonatomic, strong) PFObject *invitationCodeObj;
-(void)setEmail:(NSString *)email;
@end
