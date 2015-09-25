//
//  Property.m
//  Easyswap
//
//  Created by minh thao nguyen on 12/10/14.
//  Copyright (c) 2014 Easyswap Inc. All rights reserved.
//

#import "Property.h"
#import <Parse/Parse.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <SDWebImage/SDWebImageManager.h>
#import "Amenity.h"
#import "ParseConstant.h"
#import "AmenityItem.h"

@implementation Property
/**
 * Init with a dictionary. Rarely use it unless upload or sync
 * @param dictionary
 */
-(id)initWithPythonDictionary:(NSDictionary *)object {
    self = [super init];
    if (self) {
        //property
        self.propertyObj = [PFObject objectWithClassName:@"Property"];
        if (object[@"airbnbPid"]) self.propertyObj[@"airbnbPid"] = object[@"airbnbPid"];
        if (object[@"name"]) self.propertyObj[@"name"] = object[@"name"];
        if (object[@"coverPic"]) self.propertyObj[@"coverPic"] = object[@"coverPic"];
        if (object[@"location"]) self.propertyObj[@"location"] = object[@"location"];
        if (object[@"latitude"] && object[@"longitude"])
            self.propertyObj[@"coordinate"] = [PFGeoPoint geoPointWithLatitude:[object[@"latitude"] doubleValue] longitude:[object[@"longitude"] doubleValue]];
        if (object[@"fullDescription"]) self.propertyObj[@"fullDescription"] = object[@"fullDescription"];
        if (object[@"rule"]) self.propertyObj[@"rule"] = object[@"rule"];
        if (object[@"propertyType"]) self.propertyObj[@"propertyType"] = object[@"propertyType"];
        if (object[@"listingType"]) self.propertyObj[@"listingType"] = object[@"listingType"];
        
        if (object[@"numBedrooms"]) self.propertyObj[@"numBedrooms"] = [NSNumber numberWithFloat:[object[@"numBedrooms"] floatValue]];
        if (object[@"numBathrooms"]) self.propertyObj[@"numBathrooms"] = [NSNumber numberWithFloat:[object[@"numBathrooms"] floatValue]];
        if (object[@"numBeds"]) self.propertyObj[@"numBeds"] = [NSNumber numberWithFloat:[object[@"numBeds"] floatValue]];
        if (object[@"numGuests"]) self.propertyObj[@"numGuests"] = [NSNumber numberWithFloat:[object[@"numGuests"] floatValue]];
        if (object[@"rating"]) self.propertyObj[@"rating"] = [NSNumber numberWithFloat:[object[@"rating"] floatValue]];
        if (object[@"reviewCount"]) self.propertyObj[@"reviewCount"] = [NSNumber numberWithInt:[object[@"reviewCount"] intValue]];
        
        //photo
        self.photoObjs = [[NSMutableArray alloc] init];
        if (object[@"photos"]) {
            for (NSDictionary *photo in object[@"photos"]) {
                PFObject *photoObj = [PFObject objectWithClassName:@"PropertyPhoto"];
                if (photo[@"photoUrl"]) photoObj[@"photoUrl"] = photo[@"photoUrl"];
                if (photo[@"photoDescription"]) photoObj[@"photoDescription"] = photo[@"photoDescription"];
                [self.photoObjs addObject:photoObj];
            }
        }
        
        //amenity
        self.amenityObj = [Amenity newAmenityObj];
        if ([object[@"hasInternet"] boolValue]) {
            self.amenityObj[GENERAL_INTERNET_ID] = @YES;
            self.amenityObj[GENERAL_INTERNET_DESCRIPTION_ID] = @"Free Internet";
        }
        
        if ([object[@"hasWirelessInternet"] boolValue]) {
            self.amenityObj[GENERAL_INTERNET_ID] = @YES;
            self.amenityObj[GENERAL_INTERNET_DESCRIPTION_ID] = @"Free Wi-Fi";
        }
        
        if ([object[@"hasHeating"] boolValue]) {
            self.amenityObj[GENERAL_HEATING_ID] = @YES;
            self.amenityObj[GENERAL_HEATING_DESCRIPTION_ID] = @"Heating available";
        }
        
        if ([object[@"hasAirConditioning"] boolValue]) {
            self.amenityObj[GENERAL_AIR_CONDITIONING_ID] = @YES;
            self.amenityObj[GENERAL_AIR_CONDITIONING_DESCRIPTION_ID] = @"AC available";
        }
        
        if ([object[@"hasWasher"] boolValue]) {
            self.amenityObj[GENERAL_WASHER_ID] = @YES;
            self.amenityObj[GENERAL_WASHER_DESCRIPTION_ID] = @"Washer on-site";
        }
    
        if ([object[@"hasDryer"] boolValue]) {
            self.amenityObj[GENERAL_DRYER_ID] = @YES;
            self.amenityObj[GENERAL_DRYER_DESCRIPTION_ID] = @"Dryer on-site";
        }
        
        if ([object[@"isPetAllowed"] boolValue]) {
            self.amenityObj[GENERAL_PET_ALLOWED_ID] = @YES;
            self.amenityObj[GENERAL_PET_ALLOWED_DESCRIPTION_ID] = @"Fury friends welcome";
        }
        
        if ([object[@"isFamilyKidFriendly"] boolValue]) {
            self.amenityObj[GENERAL_FAMILY_FRIENDLY_ID] = @YES;
            self.amenityObj[GENERAL_FAMILY_FRIENDLY_DESCRIPTION_ID] = @"Kid-friendly & family-friendly";
        }
        
        if (![object[@"isSmokingAllowed"] boolValue]) {
            self.amenityObj[GENERAL_NO_SMOKING_ID] = @YES;
            self.amenityObj[GENERAL_NO_SMOKING_DESCRIPTION_ID] = @"No smoking please!";
        }
        
        if ([object[@"isWheelchairAccessible"] boolValue]) {
            self.amenityObj[GENERAL_WHEELCHAIR_ACCESSIBLE_ID] = @YES;
            self.amenityObj[GENERAL_WHEELCHAIR_ACCESSIBLE_DESCRIPTION_ID] = @"Wheelchair accessible";
        }
        
        if ([object[@"hasGym"] boolValue]) {
            self.amenityObj[GENERAL_GYM_ID] = @YES;
            self.amenityObj[GENERAL_GYM_DESCRIPTION_ID] = @"Accessible gym";
        }
        
        if ([object[@"hasPool"] boolValue]) {
            self.amenityObj[GENERAL_POOL_ID] = @YES;
            self.amenityObj[GENERAL_POOL_DESCRIPTION_ID] = @"Outdoor pool";
        }
        
        if ([object[@"hasHotTub"] boolValue]) {
            self.amenityObj[GENERAL_HOT_TUB_ID] = @YES;
            self.amenityObj[GENERAL_HOT_TUB_DESCRIPTION_ID] = @"Hot tub available";
        }
        
        if ([object[@"hasTV"] boolValue]) {
            self.amenityObj[LIVINGROOM_TV_ID] = @YES;
            self.amenityObj[LIVINGROOM_TV_DESCRIPTION_ID] = @"TV available";
        }
        
        if ([object[@"hasCableTV"] boolValue]) {
            self.amenityObj[LIVINGROOM_TV_ID] = @YES;
            self.amenityObj[LIVINGROOM_TV_DESCRIPTION_ID] = @"Cable TV available";
        }
        
        if ([object[@"hasIndoorFireplace"] boolValue]) {
            self.amenityObj[LIVINGROOM_FIREPLACE_ID] = @YES;
            self.amenityObj[LIVINGROOM_FIREPLACE_DESCRIPTION_ID] = @"Fireplace available for use";
        }
        
        if ([object[@"bathroomShampoo"] boolValue]) {
            self.amenityObj[BATHROOM_SHAMPOO_ID] = @YES;
            self.amenityObj[BATHROOM_SHAMPOO_DESCRIPTION_ID] = @"Toiletries available for use";
        }
        
        if ([object[@"hasFirstAidKit"] boolValue]) {
            self.amenityObj[BATHROOM_FIRST_AID_ID] = @YES;
            self.amenityObj[BATHROOM_FIRST_AID_DESCRIPTION_ID] = @"First-aid kit provided";
        }
        
        if ([object[@"hasSmokeDetector"] boolValue]) {
            self.amenityObj[KITCHEN_SMOKE_DETECTOR_ID] = @YES;
            self.amenityObj[KITCHEN_SMOKE_DETECTOR_DESCRIPTION_ID] = @"Smoke detector available";
        }
        
        self.propertyObj[@"amenity"] = self.amenityObj;
    }
    return self;
}

