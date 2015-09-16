//
//  MyPlaceInfoViewController.m
//  Magpie
//
//  Created by minh thao nguyen on 5/12/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//


#import "MyPlaceInfoViewController.h"
#import "ParseConstant.h"
#import "FloatPlaceholderTextField.h"
#import "UnderlinePlaceHolderDarkTextField.h"
#import "RadioButton.h"
#import "FontColor.h"
#import "UIVerticalButton.h"
#import "MyPlaceDetailViewController.h"
#import "UserManager.h"
#import "FloatPlaceholderTextView.h"

static CGFloat TEXT_VIEW_MIN_HEIGHT = 53;

static NSString *LISTING_TYPE_ENTIRE_HOUSE_IMAGE_HIGHLIGHT = @"HouseProfileEntirePlaceHighlight";
static NSString *LISTING_TYPE_ENTIRE_HOUSE_IMAGE_NORMAL = @"HouseProfileEntirePlaceNormal";
static NSString *LISTING_TYPE_PRIVATE_ROOM_IMAGE_HIGHLIGHT = @"HouseProfilePrivateRoomHighlight";
static NSString *LISTING_TYPE_PRIVATE_ROOM_IMAGE_NORMAL = @"HouseProfilePrivateRoomNormal";
static NSString *LISTING_TYPE_SHARED_ROOM_IMAGE_HIGHLIGHT = @"HouseProfileSharedRoomHighlight";
static NSString *LISTING_TYPE_SHARED_ROOM_IMAGE_NORMAL = @"HouseProfileSharedRoomNormal";

static NSString *HOUSING_PROFILE_NUM_BEDROOMS_ICON = @"HousingProfileNumBedrooms";
static NSString *HOUSING_PROFILE_NUM_BATHROOMS_ICON =  @"HousingProfileNumBathrooms";
static NSString *HOUSING_PROFILE_NUM_BEDS_ICON = @"HousingProfileNumBeds";
static NSString *HOUSING_PROFILE_NUM_GUESTS_ICON = @"HousingProfileNumGuests";

static NSString *NAVIGATION_BAR_BACK_ICON_NAME = @"NavigationBarBackIconRed";
static NSString *VIEW_TITLE = @"Home Info";

static NSString *HOUSE_NAME_PLACEHOLDER = @"Give your place a short name";
static NSString *HOUSE_NAME_GUIDE = @"ex: Quiet, safe, bright apt in Russian Hill";
static NSString *HOUSE_DESCRIPTION_PLACEHOLDER = @"Describe your place";

static NSString *LISTING_TYPE_TITLE = @"Where can the guest stay at your place?";
static NSString *LISTING_TYPE_ENTIRE_HOUSE = @"Entire Place";
static NSString *LISTING_TYPE_PRIVATE_ROOM = @"Private Room";
static NSString *LISTING_TYPE_SHARED_ROOM = @"Shared Room";

static NSString *ROOM_TITLE = @"How big is the place?";

@interface MyPlaceInfoViewController ()
@property (nonatomic, assign) CGFloat screenWidth;
@property (nonatomic, assign) CGFloat screenHeight;
@property (nonatomic, strong) UIBarButtonItem *backButton;
@property (nonatomic, strong) UIBarButtonItem *saveButton;

@property (nonatomic, strong) UIScrollView *containerView;

@property (nonatomic, strong) UILabel *houseNameTitleLabel;
@property (nonatomic, strong) UnderlinePlaceHolderDarkTextField *houseNameTextField;
@property (nonatomic, strong) UILabel *houseNameGuide;
@property (nonatomic, strong) FloatPlaceholderTextView *houseDescription;

@property (nonatomic, strong) UIView *staticViewContainer;
@property (nonatomic, strong) UILabel *listingTypeLabel;
@property (nonatomic, strong) UIButton *listingTypeEntireHouseButton;
@property (nonatomic, strong) UIButton *listingTypePrivateRoomButton;
@property (nonatomic, strong) UIButton *listingTypeSharedRoomButton;

@property (nonatomic, strong) UILabel *housingInfoTitleLabel;
@property (nonatomic, strong) UIImageView *numBedroomsIcon;
@property (nonatomic, strong) UISlider *numBedroomsSlider;
@property (nonatomic, strong) UILabel *numBedroomsLabel;

@property (nonatomic, strong) UIImageView *numBathroomsIcon;
@property (nonatomic, strong) UISlider *numBathroomsSlider;
@property (nonatomic, strong) UILabel *numBathroomsLabel;

@property (nonatomic, strong) UIImageView *numBedsIcon;
@property (nonatomic, strong) UISlider *numBedsSlider;
@property (nonatomic, strong) UILabel *numBedsLabel;

@property (nonatomic, strong) UIImageView *numGuestsIcon;
@property (nonatomic, strong) UISlider *numGuestsSlider;
@property (nonatomic, strong) UILabel *numGuestsLabel;

@property (nonatomic, assign) BOOL shouldChange;
@end

@implementation MyPlaceInfoViewController
#pragma mark - initiation
/**
 * Lazily init the back button item
 * @return UIBarButtonItem
 */
