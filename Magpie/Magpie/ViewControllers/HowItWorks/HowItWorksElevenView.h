//
//  ValuePropThirdView.h
//  Magpie
//
//  Created by Quynh Cao on 7/29/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HowItWorksViewController.h"

@interface HowItWorksElevenView : UIView <HowItWorkViewDelegate>
@property (nonatomic, weak) id<HowItWorkViewDelegate> howItWorksViewDelegate;
-(void)showView;
-(void)hideView;
@end