/**
 * Init a property object from the user object
 * @param PFObject
 */
-(id)initWithUserObj:(PFObject *)userObj {
    self = [super init];
    if (self) {
        self.propertyObj = [PFObject objectWithClassName:@"Property"];
        self.amenityObj = [Amenity newAmenityObj];
        self.propertyObj[@"owner"] = userObj;
        self.propertyObj[@"state"] = PROPERTY_APPROVAL_STATE_PRIVATE;
        self.propertyObj[@"amenity"] = self.amenityObj;
    }
    return self;
}

/**
 * Get the photos from a object with a completion handler
 * @param object
 * @param handler
 */
+(void)getPhotosFromPropertyObject:(PFObject *)object withCompletionHandler:(void (^)(NSArray *photos))handler {
    NSString *coverPhoto = object[@"coverPic"] ? object[@"coverPic"] : nil;
    PFRelation *relation = [object relationForKey:@"photos"];
    if (relation) {
        [[relation query] findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                NSMutableArray *photos = [NSMutableArray arrayWithArray:objects];
                
                [photos sortUsingComparator:^NSComparisonResult(PFObject *photo1, PFObject *photo2) {
                    NSString *photo1Url = photo1[@"photoUrl"];
                    NSString *photo2Url = photo2[@"photoUrl"];
                    NSString *photo1Description = photo1[@"photoDescription"];
                    NSString *photo2Description = photo2[@"photoDescription"];
                    
                    if ([photo1Url isEqualToString:coverPhoto]) return -1;
                    else if ([photo2Url isEqualToString:coverPhoto]) return 1;
                    else if (![photo1Description isEqual:[NSNull null]] && ![photo2Description isEqual:[NSNull null]]) {
                        NSUInteger indexCharacter1 = [photo1Description rangeOfString:@"/"].location;
                        NSUInteger indexCharacter2 = [photo2Description rangeOfString:@"/"].location;
                        if (indexCharacter1 != NSNotFound && indexCharacter2 == NSNotFound) return -1;
                        else if (indexCharacter1 == NSNotFound && indexCharacter2 != NSNotFound) return 1;
                        else if (indexCharacter1 == NSNotFound && indexCharacter2 == NSNotFound) {
                            if (photo1.createdAt > photo2.createdAt) return 1;
                            else if (photo1.createdAt < photo2.createdAt) return -1;
                            else return 0;
                        } else {
                            NSString *substring1 = [photo1Description substringToIndex:indexCharacter1];
                            NSString *substring2 = [photo2Description substringToIndex:indexCharacter2];
                            return [substring1 intValue] - [substring2 intValue];
                        }
                    } else {
                        if (photo1.createdAt > photo2.createdAt) return 1;
                        else if (photo1.createdAt < photo2.createdAt) return -1;
                        else return 0;
                    }
                }];
                handler(photos);
            }
        }];
    }
}

@end