-(UIBarButtonItem *)backButton {
    if (_backButton == nil) {
        _backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:NAVIGATION_BAR_BACK_ICON_NAME]
                                                       style:UIBarButtonItemStyleBordered
                                                      target:self
                                                      action:@selector(goBack)];
    }
    return _backButton;
}

/**
 * Lazily init the save button item
 * @return UIBarButtonItem
 */
-(UIBarButtonItem *)saveButton {
    if (_saveButton == nil) {
        UIButton * saveBt = [[UIButton alloc] init];
        saveBt.titleLabel.font = [UIFont fontWithName:@"AvenirNext-Medium" size:14];
        [saveBt setTitle:@"Save" forState:UIControlStateNormal];
        [saveBt setTitleColor:[FontColor themeColor] forState:UIControlStateNormal];
        [saveBt setTitleColor:[FontColor defaultBackgroundColor] forState:UIControlStateDisabled];
        [saveBt setTitleColor:[FontColor navigationButtonHighlightColor] forState:UIControlStateHighlighted];
        [saveBt sizeToFit];
        [saveBt addTarget:self action:@selector(saveButtonClick) forControlEvents:UIControlEventTouchUpInside];
        
        _saveButton = [[UIBarButtonItem alloc] initWithCustomView:saveBt];
    }
    return _saveButton;
}

/**
 * Lazily init the container scroll view
 * @return UIScrollView
 */
-(UIScrollView *)containerView {
    if (_containerView == nil) {
        _containerView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.screenWidth, self.screenHeight)];
        _containerView.contentSize = CGSizeMake(self.screenWidth, 665);
        _containerView.showsHorizontalScrollIndicator = NO;
        _containerView.delegate = self;
        
        UITapGestureRecognizer *tapToDismissKeyboard = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
        [_containerView addGestureRecognizer:tapToDismissKeyboard];
    }
    return _containerView;
}

/**
 * Lazily init the house's name text field
 * @retrurn UnderlinePlaceHolderDarkTextField
 */
-(UnderlinePlaceHolderDarkTextField *)houseNameTextField {
    if (_houseNameTextField == nil) {
        _houseNameTextField = [[UnderlinePlaceHolderDarkTextField alloc] initWithPlaceHolder:HOUSE_NAME_PLACEHOLDER andFrame:CGRectMake(30, 20, self.screenWidth - 60, 50)];
        _houseNameTextField.tag = 0;
        _houseNameTextField.delegate = self;
        
        NSString *houseName = self.propertyObj[@"name"] ? self.propertyObj[@"name"] : @"";
        if (houseName.length > 0) _houseNameTextField.text = houseName;
        [_houseNameTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _houseNameTextField;
}

/**
 * Lazily init the house's name guide
 * @return UILabel
 */
-(UILabel *)houseNameGuide {
    if (_houseNameGuide == nil) {
        _houseNameGuide = [[UILabel alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(self.houseNameTextField.frame), self.screenWidth - 40, 20)];
        _houseNameGuide.font = [UIFont fontWithName:@"AvenirNext-Regular" size:13];
        _houseNameGuide.textColor = [FontColor defaultBackgroundColor];
        _houseNameGuide.text = HOUSE_NAME_GUIDE;
    }
    return _houseNameGuide;
}

/**
 * Lazily init the house description
 * @return FloatPlaceHolderTextView
 */
-(FloatPlaceholderTextView *)houseDescription {
    if (_houseDescription == nil) {
        _houseDescription = [[FloatPlaceholderTextView alloc] initWithPlaceHolder:HOUSE_DESCRIPTION_PLACEHOLDER andFrame:CGRectMake(20, CGRectGetMaxY(self.houseNameGuide.frame) + 30, self.screenWidth - 40, TEXT_VIEW_MIN_HEIGHT)];
        _houseDescription.delegate = self;
        
        if (self.propertyObj[@"fullDescription"]) {
            _houseDescription.text = self.propertyObj[@"fullDescription"];
            CGSize newSize = [_houseDescription sizeThatFits:CGSizeMake(self.screenWidth - 50, MAXFLOAT)];
            
            if (newSize.height > TEXT_VIEW_MIN_HEIGHT)
                _houseDescription.frame = CGRectMake(20, CGRectGetMaxY(self.houseNameGuide.frame) + 30, self.screenWidth - 40, newSize.height);
        }
    }
    return _houseDescription;
}

/**
 * Lazily init the static view controller
 * @return UIView
 */
-(UIView *)staticViewContainer {
    if (_staticViewContainer == nil) {
        _staticViewContainer = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.houseDescription.frame) + 40, self.screenWidth, 455)];
    }
    return _staticViewContainer;
}

/**
 * Lazily init the listing type label
 * @return UILabel
 */
-(UILabel *)listingTypeLabel {
    if (_listingTypeLabel == nil) {
        _listingTypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.screenWidth, 20)];
        _listingTypeLabel.font = [UIFont fontWithName:@"AvenirNext-Medium" size:14];
        _listingTypeLabel.textAlignment = NSTextAlignmentCenter;
        _listingTypeLabel.textColor = [FontColor propertyImageBackgroundColor];
        _listingTypeLabel.text = LISTING_TYPE_TITLE;
    }
    return _listingTypeLabel;
}

