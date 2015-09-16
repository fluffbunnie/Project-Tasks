//
//  DeeplinkHander.h
//  Magpie
//
//  Created by minh thao nguyen on 9/2/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DeeplinkHander : NSObject
+(void)signUpWithInvitation:(NSDictionary *)params andWindow:(UIWindow *)window;
+(void)resetPassword:(NSDictionary *)params andWindow:(UIWindow *)window;
+(void)checkTripDetail:(NSDictionary *)params andWindow:(UIWindow *)window;
@end
