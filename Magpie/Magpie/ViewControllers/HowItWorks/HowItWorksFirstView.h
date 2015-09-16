//
//  ValuePropFirstView.h
//  Magpie
//
//  Created by minh thao nguyen on 7/29/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "MFLHintLabel.h"
#import "HowItWorksViewController.h"
@interface HowItWorksFirstView : UIView
@property (nonatomic, weak) id<HowItWorkViewDelegate> howItWorksViewDelegate;
-(void)showView;
-(void)hideView;
@end
