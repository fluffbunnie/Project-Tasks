//
//  HousingLayoutView.m
//  Magpie
//
//  Created by minh thao nguyen on 4/28/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import "HousingLayoutView.h"
#import "FontColor.h"
#import "PhotoButton.h"
#import "Mixpanel.h"

@interface HousingLayoutView()
@property (nonatomic, assign) CGFloat viewLength;

@property (nonatomic, strong) UIView *outerCircleView;
@property (nonatomic, strong) UIView *innerCircleView;

@property (nonatomic, strong) UIView *buttonsContainerView;
@property (nonatomic, strong) PhotoButton *homeButton;
@property (nonatomic, strong) PhotoButton *livingRoomButton;
@property (nonatomic, strong) PhotoButton *kitchenButton;
@property (nonatomic, strong) PhotoButton *bathroomButton;
@property (nonatomic, strong) PhotoButton *bedroomButton;
@end

@implementation HousingLayoutView
#pragma mark - initiation
/**
 * Lazily init the background outer circle view
 * @return UIView
 */
-(UIView *)outerCircleView {
    if (_outerCircleView == nil) {
        _outerCircleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.viewLength, self.viewLength)];
        _outerCircleView.layer.cornerRadius = self.viewLength/2;
        _outerCircleView.layer.borderColor = [[FontColor tableSeparatorColor] CGColor];
        _outerCircleView.layer.borderWidth = 2;
    }
    return _outerCircleView;
}

/**
 * Lazily init the background inner circle view
 * @return UIView
 */
-(UIView *)innerCircleView {
    if (_innerCircleView == nil) {
        _innerCircleView = [[UIView alloc] initWithFrame:CGRectMake(self.viewLength / 7, self.viewLength/7, 5 * self.viewLength/7, 5 * self.viewLength/7)];
        _innerCircleView.layer.cornerRadius = 5 * self.viewLength/14;
        _innerCircleView.layer.borderColor = [[FontColor tableSeparatorColor] CGColor];
        _innerCircleView.layer.borderWidth = 1;
    }
    return _innerCircleView;
}

/**
 * Lazily init the home button
 * @return PhotoButton
 */
-(PhotoButton *)homeButton {
    if (_homeButton ==  nil) {
        UIImage *normalImage = [UIImage imageNamed:HOUSING_LAYOUT_HOME_NORMAL_IMG_NAME];
        UIImage *highlightImage = [UIImage imageNamed:HOUSING_LAYOUT_HOME_HIGHLIGHT_IMG_NAME];
        _homeButton = [[PhotoButton alloc] initWithNormalImage:normalImage highlightImage:highlightImage andSelectedImage:normalImage andFrame:CGRectMake(self.viewLength/3, self.viewLength/3, self.viewLength/3, self.viewLength/3)];
        _homeButton.tag = HOUSING_LAYOUT_HOME_INDEX;
        
        [_homeButton addTarget:self action:@selector(housingLayoutButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _homeButton;
}

/**
 * Lazily init the bathroom button
 * @return PhotoButton
 */
-(PhotoButton *)livingRoomButton {
    if (_livingRoomButton == nil) {
        UIImage *normalImage = [UIImage imageNamed:HOUSING_LAYOUT_LIVINGROOM_NORMAL_IMG_NAME];
        UIImage *highlightImage = [UIImage imageNamed:HOUSING_LAYOUT_LIVINGROOM_HIGHLIGHT_IMG_NAME];
        _livingRoomButton = [[PhotoButton alloc] initWithNormalImage:normalImage highlightImage:highlightImage andSelectedImage:normalImage andFrame:CGRectMake(10, 10, self.viewLength/3.5, self.viewLength/3.5)];
        _livingRoomButton.tag = HOUSING_LAYOUT_LIVINGROOM_INDEX;
        
        [_livingRoomButton addTarget:self action:@selector(housingLayoutButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _livingRoomButton;
}

/**
 * Lazily init the kitchen button
 * @return PhotoButton
 */
-(PhotoButton *)kitchenButton {
    if (_kitchenButton == nil) {
        UIImage *normalImage = [UIImage imageNamed:HOUSING_LAYOUT_KITCHEN_NORMAL_IMG_NAME];
        UIImage *highlightImage = [UIImage imageNamed:HOUSING_LAYOUT_KITCHEN_HIGHLIGHT_IMG_NAME];
        _kitchenButton = [[PhotoButton alloc] initWithNormalImage:normalImage highlightImage:highlightImage andSelectedImage:normalImage andFrame:CGRectMake(2.5 * self.viewLength/3.5 - 10, 10, self.viewLength/3.5, self.viewLength/3.5)];
        _kitchenButton.tag = HOUSING_LAYOUT_KITCHEN_INDEX;
        
        [_kitchenButton addTarget:self action:@selector(housingLayoutButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _kitchenButton;
}

/**
 * lazily init the bathroom button
 * @return PhotoButton
 */
-(PhotoButton *)bathroomButton {
    if (_bathroomButton == nil) {
        UIImage *normalImage = [UIImage imageNamed:HOUSING_LAYOUT_BATHROOM_NORMAL_IMG_NAME];
        UIImage *highlightImage = [UIImage imageNamed:HOUSING_LAYOUT_BATHROOM_HIGHLIGHT_IMG_NAME];
        _bathroomButton = [[PhotoButton alloc] initWithNormalImage:normalImage highlightImage:highlightImage andSelectedImage:normalImage andFrame:CGRectMake(2.5 * self.viewLength/3.5 - 10, 2.5 * self.viewLength/3.5 - 10, self.viewLength/3.5, self.viewLength/3.5)];
        _bathroomButton.tag = HOUSING_LAYOUT_BATHROOM_INDEX;
        
        [_bathroomButton addTarget:self action:@selector(housingLayoutButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bathroomButton;
}

/**
 * Lazily init the bedroom button
 * @return PhotoButton
 */
-(PhotoButton *)bedroomButton {
    if (_bedroomButton == nil) {
        UIImage *normalImage = [UIImage imageNamed:HOUSING_LAYOUT_BEDROOM_NORMAL_IMG_NAME];
        UIImage *highlightImage = [UIImage imageNamed:HOUSING_LAYOUT_BEDROOM_HIGHLIGHT_IMG_NAME];
        _bedroomButton = [[PhotoButton alloc] initWithNormalImage:normalImage highlightImage:highlightImage andSelectedImage:normalImage andFrame:CGRectMake(10, 2.5 * self.viewLength/3.5 - 10, self.viewLength/3.5, self.viewLength/3.5)];
        _bedroomButton.tag = HOUSING_LAYOUT_BEDROOM_INDEX;
        
        [_bedroomButton addTarget:self action:@selector(housingLayoutButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bedroomButton;
}

#pragma mark - public methods
-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.viewLength = frame.size.width;
        [self addSubview:[self outerCircleView]];
        [self addSubview:[self innerCircleView]];
        [self addSubview:[self homeButton]];
        [self addSubview:[self livingRoomButton]];
        [self addSubview:[self bathroomButton]];
        [self addSubview:[self kitchenButton]];
        [self addSubview:[self bedroomButton]];
    }
    return self;
}

#pragma mark - click action
/**
 * Handle the behavior when user click on any of the home comfort button
 * @param PhotoButton
 */
-(void)housingLayoutButtonClick:(id)button {
    [[Mixpanel sharedInstance] track:@"Amenity Wheel Click"];
    PhotoButton *bt = (PhotoButton *)button;
    [self.housingLayoutDelegate housingLayoutButtonClickAtIndex:bt.tag];
}

@end
