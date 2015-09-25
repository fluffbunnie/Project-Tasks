//
//  NotificationHandler.m
//  Magpie
//
//  Created by minh thao nguyen on 5/16/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import "NotificationHandler.h"
#import <Parse/Parse.h>
#import "UserManager.h"
#import "ChatViewController.h"
#import "AppDelegate.h"
#import "TWMessageBarManager.h"
#import "ChatViewController.h"
#import "UserManager.h"
#import "HomePageViewController.h"
#import "ChatMessages.h"

NSString * const NOTIFICATION_TYPE = @"type";
NSString * const NOTIFICATION_TYPE_MESSAGE = @"message";
NSString * const NOTIFICATION_TYPE_MATCH = @"match";
NSString * const NOTIFICATION_TYPE_GENERAL = @"general";

NSString * const NOTIFICATION_MESSAGE_ID = @"message_id";
NSString * const NOTIFICATION_MESSAGE_SENDER_ID = @"message_sender_id";
NSString * const NOTIFICATION_MESSAGE_SENDER_NAME = @"message_sender_name";
NSString * const NOTIFICATION_MESSAGE_SENDER_PHOTO = @"message_sender_photo";
NSString * const NOTIFICATION_MESSAGE_CONTENT = @"message_content";
NSString * const NOTIFICATION_MESSAGE_CONTENT_TYPE = @"message_content_type";

static NSString * const BOOK_NOTIF_MESSAGE = @"has requested a stay at your place";
static NSString * const CONFIRM_NOTIF_MESSAGE = @"has approved your staying request";
static NSString * const CANCEL_NOTIF_MESSAGE = @"has canceled the trip to your place";

@implementation NotificationHandler
#pragma mark - public methods
/**
 * Handle the behavior when the application received a notification
 * @param UIApplication
 * @param NSDictionary
 * @param UIWindow
 * @param Completion Handler
 */
+(void)notificationForApplication:(UIApplication *)application withInfo:(NSDictionary *)userInfo andWindow:(UIWindow *)window withCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    NSString *notificationType = [userInfo objectForKey:NOTIFICATION_TYPE];
    if ([notificationType isEqualToString:NOTIFICATION_TYPE_MESSAGE]) {
        [self messageNotificationForApplication:application withUserInfo:userInfo andWindow:window withCompletionHandler:completionHandler];
    } else completionHandler(UIBackgroundFetchResultNewData);
}

/**
 * Handle the behavior when app is lauch using notification
 * @param NSDictionary
 * @param UIWindow
 */
+(void)launchFromNotificationWithUserInfo:(NSDictionary *)userInfo andWindow:(UIWindow *)window {
    NSString *notificationType = [userInfo objectForKey:NOTIFICATION_TYPE];
    if ([notificationType isEqualToString:NOTIFICATION_TYPE_MESSAGE]) {
        [self messageNotificationForActiveApplicationWithUserInfo:userInfo andWindow:window];
    } else if (!window.rootViewController) {
        HomePageViewController * homePageViewController = [[HomePageViewController alloc] init];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:homePageViewController];
        window.rootViewController = navigationController;
        [window makeKeyAndVisible];
    }
}

#pragma mark - message notification
/**
 * Handle the remote message push notification when the app is active
 * @param UIApplication
 * @param NSDictionary
 * @param UIWindow
 * @param Completion Handler
 */
