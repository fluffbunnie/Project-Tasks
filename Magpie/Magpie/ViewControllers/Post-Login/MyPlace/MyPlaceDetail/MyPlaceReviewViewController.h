//
//  MyPlaceReviewViewController.h
//  Magpie
//
//  Created by minh thao nguyen on 9/10/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "PropertyDetailWithMultipleListingView.h"

@interface MyPlaceReviewViewController : UIViewController<PropertyDetailWithMiltipleListingViewDelegate>
@property (nonatomic, strong) PFObject *propertyObj;
@property (nonatomic, strong) UIImage *capturedBackground;

@end
