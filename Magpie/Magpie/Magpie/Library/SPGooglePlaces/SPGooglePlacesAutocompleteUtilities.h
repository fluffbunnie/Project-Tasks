//
//  SPGooglePlacesAutocompleteUtilities.h
//  SPGooglePlacesAutocomplete
//
//  Created by Stephen Poletto on 7/18/12.
//  Copyright (c) 2012 Stephen Poletto. All rights reserved.
//

#define kGoogleAPIKey @"AIzaSyDUMOHACYJrct-URpYyfsASZ6dre2i1JHk"
#define kGoogleAPINSErrorCode 42

#import <Foundation/Foundation.h>

@class CLPlacemark;

typedef enum {
    SPPlaceTypeEverything = -1,
    SPPlaceTypeGeocode = 0,
    SPPlaceTypeEstablishment
} SPGooglePlacesAutocompletePlaceType;


typedef void (^SPGooglePlacesLocationResultBlock)(NSDictionary *location, NSString *addressString, NSError *error);
typedef void (^SPGooglePlacesPlacemarkResultBlock)(CLPlacemark *placemark, NSString *addressString, NSError *error);
typedef void (^SPGooglePlacesAutocompleteResultBlock)(NSArray *places, NSError *error);
typedef void (^SPGooglePlacesPlaceDetailResultBlock)(NSDictionary *placeDictionary, NSError *error);

extern SPGooglePlacesAutocompletePlaceType SPPlaceTypeFromDictionary(NSDictionary *placeDictionary);
extern NSString *SPBooleanStringForBool(BOOL boolean);
extern NSString *SPPlaceTypeStringForPlaceType(SPGooglePlacesAutocompletePlaceType type);
extern void SPPresentAlertViewWithErrorAndTitle(NSError *error, NSString *title);
extern BOOL SPIsEmptyString(NSString *string);

@interface NSArray(SPFoundationAdditions)
- (id)onlyObject;
@end