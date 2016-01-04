//
//  GuidedInteractionHorizontalSwipeCardView.h
//  Magpie
//
//  Created by minh thao nguyen on 7/27/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString * const HUONG_LOCATION = @"San Francisco, CA";
static NSString * const MINH_LOCATION = @"Los Angeles, CA";
static NSString * const KAT_LOCATION =  @"Carmel, CA";

static NSString * const MINH_PROPERTY_IMAGE = @"OnboardingCurrentPropertyImage";
static NSString * const MINH_USER_IMAGE = @"OnboardingCurrentProfileImage";
static NSString * const HUONG_PROPERTY_IMAGE = @"OnboardingNextPropertyImage";
static NSString * const HUONG_USER_IMAGE = @"OnboardingNextProfileImage";
static NSString * const KAT_PROPERTY_IMAGE = @"OnboardingPrevPropertyImage";
static NSString * const KAT_USER_IMAGE = @"OnboardingPrevProfileImage";


@interface GuidedInteractionHorizontalSwipeCardView : UIView
-(void)setViewIndex:(int)index;
-(void)animateView;
@end