/**
 * Lazily init the listing type - entire house
 * @return UIButton
 */
-(UIButton *)listingTypeEntireHouseButton {
    if (_listingTypeEntireHouseButton == nil) {
        _listingTypeEntireHouseButton = [[UIButton alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.listingTypeLabel.frame) + 25, 90, 100)];
        
        _listingTypeEntireHouseButton.titleLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:13];
        [_listingTypeEntireHouseButton setTitle:LISTING_TYPE_ENTIRE_HOUSE forState:UIControlStateNormal];
        [_listingTypeEntireHouseButton setTitleColor:[FontColor defaultBackgroundColor] forState:UIControlStateNormal];
        [_listingTypeEntireHouseButton setTitleColor:[FontColor themeColor] forState:UIControlStateHighlighted];
        [_listingTypeEntireHouseButton setTitleColor:[FontColor themeColor] forState:UIControlStateDisabled];
        
        [_listingTypeEntireHouseButton setImage:[UIImage imageNamed:LISTING_TYPE_ENTIRE_HOUSE_IMAGE_NORMAL] forState:UIControlStateNormal];
        [_listingTypeEntireHouseButton setImage:[UIImage imageNamed:LISTING_TYPE_ENTIRE_HOUSE_IMAGE_HIGHLIGHT] forState:UIControlStateHighlighted];
        [_listingTypeEntireHouseButton setImage:[UIImage imageNamed:LISTING_TYPE_ENTIRE_HOUSE_IMAGE_HIGHLIGHT] forState:UIControlStateDisabled];
        
        [_listingTypeEntireHouseButton centerVerticallyWithPadding:10];
        
        NSString *listingType = self.propertyObj[@"listingType"];
        if (listingType) [_listingTypeEntireHouseButton setEnabled:![listingType isEqualToString:PROPERTY_LISTING_TYPE_ENTIRE_HOME_OR_APT]];
        _listingTypeEntireHouseButton.tag = 0;
        
        [_listingTypeEntireHouseButton addTarget:self action:@selector(listingTypeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _listingTypeEntireHouseButton;
}

/**
 * Lazily init the listing type - private room
 * @return UIButton
 */
-(UIButton *)listingTypePrivateRoomButton {
    if (_listingTypePrivateRoomButton == nil) {
        _listingTypePrivateRoomButton = [[UIButton alloc] initWithFrame:CGRectMake((self.screenWidth - 90)/2, CGRectGetMaxY(self.listingTypeLabel.frame) + 25, 90, 100)];
        
        _listingTypePrivateRoomButton.titleLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:13];
        [_listingTypePrivateRoomButton setTitle:LISTING_TYPE_PRIVATE_ROOM forState:UIControlStateNormal];
        [_listingTypePrivateRoomButton setTitleColor:[FontColor defaultBackgroundColor] forState:UIControlStateNormal];
        [_listingTypePrivateRoomButton setTitleColor:[FontColor themeColor] forState:UIControlStateHighlighted];
        [_listingTypePrivateRoomButton setTitleColor:[FontColor themeColor] forState:UIControlStateDisabled];
        
        [_listingTypePrivateRoomButton setImage:[UIImage imageNamed:LISTING_TYPE_PRIVATE_ROOM_IMAGE_NORMAL] forState:UIControlStateNormal];
        [_listingTypePrivateRoomButton setImage:[UIImage imageNamed:LISTING_TYPE_PRIVATE_ROOM_IMAGE_HIGHLIGHT] forState:UIControlStateHighlighted];
        [_listingTypePrivateRoomButton setImage:[UIImage imageNamed:LISTING_TYPE_PRIVATE_ROOM_IMAGE_HIGHLIGHT] forState:UIControlStateDisabled];
        
        [_listingTypePrivateRoomButton centerVerticallyWithPadding:10];

        
        NSString *listingType = self.propertyObj[@"listingType"];
        if (listingType) [_listingTypePrivateRoomButton setEnabled:![listingType isEqualToString:PROPERTY_LISTING_TYPE_PRIVATE_ROOM]];
        _listingTypePrivateRoomButton.tag = 1;
        
        [_listingTypePrivateRoomButton addTarget:self action:@selector(listingTypeButtonClick:) forControlEvents:UIControlEventTouchUpInside];

    }
    return _listingTypePrivateRoomButton;
}

/**
 * Lazily init the listing type - shared room
 * @return UIButton
 */
