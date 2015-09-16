//
//  HomePageSecondSectionHeader.m
//  Magpie
//
//  Created by minh thao nguyen on 8/4/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import "HomePageSecondSectionHeader.h"
#import "FontColor.h"

static NSString * SECOND_SECTION_TITLE = @"Recommended For You";

@interface HomePageSecondSectionHeader()
@property (nonatomic, assign) CGFloat containerWidth;

@property (nonatomic, strong) UIView *separatorView;
@property (nonatomic, strong) UILabel *titleLabel;
@end

@implementation HomePageSecondSectionHeader
#pragma mark - initiation
/**
 * Lazily init the separator view
 * @return UIView
 */
-(UIView *)separatorView {
    if (_separatorView == nil) {
        _separatorView = [[UIView alloc] initWithFrame:CGRectMake(15, 0, self.containerWidth - 30, 4)];
        _separatorView.backgroundColor = [FontColor titleColor];
    }
    return _separatorView;
}

/**
 * Lazily init the title label
 * @return UILabel
 */
-(UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, self.containerWidth - 30, 25)];
        _titleLabel.font = [UIFont fontWithName:@"AvenirNext-DemiBold" size:18];
        _titleLabel.textColor = [FontColor descriptionColor];
        _titleLabel.text = SECOND_SECTION_TITLE;
    }
    return _titleLabel;
}

#pragma mark - public init
-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.containerWidth = frame.size.width;
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:[self separatorView]];
        [self addSubview:[self titleLabel]];
    }
    return self;
}


@end
