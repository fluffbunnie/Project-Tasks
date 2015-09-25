//
//  MyProfileNudgeViewController.h
//  Magpie
//
//  Created by minh thao nguyen on 9/13/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface MyProfileNudgeViewController : UIViewController
@property (nonatomic, strong) UIImage *capturedBackground;
@property (nonatomic, strong) PFObject *userObj;
@end