-(UIButton *)listingTypeSharedRoomButton {
    if (_listingTypeSharedRoomButton == nil) {
        _listingTypeSharedRoomButton = [[UIButton alloc] initWithFrame:CGRectMake(self.screenWidth - 110, CGRectGetMaxY(self.listingTypeLabel.frame) + 25, 90, 100)];
        
        _listingTypeSharedRoomButton.titleLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:13];
        [_listingTypeSharedRoomButton setTitle:LISTING_TYPE_SHARED_ROOM forState:UIControlStateNormal];
        [_listingTypeSharedRoomButton setTitleColor:[FontColor defaultBackgroundColor] forState:UIControlStateNormal];
        [_listingTypeSharedRoomButton setTitleColor:[FontColor themeColor] forState:UIControlStateHighlighted];
        [_listingTypeSharedRoomButton setTitleColor:[FontColor themeColor] forState:UIControlStateDisabled];
        
        [_listingTypeSharedRoomButton setImage:[UIImage imageNamed:LISTING_TYPE_SHARED_ROOM_IMAGE_NORMAL] forState:UIControlStateNormal];
        [_listingTypeSharedRoomButton setImage:[UIImage imageNamed:LISTING_TYPE_SHARED_ROOM_IMAGE_HIGHLIGHT] forState:UIControlStateHighlighted];
        [_listingTypeSharedRoomButton setImage:[UIImage imageNamed:LISTING_TYPE_SHARED_ROOM_IMAGE_HIGHLIGHT] forState:UIControlStateDisabled];
        
        [_listingTypeSharedRoomButton centerVerticallyWithPadding:10];
        
        NSString *listingType = self.propertyObj[@"listingType"];
        if (listingType) [_listingTypeSharedRoomButton setEnabled:![listingType isEqualToString:PROPERTY_LISTING_TYPE_SHARED_ROOM]];
        _listingTypeSharedRoomButton.tag = 2;
        
        [_listingTypeSharedRoomButton addTarget:self action:@selector(listingTypeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _listingTypeSharedRoomButton;
}

/**
 * Lazily init the listing type label
 * @return UILabel
 */
-(UILabel *)housingInfoTitleLabel {
    if (_housingInfoTitleLabel == nil) {
        _housingInfoTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.listingTypeSharedRoomButton.frame) + 40, self.screenWidth, 20)];
        _housingInfoTitleLabel.font = [UIFont fontWithName:@"AvenirNext-Medium" size:14];
        _housingInfoTitleLabel.textAlignment = NSTextAlignmentCenter;
        _housingInfoTitleLabel.textColor = [FontColor propertyImageBackgroundColor];
        _housingInfoTitleLabel.text = ROOM_TITLE;
    }
    return _housingInfoTitleLabel;
}

/**
 * Lazily init the number of bedroom icon
 * @return UIImageView
 */
-(UIImageView *)numBedroomsIcon {
    if (_numBedroomsIcon == nil) {
        _numBedroomsIcon = [[UIImageView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.housingInfoTitleLabel.frame) + 30, 30, 25)];
        _numBedroomsIcon.contentMode = UIViewContentModeScaleAspectFit;
        _numBedroomsIcon.image = [UIImage imageNamed:HOUSING_PROFILE_NUM_BEDROOMS_ICON];
    }
    return _numBedroomsIcon;
}

/**
 * Lazily init the num bedrooms slider
 * @return UISlider
 */
-(UISlider *)numBedroomsSlider {
    if (_numBedroomsSlider == nil) {
        _numBedroomsSlider = [[UISlider alloc] initWithFrame:CGRectMake(70, CGRectGetMinY(self.numBedroomsIcon.frame), self.screenWidth - 160, 25)];
        _numBedroomsSlider.minimumValue = 0;
        _numBedroomsSlider.maximumValue = 7;
        _numBedroomsSlider.continuous = YES;
        _numBedroomsSlider.minimumTrackTintColor = [FontColor themeColor];
        _numBedroomsSlider.maximumTrackTintColor = [FontColor tableSeparatorColor];
        _numBedroomsSlider.tag = 0;
        
        float numBedrooms = self.propertyObj[@"numBedrooms"] ? [self.propertyObj[@"numBedrooms"] floatValue] : 0;
        [_numBedroomsSlider setValue:MIN(numBedrooms, 7) animated:NO];
        
        [_numBedroomsSlider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _numBedroomsSlider;
}

/**
 * Lazily init the num bedrooms label
 * @return UILabel
 */
-(UILabel *)numBedroomsLabel {
    if (_numBedroomsLabel == nil) {
        _numBedroomsLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.screenWidth - 85, CGRectGetMinY(self.numBedroomsIcon.frame), 65, 25)];
        _numBedroomsLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:14];
        _numBedroomsLabel.textColor = [FontColor propertyImageBackgroundColor];
        _numBedroomsLabel.textAlignment = NSTextAlignmentRight;
        
        int numBedrooms = self.propertyObj[@"numBedrooms"] ? [self.propertyObj[@"numBedrooms"] intValue] : 0;
        if (numBedrooms > 6) _numBedroomsLabel.text = @"6+ bdrs";
        else if (numBedrooms > 1) _numBedroomsLabel.text = [NSString stringWithFormat:@"%d bdrs", numBedrooms];
        else _numBedroomsLabel.text = [NSString stringWithFormat:@"%d bdr", numBedrooms];
    }
    return _numBedroomsLabel;
}

/**
 * Lazily init the number of bathroom icon
 * @return UIImageView
 */
