//
//  ParseConstant.m
//  Magpie
//
//  Created by minh thao nguyen on 5/10/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import "ParseConstant.h"
#import "RNDecryptor.h"
#import "RNEncryptor.h"

NSString * const PROPERTY_APPROVAL_STATE_PRIVATE = @"private";
NSString * const PROPERTY_APPROVAL_STATE_PENDING = @"pending";
NSString * const PROPERTY_APPROVAL_STATE_REJECT = @"reject";
NSString * const PROPERTY_APPROVAL_STATE_ACCEPT = @"public";

NSString * const PIN_PROPERTY_NAME = @"places";
NSString * const PIN_USER_NAME = @"user";
NSString * const PIN_UPCOMING_TRIP_NAME = @"trips";

NSString * const PROPERTY_LISTING_TYPE_ENTIRE_HOME_OR_APT = @"Entire home/apt";
NSString * const PROPERTY_LISTING_TYPE_PRIVATE_ROOM = @"Private room";
NSString * const PROPERTY_LISTING_TYPE_SHARED_ROOM = @"Shared room";

@implementation ParseConstant

+(NSData *)encryptPassword:(NSString *)password withEmail:(NSString *)email{
    NSString *key = [NSString stringWithFormat:@"%@allmagpie123awesome", email];
    NSData *data = [password dataUsingEncoding:NSUTF8StringEncoding];
    return [RNEncryptor encryptData:data withSettings:kRNCryptorAES256Settings password:key error:nil];
}

+(NSData *)decryptPassword:(NSData *)data withEmail:(NSString *)email{
    NSString *key = [NSString stringWithFormat:@"%@allmagpie123awesome", email];
    return [RNDecryptor decryptData:data withSettings:kRNCryptorAES256Settings password:key error:nil];
}

@end
