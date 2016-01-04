//
//  PasswordResetInvalidLinkViewController.h
//  Magpie
//
//  Created by minh thao nguyen on 9/2/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString * const LINK_EXPIRE_TEXT = @"The password reset link has expired";
static NSString * const PASSWORD_RESETTED_TEXT = @"The password reset link has already been used";

@interface PasswordResetInvalidLinkViewController : UIViewController
@property (nonatomic, strong) NSString *titleTextString;
@property (nonatomic, strong) NSString *email;
@end
