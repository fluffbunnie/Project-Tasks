//
//  AppFeedbackViewController.h
//  Magpie
//
//  Created by minh thao nguyen on 4/23/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface AppFeedbackViewController : UIViewController <UITextViewDelegate>

@property (nonatomic, strong) PFObject *userObj;
@end
