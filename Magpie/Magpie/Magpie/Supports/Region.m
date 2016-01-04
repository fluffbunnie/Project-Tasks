//
//  CountryCode.m
//  Easyswap
//
//  Created by minh thao nguyen on 12/27/14.
//  Copyright (c) 2014 Easyswap Inc. All rights reserved.
//

#import "Region.h"

@implementation Region

/**
 * Get the display name of the region
 * @return region name
 */
-(NSString *)getRegionName {
    return [[NSString alloc] initWithFormat:@"+%@ (%@)", self.numberCode, self.name];
}

-(NSString *)getListingName {
    return [[NSString alloc] initWithFormat:@"%@ (+%@)", self.name, self.numberCode];
}

@end
