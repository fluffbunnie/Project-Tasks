//
//  SquircleProfileImage.m
//  Magpie
//
//  Created by minh thao nguyen on 4/30/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import "SquircleProfileImage.h"
#import "FontColor.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "ImageUrl.h"

static NSString * PROFILE_IMAGE_MASK_NAME = @"ProfileImageMask";
static NSString * NO_PROFILE_IMAGE_NAME = @"NoProfileImage";

@implementation SquircleProfileImage

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = YES;
        self.contentMode = UIViewContentModeScaleAspectFill;
        self.image = [FontColor imageWithColor:[UIColor whiteColor]];
        
        CALayer *maskLayer = [CALayer layer];
        maskLayer.contents = (id)[[UIImage imageNamed:PROFILE_IMAGE_MASK_NAME] CGImage];
        maskLayer.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        self.layer.mask = maskLayer;
        self.layer.masksToBounds = YES;
    }
    return self;
}

-(void)setProfileImageWithUrl:(NSString *)url {
    if (url.length == 0) self.image = [UIImage imageNamed:NO_PROFILE_IMAGE_NAME];
    else {
        self.image = [FontColor imageWithColor:[FontColor tableSeparatorColor]];
        NSString *serviceUrl = ([url rangeOfString:@"graph.facebook.com"].location == NSNotFound) ? [ImageUrl userProfileUrlFromUrl:url] : url;
        __weak typeof(self) weakSelf = self;
        [self setImageWithURL:[NSURL URLWithString:serviceUrl] placeholderImage:[FontColor imageWithColor:[UIColor whiteColor]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
            if (error || image == nil) weakSelf.image = [UIImage imageNamed:NO_PROFILE_IMAGE_NAME];
        }];
    }
}

@end
