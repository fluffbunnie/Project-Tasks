//
//  HowItWorksSecondView.h
//  Magpie
//
//  Created by kakalot on 7/29/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HowItWorksViewController.h"

@interface HowItWorksThirdView : UIView <HowItWorkViewDelegate>
@property (nonatomic, assign) AnimationStausType animationStatus;
@property (nonatomic, weak) id<HowItWorkViewDelegate> howItWorksViewDelegate;
-(void)showView;
-(void)hideView;
-(void)stopAnmationAndShowView;
@end