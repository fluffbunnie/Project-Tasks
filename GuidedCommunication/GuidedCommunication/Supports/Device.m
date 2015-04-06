//
//  Device.m
//  Easyswap
//
//  Created by minh thao nguyen on 12/9/14.
//  Copyright (c) 2014 Easyswap Inc. All rights reserved.
//

#import "Device.h"
#import <sys/sysctl.h>
#import <UIKit/UIKit.h>

@implementation Device

+(BOOL)isIphone4 {
    float screenHeight = [[UIScreen mainScreen] bounds].size.height;
    return screenHeight == 480;
}

+(BOOL)isIphone5 {
    float screenHeight = [[UIScreen mainScreen] bounds].size.height;
    return screenHeight == 568;
}

+(BOOL)isIphone6 {
    float screenHeight = [[UIScreen mainScreen] bounds].size.height;
    return screenHeight == 667;
}

+(BOOL)isIphone6Plus {
    float screenHeight = [[UIScreen mainScreen] bounds].size.height;
    return screenHeight == 736;
}


/**
 * Get the name of the device
 * @return NSString
 */
+(NSString *)getDeviceName {
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    return [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
}

/**
 * Check whether the device has iphone 4 screen
 * @return boolean
 */
+(BOOL)hasIphone4Screen {
    return [[self getDeviceName] rangeOfString:@"iPhone4"].location != NSNotFound;
}

/**
 * Check whether the device has iphone 5 screen
 * @return boolean
 */
+(BOOL)hasIphone5Screen {
    BOOL isIphone5 =[[self getDeviceName] rangeOfString:@"iPhone5"].location != NSNotFound;
    BOOL isIphone5s = [[self getDeviceName] rangeOfString:@"iPhone6"].location != NSNotFound;
    BOOL isIpod5 = [[self getDeviceName] isEqualToString:@"iPod5,1"];
    return isIphone5 || isIphone5s || isIpod5;
}

/**
 * Check whether the device has iphone 6 screen
 * @return boolean
 */
+(BOOL) hasIphone6Screen {
    return [[self getDeviceName] isEqualToString:@"iPhone7,2"];
}

/**
 * Check whether the device has iphone 6 plus screen
 * @return boolean
 */
+(BOOL)hasIphone6PlusScreen {
    return [[self getDeviceName] isEqualToString:@"iPhone7,1"];
}


/**
 * Take a snapshot of the device
 * @param device top view
 * @return image
 */
+(UIImage *)captureDeviceImage:(UIView *)view {
    UIGraphicsBeginImageContext(CGSizeMake(view.frame.size.width, view.frame.size.height));
    [view drawViewHierarchyInRect:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height) afterScreenUpdates:YES];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

/**
 * Capture the screen
 * @param window
 * @return image
 */
+(UIImage *)captureScreen:(UIWindow *)window {
    CALayer *layer;
    layer = window.layer;
    UIGraphicsBeginImageContextWithOptions(window.bounds.size, NO, 1.0f);
    [layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *screenImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return screenImage;
}

@end
