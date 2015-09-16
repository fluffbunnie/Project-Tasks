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

+(NSString *)getDeviceName;
+(BOOL)isIphone4;
+(BOOL)isIphone5;
+(BOOL)isIphone6;
+(BOOL)isIphone6Plus;

+(UIImage *)captureDeviceImage:(UIView *)view;
+(UIImage *)captureScreenshot;

@end
