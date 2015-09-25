//
//  IncomingStayRequestViewController.h
//  Magpie
//
//  Created by minh thao nguyen on 9/15/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "TTTAttributedLabel.h"

@interface IncomingStayRequestViewController : UIViewController <TTTAttributedLabelDelegate>
@property (nonatomic, strong) UIImage *capturedBackground;
@property (nonatomic, strong) PFObject *tripObj;
@end
