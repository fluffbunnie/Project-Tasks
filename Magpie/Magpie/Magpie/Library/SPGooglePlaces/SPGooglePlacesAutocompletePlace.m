//
//  SPGooglePlacesAutocompletePlace.m
//  SPGooglePlacesAutocomplete
//
//  Created by Stephen Poletto on 7/17/12.
//  Copyright (c) 2012 Stephen Poletto. All rights reserved.
//

#import "SPGooglePlacesAutocompletePlace.h"
#import "SPGooglePlacesPlaceDetailQuery.h"
#import "AFHTTPRequestOperation.h"

@interface SPGooglePlacesAutocompletePlace()
@property (nonatomic, retain, readwrite) NSString *name;
@property (nonatomic, retain, readwrite) NSString *reference;
@property (nonatomic, retain, readwrite) NSString *identifier;
@property (nonatomic, readwrite) SPGooglePlacesAutocompletePlaceType type;
@end

@implementation SPGooglePlacesAutocompletePlace

@synthesize name, reference, identifier, type;

+ (SPGooglePlacesAutocompletePlace *)placeFromDictionary:(NSDictionary *)placeDictionary {
    SPGooglePlacesAutocompletePlace *place = [[self alloc] init];
    place.name = [placeDictionary objectForKey:@"description"];
    place.reference = [placeDictionary objectForKey:@"reference"];
    place.identifier = [placeDictionary objectForKey:@"id"];
    place.type = SPPlaceTypeFromDictionary(placeDictionary);
    return place;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"Name: %@, Reference: %@, Identifier: %@, Type: %@",
            name, reference, identifier, SPPlaceTypeStringForPlaceType(type)];
}

- (CLGeocoder *)geocoder {
    if (!geocoder) {
        geocoder = [[CLGeocoder alloc] init];
    }
    return geocoder;
}

- (void)resolveEstablishmentPlaceToPlacemark:(SPGooglePlacesPlacemarkResultBlock)block {
    SPGooglePlacesPlaceDetailQuery *query = [SPGooglePlacesPlaceDetailQuery query];
    query.reference = self.reference;
    [query fetchPlaceDetail:^(NSDictionary *placeDictionary, NSError *error) {
        if (error) {
            block(nil, nil, error);
        } else {
            NSString *addressString = [placeDictionary objectForKey:@"formatted_address"];
            [[self geocoder] geocodeAddressString:addressString completionHandler:^(NSArray *placemarks, NSError *error) {
                if (error) {
                    block(nil, nil, error);
                } else {
                    CLPlacemark *placemark = [placemarks onlyObject];
                    block(placemark, self.name, error);
                }
            }];
        }
    }];
}

- (void)resolveGecodePlaceToPlacemark:(SPGooglePlacesPlacemarkResultBlock)block {
    [[self geocoder] geocodeAddressString:self.name completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error) {
            block(nil, nil, error);
        } else {
            CLPlacemark *placemark = [placemarks onlyObject];
            block(placemark, self.name, error);
        }
    }];
}

- (void)resolveToPlacemark:(SPGooglePlacesPlacemarkResultBlock)block {
    if (type == SPPlaceTypeGeocode) {
        // Geocode places already have their address stored in the 'name' field.
        [self resolveGecodePlaceToPlacemark:block];
    } else {
        [self resolveEstablishmentPlaceToPlacemark:block];
    }
}

-(void)getLocation:(SPGooglePlacesLocationResultBlock)block {
    NSMutableString *url = [NSMutableString stringWithFormat:@"https://maps.googleapis.com/maps/api/geocode/json?address=%@&key=%@",
                            [self.name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], kGoogleAPIKey];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer new];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        block(responseObject, self.name, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        block(nil, self.name, nil);
    }];
    [operation start];
}

@end
