//
//  FontColor.h
//  Magpie
//
//  Created by minh thao nguyen on 4/21/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface FontColor : NSObject

+(UIColor *)titleColor;
+(UIColor *)subTitleColor;
+(UIColor *)descriptionColor;

+(UIColor *)themeColor;
+(UIColor *)navigationButtonHighlightColor;
+(UIColor *)darkThemeColor;
+(UIColor *)appTitleColor;
+(UIColor *)defaultBackgroundColor;
+(UIColor *)backgroundOverlayColor;

+(UIColor *)fbColor;
+(UIColor *)darkFbColor;

+(UIColor *)twitterColor;
+(UIColor *)darkTwitterColor;

+(UIColor *)linkedInColor;
+(UIColor *)darkLinkedInColor;

+(UIColor *)checkColor;
+(UIColor *)approveColor;

+(UIColor *)tableSeparatorColor;
+(UIColor *)propertyImageBackgroundColor;
+(UIColor *)profileImageBackgroundColor;

+(UIColor *)messageOutgoingBackgroundColor;
+(UIColor *)messageIncomingBackgroundColor;

+(UIImage *)imageWithColor:(UIColor *)color;



//The new theme color
+(UIColor *)greenThemeColor;
+(UIColor *)darkGreenThemeColor;

@end
