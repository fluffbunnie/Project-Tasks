//
//  AppDelegate.m
//  Magpie
//
//  Created by minh thao nguyen on 4/21/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import "AppDelegate.h"
#import "FontColor.h"
#import "HomePageViewController.h"
#import "GuidedInteractionFirstViewController.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "ValuePropViewController.h"
#import "UserManager.h"
#import "NotificationHandler.h"
#import "Mixpanel.h"
#import "Device.h"
#import "PythonParsingRequest.h"
#import "HomePageRequestForUpdatePopupView.h"
#import "InvitationStatusLoadingViewController.h"
#import "InvitationStatusWithPushNotificationViewController.h"
#import "Branch.h"
#import "DeeplinkHander.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

-(uint64_t)getFreeDiskspace {
    uint64_t totalSpace = 0;
    uint64_t totalFreeSpace = 0;
    NSError *error = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSDictionary *dictionary = [[NSFileManager defaultManager] attributesOfFileSystemForPath:[paths lastObject] error: &error];
    
    if (dictionary) {
        NSNumber *fileSystemSizeInBytes = [dictionary objectForKey: NSFileSystemSize];
        NSNumber *freeFileSystemSizeInBytes = [dictionary objectForKey:NSFileSystemFreeSize];
        totalSpace = [fileSystemSizeInBytes unsignedLongLongValue];
        totalFreeSpace = [freeFileSystemSizeInBytes unsignedLongLongValue];
        NSLog(@"Memory Capacity of %llu MiB with %llu MiB Free memory available.", ((totalSpace/1024ll)/1024ll), ((totalFreeSpace/1024ll)/1024ll));
    } else {
        NSLog(@"Error Obtaining System Memory Info: Domain = %@, Code = %ld", [error domain], (long)[error code]);
    }
    
    return totalFreeSpace;
}

#pragma mark - application did launch
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //[self getFreeDiskspace];
    [Fabric with:@[CrashlyticsKit]];
    [Mixpanel sharedInstanceWithToken:@"068917803a6be63ddc8af9afe87b6eb9"];
    [self initParseSetting:application withLaunchOption:launchOptions];
    [self initLaunchUIAppearance:application];
    [self initRootViewController:launchOptions];
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                    didFinishLaunchingWithOptions:launchOptions];
}

/**
 * Init the parse setting
 * @param application
 * @param launch option
 */
-(void)initParseSetting:(UIApplication *)application withLaunchOption:(NSDictionary *)launchOptions {
    [Parse enableLocalDatastore];
    [Parse setApplicationId:@"7CK99aj18YgBA2RO9uQPh7xepDBsjAvEjox4k8V6"
                  clientKey:@"YlREmgWjwRMP31iXaWDUgMN3jgtnDbAqppBcS9yA"];
    
    if (application.applicationState != UIApplicationStateBackground) {
        BOOL preBackgroundPush = ![application respondsToSelector:@selector(backgroundRefreshStatus)];
        BOOL oldPushHandlerOnly = ![self respondsToSelector:@selector(application:didReceiveRemoteNotification:fetchCompletionHandler:)];
        BOOL noPushPayload = ![launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        if (preBackgroundPush || oldPushHandlerOnly || noPushPayload) {
            [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
        }
    }
}


/**
 * Init the ui appearance on launch
 * @param application
 */
-(void)initLaunchUIAppearance:(UIApplication *)application {
    [application setStatusBarStyle:UIStatusBarStyleDefault];
    
    if([[UINavigationBar appearance] respondsToSelector:@selector(setTranslucent:)])
        [[UINavigationBar appearance] setTranslucent:YES];
    
    [[UINavigationBar appearance] setTintColor:[FontColor themeColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:
     @{ NSForegroundColorAttributeName:[FontColor appTitleColor],
        NSFontAttributeName:[UIFont fontWithName:@"AvenirNext-DemiBold" size:14]}];
    
    [[UIBarButtonItem appearanceWhenContainedIn:[UIImagePickerController class], nil] setTitleTextAttributes:@{NSForegroundColorAttributeName:[FontColor themeColor], NSFontAttributeName : [UIFont fontWithName:@"AvenirNext-Medium" size:14.0] } forState:UIControlStateNormal];
}

/**
 * Create and init the root view controller based on user's default setting
 * @param launchOptions
 */
-(void)initRootViewController:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    NSString *requestCode = [[NSUserDefaults standardUserDefaults] stringForKey:USER_DEFAULT_REQUEST_CODE_ID];
    BOOL userDidSignedUp = [[NSUserDefaults standardUserDefaults] boolForKey:USER_DEFAULT_SIGNED_UP];
    
    [[Branch getInstance] initSessionWithLaunchOptions:launchOptions andRegisterDeepLinkHandler:^(NSDictionary *params, NSError *error) {
        NSString *path = params[@"$deeplink_path"] ? params[@"$deeplink_path"] : nil;
        if (userDidSignedUp) {
            if ([path isEqualToString:@"booking"]) [DeeplinkHander checkTripDetail:params andWindow:self.window];
            else if ([path isEqualToString:@"your-place"]) [DeeplinkHander checkYourPlace:params andWindow:self.window];
            else if ([path isEqualToString:@"your-profile"]) [DeeplinkHander checkYourProfile:params andWindow:self.window];
            else {
                NSDictionary *userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
                if (userInfo) [NotificationHandler launchFromNotificationWithUserInfo:userInfo andWindow:self.window];
                else if (!self.window.rootViewController) {
                    HomePageViewController * homePageViewController = [[HomePageViewController alloc] init];
                    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:homePageViewController];
                    self.window.rootViewController = navigationController;
                    [self.window makeKeyAndVisible];
                }
            }
        } else {
            if ([path isEqualToString:@"signup"]) [DeeplinkHander signUpWithInvitation:params andWindow:self.window];
            else if ([path isEqualToString:@"password-reset"]) [DeeplinkHander resetPassword:params andWindow:self.window];
            else if (!self.window.rootViewController) {
                if (requestCode == nil) {
                    //Before user request invitation code, we will show the value prop.
                    ValuePropViewController *valuePropViewController = [[ValuePropViewController alloc] init];
                    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:valuePropViewController];
                    if (!self.window.rootViewController)
                    self.window.rootViewController = navigationController;
                    [self.window makeKeyAndVisible];
                } else {
                    InvitationStatusLoadingViewController *statusLoadingViewController = [[InvitationStatusLoadingViewController alloc] init];
                    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:statusLoadingViewController];
                    self.window.rootViewController = navigationController;
                    [self.window makeKeyAndVisible];
                }
            }
        }
    }];
}

