//
//  ImageUrl.h
//  Magpie
//
//  Created by minh thao nguyen on 4/12/15.
//  Copyright (c) 2015 Easyswap Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ImageUrl : NSObject

+(NSString *)inboxPropertyImageUrlFromUrl:(NSString *)url;
+(NSString *)inboxProfileImageUrlFromUrl:(NSString *)url;

+(NSString *)propertyImageUrlFromUrl:(NSString *)url;
+(NSString *)lowQualityPropertyImageUrlFromUrl:(NSString *)url;
+(NSString *)userProfileUrlFromUrl:(NSString *)url;

+(NSString *)favoritePropertyImageUrlFromUrl:(NSString *)url;
+(NSString *)coverImageUrlFromUrl:(NSString *)url;

+(NSString *)listingImageUrlFromUrl:(NSString *)url;
+(NSString *)housePhotoImageUrlFromUrl:(NSString *)url;
@end
