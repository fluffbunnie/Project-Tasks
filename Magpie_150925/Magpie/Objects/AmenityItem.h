//
//  AmenityItem.h
//  Magpie
//
//  Created by minh thao nguyen on 5/15/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AmenityItem : NSObject
@property (nonatomic, strong) NSString * amenityId;
@property (nonatomic, strong) NSString * amenityName;
@property (nonatomic, strong) NSString * amenityDescription;
@property (nonatomic, strong) NSString * amenitySelectedPlaceholder;
@property (nonatomic, strong) NSString * amenityDefaultActiveText;
@property (nonatomic, strong) UIImage * amenityImageActive;
@property (nonatomic, strong) UIImage * amenityImageInactive;
@property (nonatomic, assign) BOOL amenityEnabled;
@end
