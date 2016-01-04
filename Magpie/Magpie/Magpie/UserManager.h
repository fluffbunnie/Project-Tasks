//
//  UserManager.h
//  Magpie
//
//  Created by minh thao nguyen on 4/2/15.
//  Copyright (c) 2015 Easyswap Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface UserManager : NSObject

+(UserManager *)sharedUserManager;
-(void)getUserWithCompletionHandler:(void (^)(PFObject *userObj))completionHandler;
-(void)getPropertiesWithCompletionHandler:(void (^)(NSArray *properties))completionHandler;
-(void)getUpcomingTripsWithCompletionHandler:(void (^)(NSArray *trips)) completionHandler;

-(void)setUserObj:(PFObject *)userObj;
-(void)addUserProperty:(PFObject *)property;
-(void)setUserProperties:(NSArray *)properties;
-(void)setUserUpcomingTrips:(NSArray *)upcomingTrips;
-(void)saveUserData;
-(void)decrementFavorite;
-(void)incrementFavorite;
-(void)decrementMatch;
-(void)incrementMatch;
-(void)incrementProperty;
-(void)decrementProperty;
-(void)incrementConversations;


+(NSString *)getUserNameFromUserObj:(PFObject *)userObj;
@end
