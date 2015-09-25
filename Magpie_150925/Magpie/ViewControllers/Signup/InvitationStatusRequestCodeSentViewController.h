//
//  InvitationStatusRequestCodeSentViewController.h
//  Magpie
//
//  Created by minh thao nguyen on 8/18/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InvitationStatusRequestCodeSentView.h"
#import <Parse/Parse.h>

@interface InvitationStatusRequestCodeSentViewController : UIViewController <InvitationStatusRequestCodeSentViewDelegate>
@property (nonatomic, strong) PFObject *invitationCodeObj;
-(void)setEmail:(NSString *)email;
@end
