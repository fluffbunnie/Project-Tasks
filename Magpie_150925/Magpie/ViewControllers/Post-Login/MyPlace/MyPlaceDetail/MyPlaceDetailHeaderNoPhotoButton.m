//
//  MyPlaceDetailHeaderNoPhotoButton.m
//  Magpie
//
//  Created by minh thao nguyen on 5/12/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import "MyPlaceDetailHeaderNoPhotoButton.h"
#import "UIVerticalButton.h"
#import "FontColor.h"

static NSString * NO_COVER_IMAGE = @"NoCoverImageWithButton";
static NSString * PROFILING_PHOTO_ICON = @"ProfilingPhotoIcon";
static NSString * BUTTON_TITLE = @"Add Photo";

@implementation MyPlaceDetailHeaderNoPhotoButton
-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
        backgroundImageView.image = [UIImage imageNamed:NO_COVER_IMAGE];
        
        [self insertSubview:backgroundImageView belowSubview:self.titleLabel];
    }
    return self;
}

@end
