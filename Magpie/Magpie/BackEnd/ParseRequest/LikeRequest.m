//
//  LikeRequest.m
//  Magpie
//
//  Created by minh thao nguyen on 5/7/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import "LikeRequest.h"
#import "UserManager.h"
#import "Mixpanel.h"

@implementation LikeRequest
#pragma mark - parse server request
/**
 * Check if the user like a place of not
 * @param PFObject
 * @param PFObject
 * @param Completion handler
 */
+(void)getUserFavoriteWithUser:(PFObject *)userObj property:(PFObject *)propertyObj withCompletionHander:(void (^)(PFObject *likeObj))completionHandler {
    PFQuery *query = [PFQuery queryWithClassName:@"Favorite"];
    [query whereKey:@"user" equalTo:userObj];
    [query whereKey:@"targetHouse" equalTo:propertyObj];
    [query includeKey:@"user"];
    [query includeKey:@"targetUser"];
    [query includeKey:@"targetHouse"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error && objects.count > 0) completionHandler(objects[0]);
        else completionHandler(nil);
    }];
}

/**
 * Remove liked property from parse server
 * @param PFObject
 * @param Completion handler
 */
+(void)removeFavorite:(PFObject *)favoriteObj withCompletionHandler:(void (^)(BOOL succeeded))completionHandler {
    BOOL isAMatch = [favoriteObj[@"match"] boolValue];
    [favoriteObj deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            [[UserManager sharedUserManager] decrementFavorite];
            if (isAMatch) [[UserManager sharedUserManager] decrementMatch];
        }
        completionHandler(succeeded);
    }];
}

/**
 * Save the user favorite to parse server
 * @param PFObject
 * @param PFObject
 * @param Completion handler
 */
+(void)saveUserFavoriteWithUser:(PFObject *)userObj property:(PFObject *)propertyObj withCompletionHander:(void (^)(PFObject *likeObj))completionHandler {
    PFObject *favoriteObj = [PFObject objectWithClassName:@"Favorite"];
    favoriteObj[@"user"] = userObj;
    favoriteObj[@"targetUser"] = propertyObj[@"owner"];
    favoriteObj[@"targetHouse"] = propertyObj;
    favoriteObj[@"match"] = @NO;
    [favoriteObj saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            [[Mixpanel sharedInstance] track:@"Added To Favorite"];
            [[UserManager sharedUserManager] incrementFavorite];
            if ([favoriteObj[@"match"] boolValue]) [[UserManager sharedUserManager] incrementMatch];
            completionHandler(favoriteObj);
        } else completionHandler(nil);
    }];
}

#pragma mark - local datastore
/**
 * Check if the user (not yet logged in) already like a place or not
 * @param PFObject
 * @param Completion handler
 */
+(void)getLocalFavoriteWithProperty:(PFObject *)propertyObj withCompletionHandler:(void (^)(PFObject *likeObj))completionHandler {
    
    PFQuery *query = [PFQuery queryWithClassName:@"Favorite"];
    [query fromLocalDatastore];
    [query fromPinWithName:@"favorite"];
    [query whereKey:@"targetHouse" equalTo:propertyObj];
    [query includeKey:@"targetUser"];
    [query includeKey:@"targetHouse"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error && objects.count > 0) completionHandler(objects[0]);
        else completionHandler(nil);
    }];
}

/**
 * Remove liked property from the pin local datastore
 * @param PFObject
 * @param Completion Handler
 */
+(void)removeFavoriteFromLocalDataStore:(PFObject *)favoriteObj withCompletionHandler:(void (^)(BOOL succeeded))completionHandler {
    [favoriteObj unpinInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        completionHandler(succeeded);
    }];
}

/**
 * Pin a property to the list of liked property
 * @param PFObject
 * @return PFObject
 */
+(void)pinPropertyToFavorite:(PFObject *)propertyObj withCompletionHandler:(void (^)(PFObject *likeObj))completionHandler {
    PFObject *favoriteObj = [PFObject objectWithClassName:@"Favorite"];
    favoriteObj[@"targetUser"] = propertyObj[@"owner"];
    favoriteObj[@"targetHouse"] = propertyObj;
    favoriteObj[@"match"] = @NO;
    [favoriteObj pinInBackgroundWithName:@"favorite" block:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            [[Mixpanel sharedInstance] track:@"Added To Favorite"];
            completionHandler(favoriteObj);
        } else completionHandler(nil);
    }];
}

#pragma mark - server fetch requests
/**
 * Get the list (with the limited items) of all user favorites prior to a given date.
 * The list is sorted by descending order of date
 * @param PFObject
 * @param NSDate
 * @param NSInteger
 * @param Completion handler
 */
+(void)getUserFavoritesForUser:(PFObject *)userObj priorToDate:(NSDate *)sinceDate andLimit:(NSInteger)limit withCompletionHandler:(void (^)(NSArray *favorites))completionHandler {
    PFQuery *query = [PFQuery queryWithClassName:@"Favorite"];
    [query whereKey:@"user" equalTo:userObj];
    [query whereKey:@"targetUser" notEqualTo:userObj];
    [query whereKey:@"updatedAt" lessThan:sinceDate];
    [query includeKey:@"user"];
    [query includeKey:@"targetUser"];
    [query includeKey:@"targetHouse"];
    [query includeKey:@"targetHouse.owner"];
    [query includeKey:@"targetHouse.amenity"];
    [query orderByDescending:@"updatedAt"];
    query.limit = limit;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        completionHandler(objects);
    }];
}

/**
 * Get the list (with the limited items) of all user matches prior to a given date.
 * The list is sorted by descending order of date
 * @param PFObject
 * @param NSDate
 * @param NSInteger
 * @param Completion handler
 */
+(void)getUserMatchesForUser:(PFObject *)userObj priorToDate:(NSDate *)sinceDate andLimit:(NSInteger)limit withCompletionHandler:(void (^)(NSArray *favorites))completionHandler {
    PFQuery *query = [PFQuery queryWithClassName:@"Favorite"];
    [query whereKey:@"user" equalTo:userObj];
    [query whereKey:@"targetUser" notEqualTo:userObj];
    [query whereKey:@"updatedAt" lessThan:sinceDate];
    [query whereKey:@"match" equalTo:@YES];
    [query includeKey:@"user"];
    [query includeKey:@"targetUser"];
    [query includeKey:@"targetHouse"];
    [query includeKey:@"targetHouse.owner"];
    [query includeKey:@"targetHouse.amenity"];
    [query orderByDescending:@"updatedAt"];
    query.limit = limit;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        completionHandler(objects);
    }];
}

@end