-(UIImageView *)numBathroomsIcon {
    if (_numBathroomsIcon == nil) {
        _numBathroomsIcon = [[UIImageView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.numBedroomsIcon.frame) + 30, 30, 25)];
        _numBathroomsIcon.contentMode = UIViewContentModeScaleAspectFit;
        _numBathroomsIcon.image = [UIImage imageNamed:HOUSING_PROFILE_NUM_BATHROOMS_ICON];
    }
    return _numBathroomsIcon;
}

/**
 * Lazily init the num bedrooms slider
 * @return UISlider
 */
-(UISlider *)numBathroomsSlider {
    if (_numBathroomsSlider == nil) {
        _numBathroomsSlider = [[UISlider alloc] initWithFrame:CGRectMake(70, CGRectGetMinY(self.numBathroomsIcon.frame), self.screenWidth - 160, 25)];
        _numBathroomsSlider.minimumValue = 0;
        _numBathroomsSlider.maximumValue = 4.5;
        _numBathroomsSlider.continuous = YES;
        _numBathroomsSlider.minimumTrackTintColor = [FontColor themeColor];
        _numBathroomsSlider.maximumTrackTintColor = [FontColor tableSeparatorColor];
        _numBathroomsSlider.tag = 1;
        
        float numBathrooms = self.propertyObj[@"numBathrooms"] ? [self.propertyObj[@"numBathrooms"] floatValue] : 0;
        [_numBathroomsSlider setValue:MIN(numBathrooms, 4.5) animated:NO];

        
        [_numBathroomsSlider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _numBathroomsSlider;
}

/**
 * Lazily init the num bedrooms label
 * @return UILabel
 */
-(UILabel *)numBathroomsLabel {
    if (_numBathroomsLabel == nil) {
        _numBathroomsLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.screenWidth - 85, CGRectGetMinY(self.numBathroomsIcon.frame), 65, 25)];
        _numBathroomsLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:14];
        _numBathroomsLabel.textColor = [FontColor propertyImageBackgroundColor];
        _numBathroomsLabel.textAlignment = NSTextAlignmentRight;
        
        float numBathrooms = self.propertyObj[@"numBathrooms"] ? [self.propertyObj[@"numBathrooms"] floatValue] : 0;
        if (numBathrooms > 4) _numBedroomsLabel.text = @"4+ baths";
        else if (numBathrooms > 1) {
            if (numBathrooms == (int)numBathrooms) _numBathroomsLabel.text = [NSString stringWithFormat:@"%d baths", (int)numBathrooms];
            else _numBathroomsLabel.text = [NSString stringWithFormat:@"%.1f baths", numBathrooms];
        } else {
            if (numBathrooms == (int)numBathrooms) _numBathroomsLabel.text = [NSString stringWithFormat:@"%d bath", (int)numBathrooms];
            else _numBathroomsLabel.text = [NSString stringWithFormat:@"%.1f bath", numBathrooms];
        }
    }
    return _numBathroomsLabel;
}

/**
 * Lazily init the number of beds icon
 * @return UIImageView
 */
-(UIImageView *)numBedsIcon {
    if (_numBedsIcon == nil) {
        _numBedsIcon = [[UIImageView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.numBathroomsIcon.frame) + 30, 30, 25)];
        _numBedsIcon.contentMode = UIViewContentModeScaleAspectFit;
        _numBedsIcon.image = [UIImage imageNamed:HOUSING_PROFILE_NUM_BEDS_ICON];
    }
    return _numBedsIcon;
}

/**
 * Lazily init the num beds slider
 * @return UISlider
 */
-(UISlider *)numBedsSlider {
    if (_numBedsSlider == nil) {
        _numBedsSlider = [[UISlider alloc] initWithFrame:CGRectMake(70, CGRectGetMinY(self.numBedsIcon.frame), self.screenWidth - 160, 25)];
        _numBedsSlider.minimumValue = 0;
        _numBedsSlider.maximumValue = 10;
        _numBedsSlider.continuous = YES;
        _numBedsSlider.minimumTrackTintColor = [FontColor themeColor];
        _numBedsSlider.maximumTrackTintColor = [FontColor tableSeparatorColor];
        _numBedsSlider.tag = 2;
        
        int numBeds = self.propertyObj[@"numBeds"] ? [self.propertyObj[@"numBeds"] intValue] : 0;
        [_numBedsSlider setValue:MIN(numBeds, 10) animated:NO];
        
        [_numBedsSlider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _numBedsSlider;
}

/**
 * Lazily init the num beds label
 * @return UILabel
 */
-(UILabel *)numBedsLabel {
    if (_numBedsLabel == nil) {
        _numBedsLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.screenWidth - 85, CGRectGetMinY(self.numBedsIcon.frame), 65, 25)];
        _numBedsLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:14];
        _numBedsLabel.textColor = [FontColor propertyImageBackgroundColor];
        _numBedsLabel.textAlignment = NSTextAlignmentRight;
        
        int numBeds = self.propertyObj[@"numBeds"] ? [self.propertyObj[@"numBeds"] intValue] : 0;
        if (numBeds > 9) _numBedsLabel.text = @"9+ beds";
        else if (numBeds > 1) _numBedsLabel.text = [NSString stringWithFormat:@"%d beds", numBeds];
        else _numBedsLabel.text = [NSString stringWithFormat:@"%d bed", numBeds];
    }
    return _numBedsLabel;
}

