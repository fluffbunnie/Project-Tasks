//
//  DeeplinkHander.m
//  Magpie
//
//  Created by minh thao nguyen on 9/2/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import "DeeplinkHander.h"
#import "SignUpWithInvitationViewController.h"
#import "PasswordResetLoadingViewController.h"
#import "PasswordResetInvalidLinkViewController.h"
#import "ChatViewLoadingViewController.h"
#import "MyPlaceReviewViewController.h"
#import "MyPlaceListViewController.h"
#import "FontColor.h"
#import "UserManager.h"
#import "Device.h"
#import "MyProfileViewController.h"

@implementation DeeplinkHander
/**
 * Go to the sign up view with a given invitation code params and window
 * @param NSDictionary
 * @param UIWindow
 */
+(void)signUpWithInvitation:(NSDictionary *)params andWindow:(UIWindow *)window {
    NSString *code = params[@"code"] ? params[@"code"] : @"";
    NSString *email = params[@"email"] ? params[@"email"] : @"";
    
    SignUpWithInvitationViewController *signupViewController = [[SignUpWithInvitationViewController alloc] init];
    signupViewController.code = code;
    signupViewController.email = email;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:signupViewController];
    window.rootViewController = navigationController;
    [window makeKeyAndVisible];
}

/**
 * Go to the reset password page using deep linking param and window
 * @param NSDictionary
 * @param UIWindow
 */
+(void)resetPassword:(NSDictionary *)params andWindow:(UIWindow *)window {
    NSString *email = params[@"email"] ? params[@"email"] : @"";
    NSTimeInterval time = [params[@"createdAt"] doubleValue] ? [params[@"createdAt"] doubleValue] : 0;
    
    NSDictionary *passwordDic = params[@"password"] ? params[@"password"] : nil;
    NSString *password = @"";
    if (passwordDic) password = passwordDic[@"base64"] ? passwordDic[@"base64"] : @"";
    
    NSTimeInterval currentTime = [[[NSDate alloc] init] timeIntervalSince1970];
    if (currentTime - time > 24 * 60 * 60) {
        PasswordResetInvalidLinkViewController *invalidLinkViewController = [[PasswordResetInvalidLinkViewController alloc] init];
        invalidLinkViewController.titleTextString = LINK_EXPIRE_TEXT;
        invalidLinkViewController.email = email;
        
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:invalidLinkViewController];
        window.rootViewController = navigationController;
        [window makeKeyAndVisible];
    } else {
        PasswordResetLoadingViewController *passwordResetLoadingViewController = [[PasswordResetLoadingViewController alloc] init];
        passwordResetLoadingViewController.email = email;
        passwordResetLoadingViewController.timestamp = time;
        passwordResetLoadingViewController.base64Password = password;
        
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:passwordResetLoadingViewController];
        window.rootViewController = navigationController;
        [window makeKeyAndVisible];
    }
}

/**
 * Go to the conversation with the given trip detail and open it
 * @param NSDictionary
 * @param UIWindow
 */
+(void)checkTripDetail:(NSDictionary *)params andWindow:(UIWindow *)window {
    NSString *tripId = params[@"tripId"] ? params[@"tripId"]: @"";
    ChatViewLoadingViewController *chatViewLoadingViewController = [[ChatViewLoadingViewController alloc] init];
    chatViewLoadingViewController.tripId = tripId;
    
    if (window.rootViewController) {
        UINavigationController *navController = (UINavigationController *)window.rootViewController;
        [navController pushViewController:chatViewLoadingViewController animated:YES];
    } else {
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:chatViewLoadingViewController];
        window.rootViewController = navigationController;
        [window makeKeyAndVisible];
    }
}

/**
 * Go to my place review
 * @param NSDictionary
 * @param UIWindow
 */
+(void)checkYourPlace:(NSDictionary *)params andWindow:(UIWindow *)window {
    NSString *placeId = params[@"propertyObj"] ? params[@"propertyObj"] : @"";
    
    PFQuery *query = [[PFQuery alloc] initWithClassName:@"Property"];
    [query whereKey:@"objectId" equalTo:placeId];
    [query includeKey:@"owner"];
    [query includeKey:@"amenity"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (objects.count > 0 && !error) {
            MyPlaceReviewViewController *myPlaceReviewController = [[MyPlaceReviewViewController alloc] init];
            myPlaceReviewController.propertyObj = objects[0];
            if (window.rootViewController) {
                myPlaceReviewController.capturedBackground = [Device captureScreenshot];
                UINavigationController *navController = (UINavigationController *)window.rootViewController;
                [navController pushViewController:myPlaceReviewController animated:YES];
            } else {
                myPlaceReviewController.capturedBackground = [FontColor imageWithColor:[UIColor whiteColor]];
                UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:myPlaceReviewController];
                window.rootViewController = navigationController;
                [window makeKeyAndVisible];
            }
        } else if (!window.rootViewController) {
            [[UserManager sharedUserManager] getUserWithCompletionHandler:^(PFObject *userObj) {
                MyPlaceListViewController *myPlaceListViewController = [[MyPlaceListViewController alloc] init];
                myPlaceListViewController.userObj = userObj;
                UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:myPlaceListViewController];
                window.rootViewController = navigationController;
                [window makeKeyAndVisible];
            }];
        } else {
            [[UserManager sharedUserManager] getUserWithCompletionHandler:^(PFObject *userObj) {
                MyPlaceListViewController *myPlaceListViewController = [[MyPlaceListViewController alloc] init];
                myPlaceListViewController.userObj = userObj;
                UINavigationController *navController = (UINavigationController *)window.rootViewController;
                [navController pushViewController:myPlaceListViewController animated:YES];
            }];
        }
    }];
}

/**
 * Go to the user profile view
 * @param NSDictionary
 * @param UIWindow
 */
+(void)checkYourProfile:(NSDictionary *)params andWindow:(UIWindow *)window {
    MyProfileViewController *myProfileViewController = [[MyProfileViewController alloc] init];
    if (window.rootViewController) {
        UINavigationController *navController = (UINavigationController *)window.rootViewController;
        [navController pushViewController:myProfileViewController animated:YES];
    } else {
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:myProfileViewController];
        window.rootViewController = navigationController;
        [window makeKeyAndVisible];
    }
}

@end
