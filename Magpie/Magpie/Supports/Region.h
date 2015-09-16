//
//  CountryCode.h
//  Easyswap
//
//  Created by minh thao nguyen on 12/27/14.
//  Copyright (c) 2014 Easyswap Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Region : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *nameCode;
@property (nonatomic, strong) NSNumber *numberCode;

-(NSString *)getRegionName;
-(NSString *)getListingName;

@end