/**
 * Lazily init the number of guests icon
 * @return UIImageView
 */
-(UIImageView *)numGuestsIcon {
    if (_numGuestsIcon == nil) {
        _numGuestsIcon = [[UIImageView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.numBedsIcon.frame) + 30, 30, 25)];
        _numGuestsIcon.contentMode = UIViewContentModeScaleAspectFit;
        _numGuestsIcon.image = [UIImage imageNamed:HOUSING_PROFILE_NUM_GUESTS_ICON];
    }
    return _numGuestsIcon;
}

/**
 * Lazily init the num guests slider
 * @return UISlider
 */
-(UISlider *)numGuestsSlider {
    if (_numGuestsSlider == nil) {
        _numGuestsSlider = [[UISlider alloc] initWithFrame:CGRectMake(70, CGRectGetMinY(self.numGuestsIcon.frame), self.screenWidth - 160, 25)];
        _numGuestsSlider.minimumValue = 1;
        _numGuestsSlider.maximumValue = 10;
        _numGuestsSlider.continuous = YES;
        _numGuestsSlider.minimumTrackTintColor = [FontColor themeColor];
        _numGuestsSlider.maximumTrackTintColor = [FontColor tableSeparatorColor];
        _numGuestsSlider.tag = 3;
        
        int numGuests = self.propertyObj[@"numGuests"] ? [self.propertyObj[@"numGuests"] intValue] : 1;
        [_numGuestsSlider setValue:MIN(numGuests, 10) animated:NO];
        
        [_numGuestsSlider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _numGuestsSlider;
}

/**
 * Lazily init the num guests label
 * @return UILabel
 */
-(UILabel *)numGuestsLabel {
    if (_numGuestsLabel == nil) {
        _numGuestsLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.screenWidth - 85, CGRectGetMinY(self.numGuestsIcon.frame), 65, 25)];
        _numGuestsLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:14];
        _numGuestsLabel.textColor = [FontColor propertyImageBackgroundColor];
        _numGuestsLabel.textAlignment = NSTextAlignmentRight;
        
        int numGuests = self.propertyObj[@"numGuests"] ? [self.propertyObj[@"numGuests"] intValue] : 1;
        if (numGuests > 9) _numGuestsLabel.text = @"9+ guests";
        else if (numGuests > 1) _numGuestsLabel.text = [NSString stringWithFormat:@"%d guests", numGuests];
        else _numGuestsLabel.text = [NSString stringWithFormat:@"%d guest", numGuests];
    }
    return _numGuestsLabel;
}

#pragma mark - public methods
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = VIEW_TITLE;
    self.shouldChange = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    self.screenWidth = [[UIScreen mainScreen] bounds].size.width;
    self.screenHeight = [[UIScreen mainScreen] bounds].size.height;
    self.navigationItem.leftBarButtonItem = [self backButton];
    self.navigationItem.rightBarButtonItem = [self saveButton];
    self.saveButton.enabled = NO;
    
    [self.view addSubview:[self containerView]];
    [self.containerView addSubview:[self houseNameTitleLabel]];
    [self.containerView addSubview:[self houseNameTextField]];
    [self.containerView addSubview:[self houseNameGuide]];
    [self.containerView addSubview:[self houseDescription]];
    
    [self.containerView addSubview:[self staticViewContainer]];
    
    [self.staticViewContainer addSubview:[self listingTypeLabel]];
    [self.staticViewContainer addSubview:[self listingTypeEntireHouseButton]];
    [self.staticViewContainer addSubview:[self listingTypePrivateRoomButton]];
    [self.staticViewContainer addSubview:[self listingTypeSharedRoomButton]];
    
    [self.staticViewContainer addSubview:[self housingInfoTitleLabel]];
    [self.staticViewContainer addSubview:[self numBedroomsIcon]];
    [self.staticViewContainer addSubview:[self numBedroomsSlider]];
    [self.staticViewContainer addSubview:[self numBedroomsLabel]];
    
    [self.staticViewContainer addSubview:[self numBathroomsIcon]];
    [self.staticViewContainer addSubview:[self numBathroomsSlider]];
    [self.staticViewContainer addSubview:[self numBathroomsLabel]];
    
    [self.staticViewContainer addSubview:[self numBedsIcon]];
    [self.staticViewContainer addSubview:[self numBedsSlider]];
    [self.staticViewContainer addSubview:[self numBedsLabel]];
    
    [self.staticViewContainer addSubview:[self numGuestsIcon]];
    [self.staticViewContainer addSubview:[self numGuestsSlider]];
    [self.staticViewContainer addSubview:[self numGuestsLabel]];
    
    self.containerView.contentSize = CGSizeMake(self.screenWidth, CGRectGetMaxY(self.staticViewContainer.frame));
    
    UITapGestureRecognizer *tapOutside = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignResponder)];
    [self.containerView addGestureRecognizer:tapOutside];
}


