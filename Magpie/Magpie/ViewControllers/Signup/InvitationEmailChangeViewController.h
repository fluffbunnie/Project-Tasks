//
//  InvitationEmailChangeViewController.h
//  Magpie
//
//  Created by minh thao nguyen on 8/19/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InvitationEmailChangeViewController : UIViewController <UITextFieldDelegate>
@property (nonatomic, strong) UIImage *capturedBackground;
@property (nonatomic, strong) NSString *email;
@end
