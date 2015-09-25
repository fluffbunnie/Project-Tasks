//
//  PasswordResetLoadingViewController.h
//  Magpie
//
//  Created by minh thao nguyen on 9/2/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PasswordResetLoadingViewController : UIViewController <UIAlertViewDelegate>
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *base64Password;
@property (nonatomic, assign) NSTimeInterval timestamp;
@end
