//
//  GuidedCommunicationGuestTypeView.m
//  GuidedCommunication
//
//  Created by minh thao nguyen on 4/4/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import "GuidedCommunicationGuestTypeView.h"
#import "GuidedCommunicationTripDetailViewController.h"
#import "RadioButton.h"
#import "FontColor.h"

static CGFloat COMMON_CONTAINER_HEIGHT = 350;

static NSString * VIEW_ICON_NAME = @"GuestTypeIcon";
static NSString * VIEW_TITLE = @"Do You Wanna Go?";
static NSString * VIEW_DESCRIPTION = @"Are you interested in staying at Huong’s\nplace for free?";

@interface GuidedCommunicationGuestTypeView()

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIImageView *viewIcon;
@property (nonatomic, strong) UILabel *viewTitle;
@property (nonatomic, strong) UILabel *viewDescription;
@property (nonatomic, strong) RadioButton *yesButton;
@property (nonatomic, strong) RadioButton *noButton;

@end

@implementation GuidedCommunicationGuestTypeView
#pragma mark - initiation
/**
 * Lazily init the container view
 * @return containerView
 */
-(UIView *)containerView {
    if (_containerView == nil) {
        float screenWidth = [[UIScreen mainScreen] bounds].size.width;
        float screenHeight = [[UIScreen mainScreen] bounds].size.height;
        CGFloat marginTop = (screenHeight - COMMON_CONTAINER_HEIGHT - 64 - 55) * 0.4;
        _containerView = [[UIView alloc] initWithFrame:CGRectMake(0, marginTop, screenWidth, COMMON_CONTAINER_HEIGHT)];
    }
    return _containerView;
}

/**
 * Lazily init the view icon
 * @return view icon
 */
-(UIImageView *)viewIcon {
    if (_viewIcon == nil) {
        float screenWidth = [[UIScreen mainScreen] bounds].size.width;
        _viewIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 80)];
        _viewIcon.contentMode = UIViewContentModeScaleAspectFit;
        _viewIcon.image = [UIImage imageNamed:VIEW_ICON_NAME];
    }
    return _viewIcon;
}

/**
 * Lazily init the view title
 * @return view title
 */
-(UILabel *)viewTitle {
    if (_viewTitle == nil) {
        float screenWidth = [[UIScreen mainScreen] bounds].size.width;
        _viewTitle = [[UILabel alloc] initWithFrame:CGRectMake(25, 105, screenWidth - 50, 28)];
        _viewTitle.font = [UIFont fontWithName:@"AvenirNext-Regular" size:20];
        _viewTitle.textAlignment = NSTextAlignmentCenter;
        _viewTitle.textColor = [FontColor titleColor];
        _viewTitle.text = VIEW_TITLE;
    }
    return _viewTitle;
}

/**
 * Lazily init the view description 
 * @return view description
 */
-(UILabel *)viewDescription {
    if (_viewDescription == nil) {
        float screenWidth = [[UIScreen mainScreen] bounds].size.width;
        _viewDescription = [[UILabel alloc] initWithFrame:CGRectMake(20, 143, screenWidth - 40, 50)];
        _viewDescription.font = [UIFont fontWithName:@"AvenirNext-Regular" size:14];
        _viewDescription.textAlignment = NSTextAlignmentCenter;
        _viewDescription.textColor = [FontColor descriptionColor];
        _viewDescription.text = VIEW_DESCRIPTION;
        _viewDescription.numberOfLines = 0;
    }
    return _viewDescription;
}


/**
 * Lazily init the yes button
 * @return yes button
 */
-(RadioButton *)yesButton {
    if (_yesButton == nil) {
        float screenWidth = [[UIScreen mainScreen] bounds].size.width;
        
        _yesButton = [[RadioButton alloc] initWithTitle:@"Yes" andFrame:CGRectMake(20, 230, screenWidth - 40, 50)];
        [_yesButton addTarget:self action:@selector(yesButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _yesButton;
}

/**
 * Lazily init the no button
 * @return no button
 */
-(RadioButton *)noButton {
    if (_noButton == nil) {
        float screenWidth = [[UIScreen mainScreen] bounds].size.width;
        
        _noButton = [[RadioButton alloc] initWithTitle:@"No" andFrame:CGRectMake(20, 290, screenWidth - 40, 50)];
        [_noButton addTarget:self action:@selector(noButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _noButton;
}

#pragma mark - public method
-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:[self containerView]];
        [self.containerView addSubview:[self viewIcon]];
        [self.containerView addSubview:[self viewTitle]];
        [self.containerView addSubview:[self viewDescription]];
        [self.containerView addSubview:[self yesButton]];
        [self.containerView addSubview:[self noButton]];
    }
    return self;
}

/**
 * Set the guest type
 * @param guestType
 */
-(void)setGuestType:(NSInteger)guestType {
    if (guestType == GUEST_TYPE_UNDEFINE) {
        [self.yesButton setEnabled:YES];
        [self.noButton setEnabled:YES];
    } else if (guestType == GUEST_TYPE_GUEST) {
        [self.yesButton setEnabled:NO];
        [self.noButton setEnabled:YES];
    } else if (guestType == GUEST_TYPE_ONLY_HOST) {
        [self.yesButton setEnabled:YES];
        [self.noButton setEnabled:NO];
    }
}

#pragma mark - button click
/**
 * Handle the action when the yes button is clicked
 */
-(void)yesButtonClicked {
    [self setGuestType:GUEST_TYPE_GUEST];
    [self.guestTypeDelegate onGuestTypeSelection:GUEST_TYPE_GUEST];
}

/**
 * Handle the action when the no button is clicked
 */
-(void)noButtonClicked {
    [self setGuestType:GUEST_TYPE_ONLY_HOST];
    [self.guestTypeDelegate onGuestTypeSelection:GUEST_TYPE_ONLY_HOST];
}

@end

