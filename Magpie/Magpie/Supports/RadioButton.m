//
//  RadioButton.m
//  GuidedCommunication
//
//  Created by minh thao nguyen on 4/5/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import "RadioButton.h"
#import "FontColor.h"

@implementation RadioButton

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setTitleColor:[FontColor titleColor] forState:UIControlStateNormal];
        [self setTitleColor:[FontColor themeColor] forState:UIControlStateHighlighted];
        [self setTitleColor:[FontColor themeColor] forState:UIControlStateDisabled];
        
        self.titleLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:14];
        
        [self setImage:[UIImage imageNamed:@"RadioIconNormal"] forState:UIControlStateNormal];
        [self setImage:[UIImage imageNamed:@"RadioIconHighlight"] forState:UIControlStateHighlighted];
        [self setImage:[UIImage imageNamed:@"RadioIconHighlight"] forState:UIControlStateDisabled];
        
        //format as radio button
        self.layer.borderWidth = 1;
        self.layer.borderColor = [[FontColor defaultBackgroundColor] CGColor];
        self.layer.cornerRadius = self.frame.size.height / 2.0;
        
        self.titleEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
        self.imageEdgeInsets = UIEdgeInsetsMake(0, frame.size.width - 40, 0, 0);
    }
    return self;
}

/**
 * Override the highlight method
 */
-(void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    if (highlighted) self.layer.borderColor = [[FontColor themeColor] CGColor];
    else if (self.enabled) self.layer.borderColor = [[FontColor defaultBackgroundColor] CGColor];
    else self.layer.borderColor = [[FontColor themeColor] CGColor];
}

/**
 * Override the enable method
 */
-(void)setEnabled:(BOOL)enabled {
    [super setEnabled:enabled];
    if (enabled) self.layer.borderColor = [[FontColor defaultBackgroundColor] CGColor];
    else self.layer.borderColor = [[FontColor themeColor] CGColor];
}

@end
