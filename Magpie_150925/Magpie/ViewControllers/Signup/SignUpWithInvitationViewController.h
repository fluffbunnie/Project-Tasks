//
//  SignUpWithInvitationViewController.h
//  Magpie
//
//  Created by minh thao nguyen on 7/20/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SignupWithInvitationView.h"

@interface SignUpWithInvitationViewController : UIViewController <SignUpWithInvitationViewDelegate>
@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSString *email;
@end
