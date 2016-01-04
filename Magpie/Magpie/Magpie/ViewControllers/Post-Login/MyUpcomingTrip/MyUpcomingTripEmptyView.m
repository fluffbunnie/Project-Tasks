//
//  MyUpcomingTripEmptyView.m
//  Magpie
//
//  Created by minh thao nguyen on 5/6/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import "MyUpcomingTripEmptyView.h"
#import "RoundButton.h"
#import "FontColor.h"
#import "Device.h"

static NSString *IMAGE_ICON_NAME = @"MyUpcomingTripEmptyIcon";
static NSString *TITLE_TEXT = @"You have no upcoming trips";
static NSString *DESCRIPTION_TEXT = @"Find your dream destination and dust off that luggage!";
static NSString *ACTION_BUTTON_TITLE = @"Go to Messages";

@interface MyUpcomingTripEmptyView()
@property (nonatomic, assign) CGFloat viewWidth;
@property (nonatomic, assign) CGFloat viewHeight;

@property (nonatomic, strong) UIImageView *iconImage;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *descriptionLabel;
@property (nonatomic, strong) RoundButton *actionButton;
@end

@implementation MyUpcomingTripEmptyView
#pragma mark - initiation
/**
 * Lazily init the icon image
 * @return UIImageView
 */
-(UIImageView *)iconImage {
    if (_iconImage == nil) {
        _iconImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, (self.viewHeight - 90 - 265)/2, self.viewWidth, 120)];
        _iconImage.contentMode = UIViewContentModeScaleAspectFit;
        _iconImage.image = [UIImage imageNamed:IMAGE_ICON_NAME];
    }
    return _iconImage;
}

/**
 * Lazily init the title label
 * @return UILabel
 */
-(UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:18];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [FontColor descriptionColor];
        _titleLabel.text = TITLE_TEXT;
        _titleLabel.numberOfLines = 0;
        
        CGSize size = [_titleLabel sizeThatFits:CGSizeMake(self.viewWidth - 80, FLT_MAX)];
        _titleLabel.frame = CGRectMake(40, CGRectGetMaxY(self.iconImage.frame) + 30, self.viewWidth - 80, size.height);
    }
    return _titleLabel;
}

/**
 * Lazily init the description label
 * @return UILabel
 */
-(UILabel *)descriptionLabel {
    if (_descriptionLabel == nil) {
        _descriptionLabel = [[UILabel alloc] init];
        _descriptionLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:14];
        _descriptionLabel.textAlignment = NSTextAlignmentCenter;
        _descriptionLabel.textColor = [FontColor descriptionColor];
        _descriptionLabel.text = DESCRIPTION_TEXT;
        _descriptionLabel.numberOfLines = 0;
        
        CGSize size = [_descriptionLabel sizeThatFits:CGSizeMake(self.viewWidth - 50, FLT_MAX)];
        _descriptionLabel.frame = CGRectMake(25, CGRectGetMaxY(self.titleLabel.frame) + 10, self.viewWidth - 50, size.height);
        if ([Device isIphone6]) _descriptionLabel.frame = CGRectMake(0, CGRectGetMaxY(self.titleLabel.frame) + 10, self.viewWidth, 20);
        
    }
    return _descriptionLabel;
}

/**
 * Lazily init the back to browsing button
 * @return UIButton
 */
-(RoundButton *)actionButton {
    if (_actionButton == nil) {
        _actionButton = [[RoundButton alloc] initWithFrame:CGRectMake(40, self.viewHeight - 90, self.viewWidth - 80, 50)];
        [_actionButton setTitle:ACTION_BUTTON_TITLE forState:UIControlStateNormal];
        [_actionButton addTarget:self action:@selector(actionButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _actionButton;
}

#pragma mark - public method
-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.viewWidth = frame.size.width;
        self.viewHeight = frame.size.height;
        [self addSubview:[self iconImage]];
        [self addSubview:[self titleLabel]];
        [self addSubview:[self descriptionLabel]];
        [self addSubview:[self actionButton]];
    }
    return self;
}

/**
 * Handle the action when user click on the action button
 */
-(void)actionButtonClick {
    [self.emptyViewDelegate goToMessages];
}


@end
