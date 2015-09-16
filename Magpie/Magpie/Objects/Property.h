//
//  Property.h
//  Easyswap
//
//  Created by minh thao nguyen on 12/9/14.
//  Copyright (c) 2014 Easyswap Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <Parse/Parse.h>

@interface Property : NSObject
@property (nonatomic, strong) PFObject *propertyObj;
@property (nonatomic, strong) NSMutableArray *photoObjs;
@property (nonatomic, strong) PFObject *amenityObj;

-(id)initWithPythonDictionary:(NSDictionary *)object;
-(id)initWithUserObj:(PFObject *)userObj;
+(void)getPhotosFromPropertyObject:(PFObject *)object withCompletionHandler:(void (^)(NSArray *photos))handler;

@end
