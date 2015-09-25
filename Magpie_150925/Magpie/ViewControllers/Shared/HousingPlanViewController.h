//
//  HousingPlanViewController.h
//  Magpie
//
//  Created by minh thao nguyen on 5/15/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface HousingPlanViewController : UIViewController <UIScrollViewDelegate>
@property (nonatomic, strong) PFObject *amenityObj;
@property (nonatomic, assign) NSInteger currentPageIndex;
@end