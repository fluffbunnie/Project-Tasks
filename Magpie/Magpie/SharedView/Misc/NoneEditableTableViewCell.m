//
//  NoneEditableTableViewCell.m
//  Magpie
//
//  Created by minh thao nguyen on 5/4/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import "NoneEditableTableViewCell.h"
#import "FontColor.h"

@implementation NoneEditableTableViewCell

-(id)init {
    self = [super init];
    if (self) {
        CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
        
        //add the title
        self.titleLabel= [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 70, 50)];
        self.titleLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:14];
        self.titleLabel.textColor = [FontColor descriptionColor];
        [self.contentView addSubview:self.titleLabel];
        
        //the description
        self.descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 0, screenWidth - 130, 50)];
        self.descriptionLabel.font = [UIFont fontWithName:@"AvenirNext-Medium" size:16];
        self.descriptionLabel.textColor = [FontColor titleColor];
        self.descriptionLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:self.descriptionLabel];
        
        //add separator
        self.separator = [[UIView alloc] initWithFrame:CGRectMake(5, 49, screenWidth - 10, 1)];
        self.separator.backgroundColor = [FontColor tableSeparatorColor];
        [self.contentView addSubview:self.separator];
    }
    return self;
}
@end
