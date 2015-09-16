//
//  CrossCloseButton.m
//  Magpie
//
//  Created by minh thao nguyen on 5/1/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import "CrossCloseButton.h"

static NSString * CROSS_ICON_NORMAL = @"NavigationBarCrossCloseIconNormal";
static NSString * CROSS_ICON_HIGHLIGHT = @"NavigationBarCrossClossIconHighlight";

@implementation CrossCloseButton

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setImage:[UIImage imageNamed:CROSS_ICON_NORMAL] forState:UIControlStateNormal];
        [self setImage:[UIImage imageNamed:CROSS_ICON_HIGHLIGHT] forState:UIControlStateHighlighted];
    }
    return self;
}

@end
