//
//  ImageUrl.m
//  Magpie
//
//  Created by minh thao nguyen on 4/12/15.
//  Copyright (c) 2015 Easyswap Inc. All rights reserved.
//

#import "ImageUrl.h"

@implementation ImageUrl

/**
 * Get the scaled property image url for a given image url
 * @param url
 * @return scaled url
 */
+(NSString *)inboxPropertyImageUrlFromUrl:(NSString *)url {
    CGFloat scale = [[UIScreen mainScreen] scale];
    
    CGFloat imageWidth = [[UIScreen mainScreen] bounds].size.width * scale;
    CGFloat imageHeight = 150 * scale;
    
    return [NSString stringWithFormat:@"http://res.cloudinary.com/magpie/image/fetch/w_%d,h_%d,c_lfill/%@", (int)imageWidth, (int)imageHeight, url];
}

/**
 * Get the scaled profile image url for a given image url
 * @param url
 * @return scaled url
 */
+(NSString *)inboxProfileImageUrlFromUrl:(NSString *)url {
    if ([url rangeOfString:@"graph.facebook.com"].location != NSNotFound)
        return url;
    else {
        CGFloat scale = [[UIScreen mainScreen] scale];
        
        CGFloat imageWidth = 50 * scale;
        CGFloat imageHeight = 50 * scale;
        
        return [NSString stringWithFormat:@"http://res.cloudinary.com/magpie/image/fetch/c_thumb,g_face,w_%d,h_%d,c_lfill/%@", (int)imageWidth, (int)imageHeight, url];
    }
}

/**
 * Get the property images url from the given url
 * @param url
 * @return scaled url
 */
+(NSString *)propertyImageUrlFromUrl:(NSString *)url {
//    CGFloat scale = [[UIScreen mainScreen] scale];
//    
//    CGFloat imageWidth = [[UIScreen mainScreen] bounds].size.width * scale;
//    CGFloat imageHeight = [[UIScreen mainScreen] bounds].size.height * scale;
//
    return [NSString stringWithFormat:@"http://res.cloudinary.com/magpie/image/fetch/%@", url];
}

+(NSString *)lowQualityPropertyImageUrlFromUrl:(NSString *)url {
    CGFloat imageWidth = [[UIScreen mainScreen] bounds].size.width / 2;
    return [NSString stringWithFormat:@"http://res.cloudinary.com/magpie/image/fetch/c_thumb,w_%d/%@", (int)imageWidth, url];
}

/**
 * Get the user profile url from given url
 * @param url
 * @return url
 */
+(NSString *)userProfileUrlFromUrl:(NSString *)url {
    if ([url rangeOfString:@"graph.facebook.com"].location != NSNotFound)
        return url;
    else {
        CGFloat scale = [[UIScreen mainScreen] scale];
        CGFloat imageWidth = 80 * scale;
        CGFloat imageHeight = 80 * scale;
        
        return [NSString stringWithFormat:@"http://res.cloudinary.com/magpie/image/fetch/w_%d,h_%d,c_lfill/%@", (int)imageWidth, (int)imageHeight, url];
    }
}

/**
 * Get the user favorite image url from given url
 * @param url
 * @return url
 */
+(NSString *)favoritePropertyImageUrlFromUrl:(NSString *)url {
    CGFloat scale = [[UIScreen mainScreen] scale];
    CGFloat imageWidth = ([[UIScreen mainScreen] bounds].size.width - 45)/2 * scale;
    CGFloat imageHeight = 220 * scale;

    return [NSString stringWithFormat:@"http://res.cloudinary.com/magpie/image/fetch/w_%d,h_%d,c_lfill/%@", (int)imageWidth, (int)imageHeight, url];
}

/**
 * Get the cover image url from a given url string
 * @param url
 * @return url
 */
+(NSString *)coverImageUrlFromUrl:(NSString *)url {
    CGFloat scale = [[UIScreen mainScreen] scale];
    CGFloat imageWidth = (500 + [[UIScreen mainScreen] bounds].size.width) * scale;
    CGFloat imageHeight = [[UIScreen mainScreen] bounds].size.height * scale;
    
    return [NSString stringWithFormat:@"http://res.cloudinary.com/magpie/image/fetch/w_%d,h_%d,c_lfill/%@", (int)imageWidth, (int)imageHeight, url];
}

/**
 * Get the listing image url from a given url
 * @param url
 * @return url
 */
+(NSString *)listingImageUrlFromUrl:(NSString *)url {
    CGFloat scale = [[UIScreen mainScreen] scale];
    CGFloat imageWidth = [[UIScreen mainScreen] bounds].size.width * scale;
    CGFloat imageHeight = 140 * scale;
    
    return [NSString stringWithFormat:@"http://res.cloudinary.com/magpie/image/fetch/w_%d,h_%d,c_lfill/%@", (int)imageWidth, (int)imageHeight, url];
}

/**
 * Get the listing image url from a given url
 * @param url
 * @return url
 */
+(NSString *)housePhotoImageUrlFromUrl:(NSString *)url {
    CGFloat scale = [[UIScreen mainScreen] scale];
    CGFloat imageWidth = [[UIScreen mainScreen] bounds].size.width * scale;
    CGFloat imageHeight = 215 * scale;
    
    return [NSString stringWithFormat:@"http://res.cloudinary.com/magpie/image/fetch/w_%d,h_%d,c_lfill/%@", (int)imageWidth, (int)imageHeight, url];
}

@end
