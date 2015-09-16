//
//  SuggestedQuestionHintView.m
//  Magpie
//
//  Created by minh thao nguyen on 5/17/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import "SuggestedQuestionHintView.h"

static CGFloat TOOL_TIP_WIDTH = 165;
static CGFloat TOOL_TIP_HEIGHT = 34;
static NSString *BACKGROUND_IMAGE = @"ToolTipGuidedQuestionBackground";
static NSString *TOOL_TIP_TEXT = @"Suggested questions";

@interface SuggestedQuestionHintView()
@property (nonatomic, strong) UIImageView *backgroundView;
@property (nonatomic, strong) UILabel *callToActionLabel;
@property (nonatomic, strong) UIButton *closeButton;

@end

@implementation SuggestedQuestionHintView
#pragma mark - initiation
/**
 * Lazily init the background view
 * @return UIImageView
 */
-(UIImageView *)backgroundView {
    if (_backgroundView == nil) {
        _backgroundView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _backgroundView.contentMode = UIViewContentModeScaleAspectFit;
        _backgroundView.image = [UIImage imageNamed:BACKGROUND_IMAGE];
    }
    return _backgroundView;
}

/**
 * Lazily init the call to action label
 * @return UILabel
 */
-(UILabel *)callToActionLabel {
    if (_callToActionLabel == nil) {
        _callToActionLabel = [[UILabel alloc] initWithFrame:CGRectMake(18, 0, TOOL_TIP_WIDTH - 48, 30)];
        _callToActionLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:12];
        _callToActionLabel.textColor = [UIColor whiteColor];
        _callToActionLabel.text = TOOL_TIP_TEXT;
    }
    return _callToActionLabel;
}

/**
 * Lazily init the the call to action close button
 * @return UIButton
 */
-(UIButton *)closeButton {
    if (_closeButton == nil) {
        _closeButton = [[UIButton alloc] initWithFrame:CGRectMake(TOOL_TIP_WIDTH - 30, 0, 30, 30)];
        _closeButton.titleLabel.font = [UIFont fontWithName:@"AvenirNext-UltraLight" size:14];
        [_closeButton setTitle:@"x" forState:UIControlStateNormal];
        [_closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [_closeButton addTarget:self action:@selector(hideView) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}

-(id)initWithXCoordinate:(float)x andYCoordinate:(float)y {
    self = [super initWithFrame:CGRectMake(x, y, TOOL_TIP_WIDTH, TOOL_TIP_HEIGHT)];
    if (self) {
        [self addSubview:[self backgroundView]];
        [self addSubview:[self callToActionLabel]];
        [self addSubview:[self closeButton]];
        self.hidden = YES;
    }
    return self;
}

-(void)hideView {
    self.hidden = YES;
}


@end
