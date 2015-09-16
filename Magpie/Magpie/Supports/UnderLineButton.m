//
//  UnderLineButton.m
//  GuidedCommunication
//
//  Created by ducnm33 on 4/26/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import "UnderLineButton.h"
#import "FontColor.h"

@interface UnderLineButton()
@property (nonatomic, assign) CGContextRef contextRef;
@end
@implementation UnderLineButton

+ (UnderLineButton *)createButton {
    UnderLineButton* button = [[UnderLineButton alloc] init];
    button.titleLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:14];
    [button setTitleColor:[FontColor titleColor] forState:UIControlStateNormal];
    [button setTitleColor:[FontColor descriptionColor] forState:UIControlStateHighlighted];
    return button;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void) drawRect:(CGRect)rect {
    CGRect textRect = self.titleLabel.frame;
    CGFloat descender = self.titleLabel.font.descender;
    self.contextRef = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(self.contextRef, self.titleLabel.textColor.CGColor);
    CGContextMoveToPoint(self.contextRef, textRect.origin.x, textRect.origin.y + textRect.size.height + descender + 4);
    CGContextAddLineToPoint(self.contextRef, textRect.origin.x + textRect.size.width, textRect.origin.y + textRect.size.height + descender + 4);
    CGContextClosePath(self.contextRef);
    CGContextDrawPath(self.contextRef, kCGPathStroke);
}


@end
