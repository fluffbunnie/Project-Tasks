//
//  ParseConstant.h
//  Magpie
//
//  Created by minh thao nguyen on 5/10/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString * const PARSE_SECRET_KEY = @"YlREmgWjwRMP31iXaWDUgMN3jgtnDbAqppBcS9yA";

extern NSString * const PROPERTY_APPROVAL_STATE_PRIVATE;
extern NSString * const PROPERTY_APPROVAL_STATE_PENDING;
extern NSString * const PROPERTY_APPROVAL_STATE_REJECT;
extern NSString * const PROPERTY_APPROVAL_STATE_ACCEPT;

extern NSString * const PIN_PROPERTY_NAME;
extern NSString * const PIN_USER_NAME;
extern NSString * const PIN_UPCOMING_TRIP_NAME;

extern NSString * const PROPERTY_LISTING_TYPE_ENTIRE_HOME_OR_APT;
extern NSString * const PROPERTY_LISTING_TYPE_PRIVATE_ROOM;
extern NSString * const PROPERTY_LISTING_TYPE_SHARED_ROOM;

@interface ParseConstant : NSObject
+(NSData *)encryptPassword:(NSString *)password withEmail:(NSString *)email;
+(NSData *)decryptPassword:(NSData *)data withEmail:(NSString *)email;
@end
