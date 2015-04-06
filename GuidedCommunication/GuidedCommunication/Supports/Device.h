//
//  Device.h
//  Easyswap
//
//  Created by minh thao nguyen on 12/9/14.
//  Copyright (c) 2014 Easyswap Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Device : NSObject

//you may want to use these methods to test on the simulators
+(BOOL)isIphone4;
+(BOOL)isIphone5;
+(BOOL)isIphone6;
+(BOOL)isIphone6Plus;


+(BOOL)hasIphone4Screen;
+(BOOL)hasIphone5Screen;
+(BOOL)hasIphone6Screen;
+(BOOL)hasIphone6PlusScreen;

+(UIImage *)captureDeviceImage:(UIView *)view;
+(UIImage *)captureScreen:(UIWindow *)window;

@end
