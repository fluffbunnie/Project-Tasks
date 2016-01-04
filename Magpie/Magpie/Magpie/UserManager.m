//
//  UserManager.m
//  Magpie
//
//  Created by minh thao nguyen on 4/2/15.
//  Copyright (c) 2015 Easyswap Inc. All rights reserved.
//

#import "UserManager.h"
#import "Reachability.h"
#import "ParseConstant.h"

@interface UserManager()
@property (nonatomic, strong) PFObject *currentUser;
@property (nonatomic, strong) NSArray *currentUserProperties;
@property (nonatomic, strong) NSArray *upcomingTrips;
@end

@implementation UserManager

@synthesize currentUser;
@synthesize currentUserProperties;

/**
 * Get the shared instance of user manager
 * @return user manager
 */
+(UserManager *)sharedUserManager {
    static UserManager *sharedInstance = nil;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

/**
 * decrement the number of favorite listing by 1
 */
-(void)decrementFavorite {
    if (self.currentUser) currentUser[@"numLikes"] = @(MAX(0, [currentUser[@"numLikes"] integerValue] - 1));
}

/**
 * Increment the number of favorite listing by 1
 */
-(void)incrementFavorite {
    if (self.currentUser) currentUser[@"numLikes"] = @([currentUser[@"numLikes"] integerValue] + 1);
}

/**
 * decrement the number of matches listing by 1
 */
-(void)decrementMatch {
    if (self.currentUser) currentUser[@"numMatches"] = @(MAX(0, [currentUser[@"numMatches"] integerValue] - 1));
}

/**
 * Increment the number of matches listing by 1
 */
-(void)incrementMatch {
    if (self.currentUser) currentUser[@"numMatches"] = @([currentUser[@"numMatches"] integerValue] + 1);
}

/**
 * Increment number of properties
 */
-(void)incrementProperty {
    if (self.currentUser) currentUser[@"numProperties"] = @([currentUser[@"numProperties"] integerValue] + 1);
}

/**
 * Decrement the number of properties
 */
-(void)decrementProperty {
    if (self.currentUser) currentUser[@"numProperties"] = @(MAX(0, [currentUser[@"numProperties"] integerValue] - 1));
}

/**
 * Increment the number of conversations by 1
 */
-(void)incrementConversations {
    if (self.currentUser) currentUser[@"numConversations"] = @([currentUser[@"numConversations"] integerValue] + 1);
}

/**
 * Set the current user
 * @param PFObject
 */
-(void)setUserObj:(PFObject *)userObj {
    self.currentUser = userObj;
}

/**
 * Add a new property to the list
 * @param PFObject
 */
-(void)addUserProperty:(PFObject *)property {
    NSMutableArray *newArray = [NSMutableArray arrayWithArray:self.currentUserProperties];
    [newArray addObject:property];
    self.currentUserProperties = newArray;
}

/**
 * Set the current user and its properties
 * @param NSArray
 */
-(void)setUserProperties:(NSArray *)properties {
    self.currentUserProperties = properties;
    int numVisibleProperty = 0;
    for (PFObject *propertyObj in properties) {
        if (![propertyObj[@"state"] isEqualToString:PROPERTY_APPROVAL_STATE_PRIVATE]) numVisibleProperty ++;
    }
    self.currentUser[@"numProperties"] = [NSNumber numberWithInt:numVisibleProperty];
}

/**
 * Set the user's upcoming trips
 * @param NSArray
 */
-(void)setUserUpcomingTrips:(NSArray *)upcomingTrips {
    self.upcomingTrips = upcomingTrips;
}

/**
 * Save and sync the user obj
 */
-(void)saveUserData {
    if (self.currentUser) [self.currentUser saveInBackground];
    if (self.currentUserProperties.count > 0) [PFObject saveAllInBackground:self.currentUserProperties];
    if (self.upcomingTrips.count > 0) [PFObject saveAllInBackground:self.upcomingTrips];
}

/**
 * Get the current user object with completion handler
 * @param Completion Handler block
 */
-(void)getUserWithCompletionHandler:(void (^)(PFObject *userObject))completionHandler {
    if (self.currentUser != nil) completionHandler(self.currentUser);
    else {
        //we use local storage so we can fetch data even when offline
        PFQuery *userQuery = [PFQuery queryWithClassName:@"Users"];
        [userQuery fromLocalDatastore];
        [userQuery fromPinWithName:@"user"];
        [userQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error && objects.count > 0) {
                self.currentUser = [objects objectAtIndex:0];
                completionHandler(self.currentUser);
                
                [self.currentUser fetchInBackground];
            } else completionHandler(nil);
        }];
    }
}

/**
 * Get the current user property object with the completion handler
 * @param Completion Handler block
 */
-(void)getPropertiesWithCompletionHandler:(void (^)(NSArray *userProperties))completionHandler {
    if (self.currentUserProperties != nil) completionHandler(self.currentUserProperties);
    else {
        //we use local storage so we can fetch data even when offline
        PFQuery *propertyQuery = [PFQuery queryWithClassName:@"Property"];
        [propertyQuery includeKey:@"amenity"];
        [propertyQuery includeKey:@"owner"];
        [propertyQuery fromLocalDatastore];
        [propertyQuery fromPinWithName:@"places"];
        [propertyQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            self.currentUserProperties = objects;
            completionHandler(self.currentUserProperties);
            
            if (self.currentUser != nil) {
                PFQuery *updateQuery = [PFQuery queryWithClassName:@"Property"];
                [updateQuery includeKey:@"amenity"];
                [updateQuery whereKey:@"owner" equalTo:self.currentUser];
                [updateQuery findObjectsInBackgroundWithBlock:^(NSArray *properties, NSError *error) {
                    if (!error && properties.count > 0) {
                        [PFObject pinAllInBackground:properties withName:@"places"];
                        self.currentUserProperties = properties;
                        
                        int numVisibleProperty = 0;
                        for (PFObject *propertyObj in properties) {
                            if (![propertyObj[@"state"] isEqualToString:PROPERTY_APPROVAL_STATE_PRIVATE]) numVisibleProperty ++;
                        }
                        self.currentUser[@"numProperties"] = [NSNumber numberWithInt:numVisibleProperty];
                    }
                }];
            }
        }];
    }
}

/**
 * Get the current user's upcoming trip with the completion hander
 * @param Completion Handler block
 */
-(void)getUpcomingTripsWithCompletionHandler:(void (^)(NSArray *))completionHandler {
    if (self.upcomingTrips != nil) completionHandler(self.upcomingTrips);
    else {
        //we use local storage so we can fetch data even when offline
        PFQuery *propertyQuery = [PFQuery queryWithClassName:@"Trip"];
        [propertyQuery fromLocalDatastore];
        [propertyQuery fromPinWithName:@"trip"];
        [propertyQuery whereKey:@"endDate" greaterThan:[[NSDate alloc] init]];
        [propertyQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            self.upcomingTrips = objects;
            completionHandler(self.upcomingTrips);
            [PFObject fetchAllInBackground:objects];
        }];
    }
}

/**
 * Get the user name from its' object
 * @param PFObject
 * @return NSString
 */
+(NSString *)getUserNameFromUserObj:(PFObject *)userObj {
    NSString *name = userObj[@"firstname"] ? userObj[@"firstname"] : nil;
    if (name == nil) {
        name = userObj[@"username"] ? userObj[@"username"] : nil;
        if (name == nil) {
            name = userObj[@"email"];
            NSUInteger index = [name rangeOfString:@"@"].location;
            if (index != NSNotFound) name = [name substringToIndex:index];
        }
    }
    return name;
}

@end
