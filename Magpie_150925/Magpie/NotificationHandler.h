//
//  NotificationHandler.h
//  Magpie
//
//  Created by minh thao nguyen on 5/16/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

extern NSString * const NOTIFICATION_TYPE;
extern NSString * const NOTIFICATION_TYPE_MESSAGE;
extern NSString * const NOTIFICATION_TYPE_MATCH;
extern NSString * const NOTIFICATION_TYPE_GENERAL;

extern NSString * const NOTIFICATION_MESSAGE_ID;
extern NSString * const NOTIFICATION_MESSAGE_SENDER_ID;
extern NSString * const NOTIFICATION_MESSAGE_SENDER_NAME;
extern NSString * const NOTIFICATION_MESSAGE_SENDER_PHOTO;
extern NSString * const NOTIFICATION_MESSAGE_CONTENT;
extern NSString * const NOTIFICATION_MESSAGE_CONTENT_TYPE;

@interface NotificationHandler : NSObject
+(void)notificationForApplication:(UIApplication *)application withInfo:(NSDictionary *)userInfo andWindow:(UIWindow *)window withCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler;
+(void)launchFromNotificationWithUserInfo:(NSDictionary *)userInfo andWindow:(UIWindow *)window;
@end