+(void)messageNotificationForApplication:(UIApplication *)application withUserInfo:(NSDictionary *)userInfo andWindow:(UIWindow *)window withCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    UINavigationController *rootViewController = (UINavigationController *)window.rootViewController;
    
    NSString *senderId = userInfo[NOTIFICATION_MESSAGE_SENDER_ID];
    NSString *senderName = userInfo[NOTIFICATION_MESSAGE_SENDER_NAME];
    NSString *senderPhoto = userInfo[NOTIFICATION_MESSAGE_SENDER_PHOTO];
    NSString *messageContent = userInfo[NOTIFICATION_MESSAGE_CONTENT];
    NSString *messageContentType = userInfo[NOTIFICATION_MESSAGE_CONTENT_TYPE];
    
    NSString *currentConversation = ((AppDelegate *)[UIApplication sharedApplication].delegate).currentChattingRecipient;
    if (currentConversation == nil || ![currentConversation isEqualToString:senderId] || ![rootViewController.viewControllers.lastObject isKindOfClass:ChatViewController.class]) {
        //then we show the new notification
        PFQuery *query = [PFQuery queryWithClassName:@"Users"];
        [query getObjectInBackgroundWithId:senderId block:^(PFObject *object, NSError *error) {
            if (object == nil || error) completionHandler(UIBackgroundFetchResultNoData);
            else {
                [[UserManager sharedUserManager] getUserWithCompletionHandler:^(PFObject *userObj) {
                    if (application.applicationState == UIApplicationStateActive) {
                        NSString *notificationMessage = messageContent;
                        if ([messageContentType isEqualToString:MESSAGE_TYPE_BOOK]) notificationMessage = BOOK_NOTIF_MESSAGE;
                        else if ([messageContentType isEqualToString:MESSAGE_TYPE_CONFIRM]) notificationMessage = CONFIRM_NOTIF_MESSAGE;
                        else if ([messageContentType isEqualToString:MESSAGE_TYPE_CANCEL]) notificationMessage = CANCEL_NOTIF_MESSAGE;
                        [[TWMessageBarManager sharedInstance] showMessageWithTitle:senderName description:notificationMessage iconUrl:senderPhoto duration:5 callback:^{
                            ChatViewController *chatViewController = [[ChatViewController alloc] init];
                            chatViewController.userObj = userObj;
                            chatViewController.targetUserObj = object;
                            [rootViewController pushViewController:chatViewController animated:YES];
                        }];
                    } else {
                        ChatViewController *chatViewController = [[ChatViewController alloc] init];
                        chatViewController.userObj = userObj;
                        chatViewController.targetUserObj = object;
                        [rootViewController pushViewController:chatViewController animated:YES];
                    }
                    completionHandler(UIBackgroundFetchResultNewData);
                }];
            }
        }];
    } else {
        ChatViewController *currentChatView = (ChatViewController *)[rootViewController.viewControllers lastObject];
        [currentChatView receiveMessageWithContent:messageContent andContentType:messageContentType];
        completionHandler(UIBackgroundFetchResultNewData);
    }
}

/**
 * Handle the remote push notification when the app is inactive
 * @param NSDictionary
 * @param UIWindow
 */
+(void)messageNotificationForActiveApplicationWithUserInfo:(NSDictionary *)userInfo andWindow:(UIWindow *)window {
    NSString *senderId = userInfo[NOTIFICATION_MESSAGE_SENDER_ID];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Users"];
    [query getObjectInBackgroundWithId:senderId block:^(PFObject *object, NSError *error) {
        if (object == nil || error) {
            if (!window.rootViewController) {
                HomePageViewController * homePageViewController = [[HomePageViewController alloc] init];
                UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:homePageViewController];
                window.rootViewController = navigationController;
                [window makeKeyAndVisible];
            }
        } else {
            [[UserManager sharedUserManager] getUserWithCompletionHandler:^(PFObject *userObj) {
                ChatViewController *chatViewController = [[ChatViewController alloc] init];
                chatViewController.userObj = userObj;
                chatViewController.targetUserObj = object;
                
                UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:chatViewController];
                window.rootViewController = navigationController;
                [window makeKeyAndVisible];
            }];
        }
    }];

}

#pragma mark - other helper methods
+(NSString *)getMessageNotificationDescriptionForMessageFromUserWithName:(NSString *)name content:(NSString *)content andContentType:(NSString *)contentType {
    if ([contentType isEqualToString:MESSAGE_TYPE_TEXT]) {
        return content;
    } else return content; //TODO change this when guided communication is set up.
}

@end