-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarHidden = NO;
    [self.navigationController setNavigationBarHidden:NO animated:false];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    // Listen for keyboard appearances and disappearances
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillChange:)
                                                 name:UIKeyboardWillChangeFrameNotification
                                               object:nil];

}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
}

#pragma mark -keyboard
/**
 * On keyboard changing, show the right view
 * @param notif
 */
-(void)keyboardWillChange:(NSNotification *)notif {
    CGRect keyboardBounds;
    [[notif.userInfo valueForKey:UIKeyboardFrameBeginUserInfoKey] getValue:&keyboardBounds];
    
    [UIView animateWithDuration:0.3f animations:^{
        self.containerView.frame = CGRectMake(0, 0, self.screenWidth, 64 + self.screenHeight - keyboardBounds.size.width);
    }];
}

/**
 * On keyboard showing, move the view up
 * @param notif
 */
- (void)keyboardWillShow:(NSNotification *) notif{
    CGRect keyboardBounds;
    [[notif.userInfo valueForKey:UIKeyboardFrameBeginUserInfoKey] getValue:&keyboardBounds];
    
    [UIView animateWithDuration:0.3f animations:^{
        self.containerView.frame = CGRectMake(0, 0, self.screenWidth, 64 + self.screenHeight - keyboardBounds.size.width);
    }];
}

/**
 * On keyboard hiding, move the view down
 * @param notif
 */
- (void)keyboardWillHide:(NSNotification *)notif{
    [UIView animateWithDuration:0.3 animations:^{
        self.containerView.frame = CGRectMake(0, 0, self.screenWidth, self.screenHeight);
    }];
}


#pragma mark - text view delegate
/**
 * Handle the behavior when the text field did change
 * @param UITextField
 */
-(void)textFieldDidChange:(FloatPlaceholderTextField *)textField {
    self.shouldChange = YES;
    self.saveButton.enabled = YES;
    if (textField.tag == 0) {
        if (textField.text.length > 0)
            self.propertyObj[@"name"] = textField.text;
        else self.propertyObj[@"name"] = @"";
    }
}

/**
 * Handle the behavior when the text field is began editing
 * @param UITextField
 */
-(void)textFieldDidBeginEditing:(UITextField *)textField {
    [self.containerView scrollRectToVisible:textField.frame animated:YES];
}

/**
 * When the text view begin editing, we re-layout the subviews
 * @param textView
 */
-(void)textViewDidBeginEditing:(UITextView *)textView{
    [self.containerView scrollRectToVisible:textView.frame animated:YES];
    [textView layoutSubviews];
}

/**
 * When the text view ended the editing, we also re-layout the subviews
 * @param textView
 */
-(void)textViewDidEndEditing:(UITextView *)textView {
    [textView layoutSubviews];
}

/**
 * When the text view change, we calculate the height of the new view
 * @param textview
 */
- (void)textViewDidChange:(UITextView *)textView {
    self.shouldChange = YES;
    self.saveButton.enabled = YES;
    CGSize newSize = [textView sizeThatFits:CGSizeMake(textView.frame.size.width, MAXFLOAT)];
    
    if (newSize.height > textView.frame.size.height) {
        CGRect newFrame = textView.frame;
        newFrame.size.height = newSize.height;
        textView.frame = newFrame;
        
        if (textView.text.length > 0)
            self.propertyObj[@"fullDescription"] = textView.text;
        else self.propertyObj[@"fullDescription"] = @"";
        
        self.staticViewContainer.frame = CGRectMake(0, CGRectGetMaxY(textView.frame) + 40, self.screenWidth, 455);
        self.containerView.contentSize = CGSizeMake(self.screenWidth, CGRectGetMaxY(self.staticViewContainer.frame));
    }
}


#pragma mark - bar action
/**
 * Handle the behavior when user tap outside text field
 */
-(void)resignResponder {
    if ([self.houseNameTextField isFirstResponder]) [self.houseNameTextField resignFirstResponder];
    if ([self.houseDescription isFirstResponder]) [self.houseDescription resignFirstResponder];
}

/**
 * Go back when user press the back button
 */
-(void)goBack {
    if (self.shouldChange) {
        int numBedrooms = (int)(self.numBedroomsSlider.value + 0.5);
        CGFloat numBathrooms = (int)(2 * self.numBathroomsSlider.value + 0.5) / 2.0;
        int numBeds = (int)(self.numBedsSlider.value + 0.5);
        int numGuests = (int)(self.numGuestsSlider.value + 0.5);
        self.propertyObj[@"numBedrooms"] = @(numBedrooms);
        self.propertyObj[@"numBathrooms"] = @(numBathrooms);
        self.propertyObj[@"numBeds"] = @(numBeds);
        self.propertyObj[@"numGuests"] = @(numGuests);
        
        NSInteger currentViewControllerIndex = [self.navigationController.viewControllers indexOfObject:self];
        MyPlaceDetailViewController *detailViewController = [self.navigationController.viewControllers objectAtIndex:currentViewControllerIndex-1];
        [detailViewController setNewPropertyObj:self.propertyObj];
    }

    [self.navigationController popViewControllerAnimated:YES];
}

