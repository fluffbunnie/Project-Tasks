//
//  FontColor.m
//  Easyswap
//
//  Created by minh thao nguyen on 12/11/14.
//  Copyright (c) 2014 Easyswap Inc. All rights reserved.
//

#import "FontColor.h"

@implementation FontColor

+(UIColor *)titleColor {
    return [UIColor colorWithRed:45/255.0 green:49/255.0 blue:58/255.0 alpha:1.0];
}

+(UIColor *)subTitleColor {
    return [UIColor colorWithRed:197/255.0 green:200/255.0 blue:205/255.0 alpha:1.0];
}

+(UIColor *)descriptionColor {
    return [UIColor colorWithRed:117/255.0 green:122/255.0 blue:135/255.0 alpha:1.0];
}

+(UIColor *)themeColor {
    return [UIColor colorWithRed:222/255.0 green:80/255.0 blue:87/255.0 alpha:1.0];
}

+(UIColor *)darkThemeColor {
    return [UIColor colorWithRed:200/255.0 green:45/255.0 blue:40/255.0 alpha:1.0];
}

+(UIColor *)appTitleColor {
    return [UIColor colorWithRed:76/255.0 green:76/255.0 blue:76/255.0 alpha:1.0];
}

+(UIColor *)defaultBackgroundColor {
    return [UIColor colorWithRed:207/255.0 green:210/255.0 blue:215/255.0 alpha:1.0];
}

+(UIColor *)checkColor {
    return [UIColor colorWithRed:125/255.0 green:189/255.0 blue:59/255.0 alpha:1.0];
}

+(UIColor *)tableSeparatorColor {
    return [UIColor colorWithRed:245/255.0 green:246/255.0 blue:250/255.0 alpha:1.0];
}

+(UIColor *)propertyImageBackgroundColor {
    return [UIColor colorWithRed:137/255.0 green:143/255.0 blue:155/255.0 alpha:1.0];
}

+(UIColor *)profileImageBackgroundColor {
    return [UIColor colorWithRed:245/255.0 green:246/255.0 blue:250/255.0 alpha:1.0];
}

+(UIColor *)messageOutgoingBackgroundColor {
    return [UIColor colorWithRed:0/255.0 green:190/255.0 blue:214/255.0 alpha:1];
}

+(UIColor *)messageIncomingBackgroundColor {
    return [UIColor colorWithRed:245/255.0 green:246/255.0 blue:250/255.0 alpha:1];
}


+(UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0, 0, 1, 1);
    // Create a 1 by 1 pixel context
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    [color setFill];
    UIRectFill(rect);   // Fill it with your color
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
@end
