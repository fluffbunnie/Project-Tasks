//
//  RoundButton.m
//  Magpie
//
//  Created by minh thao nguyen on 4/30/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import "RoundButton.h"
#import "FontColor.h"

@implementation RoundButton

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = YES;
        self.layer.cornerRadius = frame.size.height/2;
        self.titleLabel.textColor = [UIColor whiteColor];
        self.titleLabel.font = [UIFont fontWithName:@"AvenirNext-Medium" size:15];
        [self setBackgroundImage:[FontColor imageWithColor:[FontColor themeColor]] forState:UIControlStateNormal];
        [self setBackgroundImage:[FontColor imageWithColor:[FontColor darkThemeColor]] forState:UIControlStateHighlighted];
        [self setBackgroundImage:[FontColor imageWithColor:[FontColor defaultBackgroundColor]] forState:UIControlStateDisabled];
    }
    return self;
}

@end