#pragma mark - handle the open url for login
-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    [[Branch getInstance] handleDeepLink:url];
    
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation];
}

#pragma mark - other application state
- (void)applicationWillResignActive:(UIApplication *)application {
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[UserManager sharedUserManager] saveUserData];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [self.window endEditing:YES];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [FBSDKAppEvents activateApp];
    self.numNotif = application.applicationIconBadgeNumber;
    if (application.applicationIconBadgeNumber != 0) {
        application.applicationIconBadgeNumber = 0;
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
    }
    
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    currentInstallation[@"device"] = [Device getDeviceName];
    currentInstallation[@"iosVersion"] = [[UIDevice currentDevice] systemVersion];
    currentInstallation[@"buildVersion"] = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    currentInstallation.badge = 0;
    [currentInstallation saveInBackground];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}


#pragma mark - push notification delegate
-(void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    [application registerForRemoteNotifications];
}

/**
 * application registerred to push notification
 */
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:USER_DEFAULT_DID_ASK_PUSH_NOTIFICATION];
    
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    [currentInstallation saveInBackground];
    
    BOOL didSignup = [[NSUserDefaults standardUserDefaults] boolForKey:USER_DEFAULT_SIGNED_UP];
    if (didSignup) [self performSelector:@selector(askForAppUpdate) withObject:nil afterDelay:0.5];
    else {
        
        NSString *codeId = [[NSUserDefaults standardUserDefaults] stringForKey:USER_DEFAULT_REQUEST_CODE_ID];
        PFQuery *query = [PFQuery queryWithClassName:@"InvitationCode"];
        [query whereKey:@"objectId" equalTo:codeId];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (objects.count > 0) {
                PFObject *invitationCodeObj = objects[0];
                
                InvitationStatusWithPushNotificationViewController *invitationStatus = [[InvitationStatusWithPushNotificationViewController alloc] init];
                invitationStatus.invitationCodeObj = invitationCodeObj;
                UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:invitationStatus];
                self.window.rootViewController = navigationController;

            }
        }];
    }
}

/**
 * Application failed to register for remote notification
 */
-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:USER_DEFAULT_DID_ASK_PUSH_NOTIFICATION];
    
    BOOL didSignup = [[NSUserDefaults standardUserDefaults] boolForKey:USER_DEFAULT_SIGNED_UP];
    if (didSignup) [self performSelector:@selector(askForAppUpdate) withObject:nil afterDelay:0.5];
    else {
        NSString *codeId = [[NSUserDefaults standardUserDefaults] stringForKey:USER_DEFAULT_REQUEST_CODE_ID];
        PFQuery *query = [PFQuery queryWithClassName:@"InvitationCode"];
        [query whereKey:@"objectId" equalTo:codeId];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (objects.count > 0) {
                PFObject *invitationCodeObj = objects[0];
                
                InvitationStatusWithPushNotificationViewController *invitationStatus = [[InvitationStatusWithPushNotificationViewController alloc] init];
                invitationStatus.invitationCodeObj = invitationCodeObj;
                UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:invitationStatus];
                self.window.rootViewController = navigationController;
                
            }
        }];
    }
}

/**
 * Ask for the app update
 */
-(void)askForAppUpdate {
    [PythonParsingRequest getCurrentAppVersion:^(NSString *appVersion) {
        if (appVersion != nil) {
            NSString *currentInstalledVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
            if (![appVersion isEqualToString:currentInstalledVersion]) {
                HomePageRequestForUpdatePopupView *updateRequest = [[HomePageRequestForUpdatePopupView alloc] init];
                [updateRequest showInParent];
            }
        }
    }];
}


/**
 * Handle when the application receive notification
 */
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    if (application.applicationState == UIApplicationStateInactive) {
        [PFAnalytics trackAppOpenedWithRemoteNotificationPayload:userInfo];
    }
    
    [NotificationHandler notificationForApplication:application withInfo:userInfo andWindow:self.window withCompletionHandler:completionHandler];
}


#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.geteasyswap.Magpie" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Magpie" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Magpie.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end
