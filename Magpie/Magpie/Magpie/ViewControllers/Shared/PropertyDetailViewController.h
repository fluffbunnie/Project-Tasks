//
//  PropertyDetailViewController.h
//  Magpie
//
//  Created by minh thao nguyen on 2/18/15.
//  Copyright (c) 2015 Easyswap Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "ImportPropertyWebView.h"
#import "PropertyDetailWithMultipleListingView.h"

@interface PropertyDetailViewController : UIViewController <ImportPropertyWebViewDelegate, PropertyDetailWithMiltipleListingViewDelegate>
@property (nonatomic, strong) PFObject *propertyObj;
@property (nonatomic, strong) UIImage *capturedBackground;
@end
