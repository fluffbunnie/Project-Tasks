//
//  GuidedInteractionOverlayView.h
//  Magpie
//
//  Created by minh thao nguyen on 8/13/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString * const SWIPE_LEFT_RIGHT_ICON = @"SwipeLeftRightIcon";
static NSString * const SWIPE_UP_ICON = @"SwipeUpIcon";
static NSString * const SWIPE_DOWN_ICON = @"SwipeDownIcon";

static NSString * const PAGE_ONE_ICON = @"BasicInteractionPageOneIndicator";
static NSString * const PAGE_TWO_ICON = @"BasicInteractionPageTwoIndicator";
static NSString * const PAGE_THREE_ICON = @"BasicInteractionPageThreeIndicator";
static NSString * const PAGE_FOUR_ICON = @"BasicInteractionPageFourIndicator";
static NSString * const PAGE_FIVE_ICON = @"BasicInteractionPageFiveIndicator";

static NSString * const PAGE_ONE_TITLE = @"Welcome to Magpie, %@!\nHere are few tips:";
static NSString * const PAGE_ONE_TITLE_NO_NAME = @"Welcome to Magpie!\nHere are few tips:";
static NSString * const PAGE_TWO_TITLE = @"You got it!";
static NSString * const PAGE_THREE_TITLE = @"Now try this:";
static NSString * const PAGE_FOUR_TITLE = @"To go back:";
static NSString * const PAGE_FIVE_TITLE = @"One last tip:";

static NSString * const PAGE_ONE_MESSAGE = @"Swipe left or right to move between places.";
static NSString * const PAGE_TWO_MESSAGE = @"Swipe up to see more info about the place.";
static NSString * const PAGE_THREE_MESSAGE = @"Swipe left or right to move between detail pages of different places.";
static NSString * const PAGE_FOUR_MESSAGE = @"Swipe down to go back to the place's overview";
static NSString * const PAGE_FIVE_MESSAGE = @"Swipe down once more to go back to the home screen.";

@interface GuidedInteractionOverlayView : UIView
-(id)initWithIndex:(int)index;
-(void)setViewAlpha:(CGFloat)alphaValue;
@end
