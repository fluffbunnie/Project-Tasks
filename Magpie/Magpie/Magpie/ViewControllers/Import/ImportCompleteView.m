//
//  ImportCompleteView.m
//  Magpie
//
//  Created by minh thao nguyen on 5/9/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import "ImportCompleteView.h"
#import "RoundButton.h"
#import "FontColor.h"

static NSString *LOGO_ICON_NAME = @"MagpieAirbnbIcon";
static NSString *COMPLETE_BUTTON_TITLE = @"Take me back to My Place";

static NSString *IMPORT_MULT_COMPLETE_MESSAGE = @"Ta-da! %d listings imported!";
static NSString *IMPORT_SING_COMPLETE_MESSAGE = @"Ta-da! 1 listing imported!";

@interface ImportCompleteView()
@property (nonatomic, assign) CGFloat viewWidth;
@property (nonatomic, assign) CGFloat viewHeight;

@property (nonatomic, strong) UIImageView *logoIcon;
@property (nonatomic, strong) UILabel *importCompletedLabel;
@property (nonatomic, strong) RoundButton *completeButton;
@end

@implementation ImportCompleteView
#pragma mark - initiation
/**
 * Lazily init the logo icon
 * @return UIImageView
 */
-(UIImageView *)logoIcon {
    if (_logoIcon == nil) {
        _logoIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.viewHeight/2 - 100, self.viewWidth, 100)];
        _logoIcon.contentMode = UIViewContentModeScaleAspectFit;
        _logoIcon.image = [UIImage imageNamed:LOGO_ICON_NAME];
    }
    return _logoIcon;
}

/**
 * Lazily init the complete import label
 * @return UILabel
 */
-(UILabel *)importCompletedLabel {
    if (_importCompletedLabel == nil) {
        _importCompletedLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, self.viewHeight/2 + 20, self.viewWidth - 60, 30)];
        _importCompletedLabel.textAlignment = NSTextAlignmentCenter;
        _importCompletedLabel.textColor = [FontColor titleColor];
        _importCompletedLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:20];
        _importCompletedLabel.numberOfLines = 0;
    }
    return _importCompletedLabel;
}

/**
 * Lazily init the the complete button
 * @return RoundButton
 */
-(RoundButton *)completeButton {
    if (_completeButton == nil) {
        _completeButton = [[RoundButton alloc] initWithFrame:CGRectMake(45, self.viewHeight - 100, self.viewWidth - 90, 50)];
        [_completeButton setTitle:COMPLETE_BUTTON_TITLE forState:UIControlStateNormal];
        [_completeButton addTarget:self action:@selector(completeButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _completeButton;
}

#pragma mark - public methods
-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.viewWidth = frame.size.width;
        self.viewHeight = frame.size.height;
        
        [self addSubview:[self logoIcon]];
        [self addSubview:[self importCompletedLabel]];
        [self addSubview:[self completeButton]];
    }
    return self;
}

/**
 * set the number of properties need to be import
 * @param NSInteger
 */
-(void)setNumPlacesImported:(int)numPlaces {
    if (numPlaces <= 1) self.importCompletedLabel.text = [NSString stringWithFormat:IMPORT_SING_COMPLETE_MESSAGE, numPlaces];
    else self.importCompletedLabel.text = [NSString stringWithFormat:IMPORT_MULT_COMPLETE_MESSAGE, numPlaces];
}

#pragma mark - ui action
-(void)completeButtonClicked {
    [self.importCompleteViewDelegate completeButtonClicked];
}

@end
