//
//  PhotoButton.m
//  Magpie
//
//  Created by minh thao nguyen on 4/29/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import "PhotoButton.h"

@interface PhotoButton()
@property (nonatomic, strong) UIImage *nornalImage;
@property (nonatomic, strong) UIImage *highlightImage;
@property (nonatomic, strong) UIImage *selectedImage;
@property (nonatomic, strong) UIImageView *buttonImageView;
@end

@implementation PhotoButton
#pragma mark - public methods
-(id)initWithNormalImage:(UIImage *)normalImage highlightImage:(UIImage *)highlightImage andSelectedImage:(UIImage *)selectedImage andFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.nornalImage = normalImage;
        self.highlightImage = highlightImage;
        self.selectedImage = selectedImage;
        self.buttonImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        self.buttonImageView.contentMode = UIViewContentModeScaleAspectFit;
        self.buttonImageView.image = self.nornalImage;
        
        [self addSubview:self.buttonImageView];
    }
    return self;
}

#pragma mark - override
-(void)setHighlighted:(BOOL)highlighted{
    [super setHighlighted:highlighted];
    if (highlighted) self.buttonImageView.image = self.highlightImage;
    else if (!self.selected) self.buttonImageView.image = self.nornalImage;
    else self.buttonImageView.image = self.selectedImage;
}

-(void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    if (selected) self.buttonImageView.image = self.selectedImage;
    else self.buttonImageView.image = self.nornalImage;
}

@end
