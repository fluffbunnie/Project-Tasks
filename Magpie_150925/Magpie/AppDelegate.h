//
//  AppDelegate.h
//  Magpie
//
//  Created by minh thao nguyen on 4/21/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

static NSString * const USER_DEFAULT_DID_ASK_PUSH_NOTIFICATION = @"pushNotification";
static NSString * const USER_DEFAULT_REQUEST_CODE_ID = @"invitationCodeID";
static NSString * const USER_DEFAULT_SIGNED_UP = @"userSignedUp";

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (nonatomic, assign) NSInteger numNotif;
@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, strong) NSString *currentChattingRecipient;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


@end

