//
//  FontColor.h
//  Easyswap
//
//  Created by minh thao nguyen on 12/11/14.
//  Copyright (c) 2014 Easyswap Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface FontColor : NSObject

+(UIColor *)titleColor;
+(UIColor *)subTitleColor;
+(UIColor *)descriptionColor;

+(UIColor *)themeColor;
+(UIColor *)darkThemeColor;
+(UIColor *)appTitleColor;
+(UIColor *)defaultBackgroundColor;

+(UIColor *)checkColor;

+(UIColor *)tableSeparatorColor;
+(UIColor *)propertyImageBackgroundColor;
+(UIColor *)profileImageBackgroundColor;

+(UIColor *)messageOutgoingBackgroundColor;
+(UIColor *)messageIncomingBackgroundColor;

+(UIImage *)imageWithColor:(UIColor *)color;

@end