/**
 * Save when user click on the save button
 */
-(void)saveButtonClick {
    self.saveButton.enabled = NO;
    int numBedrooms = (int)(self.numBedroomsSlider.value + 0.5);
    CGFloat numBathrooms = (int)(2 * self.numBathroomsSlider.value + 0.5) / 2.0;
    int numBeds = (int)(self.numBedsSlider.value + 0.5);
    int numGuests = (int)(self.numGuestsSlider.value + 0.5);
    self.propertyObj[@"numBedrooms"] = @(numBedrooms);
    self.propertyObj[@"numBathrooms"] = @(numBathrooms);
    self.propertyObj[@"numBeds"] = @(numBeds);
    self.propertyObj[@"numGuests"] = @(numGuests);
    
    if (self.propertyObj.objectId == nil) {
        [self.propertyObj saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            [[UserManager sharedUserManager] addUserProperty:self.propertyObj];
            [self.propertyObj pinInBackgroundWithName:@"places"];
        }];
    } else [self.propertyObj saveInBackground];
}
 
/**
 * Handle the behavior when user change the listing's type of his/her place
 * @param UIButton
 */
-(void)listingTypeButtonClick:(UIButton *)button {
    self.shouldChange = YES;
    self.saveButton.enabled = YES;
    [self.listingTypeEntireHouseButton setEnabled:YES];
    [self.listingTypePrivateRoomButton setEnabled:YES];
    [self.listingTypeSharedRoomButton setEnabled:YES];
    switch (button.tag) {
        case 0:
            [self.listingTypeEntireHouseButton setEnabled:NO];
            self.propertyObj[@"listingType"] = PROPERTY_LISTING_TYPE_ENTIRE_HOME_OR_APT;
            break;
            
        case 1:
            [self.listingTypePrivateRoomButton setEnabled:NO];
            self.propertyObj[@"listingType"] = PROPERTY_LISTING_TYPE_PRIVATE_ROOM;
            break;
            
        case 2:
            [self.listingTypeSharedRoomButton setEnabled:NO];
            self.propertyObj[@"listingType"] = PROPERTY_LISTING_TYPE_SHARED_ROOM;
            break;
            
        default:
            break;
    }
}

/**
 * Handle the behavior when the slider value changed
 * @param UISlider
 */
-(void)sliderValueChanged:(UISlider *)slider {
    self.shouldChange = YES;
    self.saveButton.enabled = YES;
    //the number of maximum bedroom is 6+, bathroom is 4+, bed is 9+, and guest is 9+
    if (slider.tag == 0) {
        int numBedrooms = (int)(slider.value + 0.5);
        if (numBedrooms == 7) self.numBedroomsLabel.text = @"6+ bdrs";
        else if (numBedrooms > 1) self.numBedroomsLabel.text = [NSString stringWithFormat:@"%d bdrs", numBedrooms];
        else self.numBedroomsLabel.text = [NSString stringWithFormat:@"%d bdr", numBedrooms];
    } else if (slider.tag == 1) {
        CGFloat numBathrooms = (int)(2 * slider.value + 0.5) / 2.0;
        if (numBathrooms > 4) self.numBathroomsLabel.text = @"4+ baths";
        else if (numBathrooms > 1) {
            if (numBathrooms == (int)numBathrooms) self.numBathroomsLabel.text = [NSString stringWithFormat:@"%d baths", (int)numBathrooms];
            else self.numBathroomsLabel.text = [NSString stringWithFormat:@"%.1f baths", numBathrooms];
        } else {
            if (numBathrooms == (int)numBathrooms) self.numBathroomsLabel.text = [NSString stringWithFormat:@"%d bath", (int)numBathrooms];
            else self.numBathroomsLabel.text = [NSString stringWithFormat:@"%.1f bath", numBathrooms];
        }
    } else if (slider.tag == 2) {
        int numBeds = (int)(slider.value + 0.5);
        if (numBeds == 10) self.numBedsLabel.text = @"9+ beds";
        else if (numBeds > 1) self.numBedsLabel.text = [NSString stringWithFormat:@"%d beds", numBeds];
        else self.numBedsLabel.text = [NSString stringWithFormat:@"%d bed", numBeds];
    } else if (slider.tag == 3) {
        int numGuests = (int)(slider.value + 0.5);
        if (numGuests == 10) self.numGuestsLabel.text = @"9+ guests";
        else if (numGuests > 1) self.numGuestsLabel.text = [NSString stringWithFormat:@"%d guests", numGuests];
        else self.numGuestsLabel.text = [NSString stringWithFormat:@"%d guest", numGuests];
    }
}


#pragma mark - keyboard changes
/**
 * Dismiss the keyboard by resign house name from the first responder
 */
-(void)dismissKeyboard {
    if ([self.houseNameTextField isFirstResponder]) [self.houseNameTextField resignFirstResponder];
}

/**
 * When user tap on the done button, also resign the view from the first responder
 */
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

/**
 * Dismiss the keyboard also when the scroll view begin scroll
 */
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self dismissKeyboard];
}

@end
