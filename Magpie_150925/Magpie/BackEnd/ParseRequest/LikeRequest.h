//
//  LikeRequest.h
//  Magpie
//
//  Created by minh thao nguyen on 5/7/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "ParseConstant.h"

@interface LikeRequest : NSObject
//server requests
+(void)getUserFavoriteWithUser:(PFObject *)userObj property:(PFObject *)propertyObj withCompletionHander:(void (^)(PFObject *likeObj))completionHandler;
+(void)removeFavorite:(PFObject *)favoriteObj withCompletionHandler:(void (^)(BOOL succeeded))completionHandler;
+(void)saveUserFavoriteWithUser:(PFObject *)userObj property:(PFObject *)propertyObj withCompletionHander:(void (^)(PFObject *likeObj))completionHandler;

//local requests
+(void)getLocalFavoriteWithProperty:(PFObject *)propertyObj withCompletionHandler:(void (^)(PFObject *likeObj))completionHandler;
+(void)removeFavoriteFromLocalDataStore:(PFObject *)favoriteObj withCompletionHandler:(void (^)(BOOL succeeded))completionHandler;
+(void)pinPropertyToFavorite:(PFObject *)propertyObj withCompletionHandler:(void (^)(PFObject *likeObj))completionHandler;

//fetch requests
+(void)getUserFavoritesForUser:(PFObject *)userObj priorToDate:(NSDate *)sinceDate andLimit:(NSInteger)limit withCompletionHandler:(void (^)(NSArray *favorites))completionHandler;
+(void)getUserMatchesForUser:(PFObject *)userObj priorToDate:(NSDate *)sinceDate andLimit:(NSInteger)limit withCompletionHandler:(void (^)(NSArray *favorites))completionHandler;
@end
