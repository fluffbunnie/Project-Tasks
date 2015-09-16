//
//  PropertyDetailListingInfoTableViewCell.m
//  Easyswap
//
//  Created by minh thao nguyen on 12/21/14.
//  Copyright (c) 2014 Easyswap Inc. All rights reserved.
//

#import "PropertyDetailListingInfoTableViewCell.h"
#import "FontColor.h"
#import "UIVerticalButton.h"
#import "ParseConstant.h"

static NSString *LISTING_INFO_BEDROOM_GRAY = @"ListingInfoBedroomGray";
static NSString *LISTING_INFO_BATHROOM_GRAY = @"ListingInfoBathGray";
static NSString *LISTING_INFO_BED_GRAY = @"ListingInfoBedGray";
static NSString *LISTING_INFO_GUEST_GRAY = @"ListingInfoGuestGray";

@interface PropertyDetailListingInfoTableViewCell()
@property (nonatomic, assign) CGFloat viewWidth;

@property (nonatomic, strong) UILabel *sectionTitleLabel;
@property (nonatomic, strong) UILabel *propertyTypeLabel;
@property (nonatomic, strong) UIButton *numBedroomButton;
@property (nonatomic, strong) UIButton *numBathButton;
@property (nonatomic, strong) UIButton *numBedButton;
@property (nonatomic, strong) UIButton *numGuestButton;
@property (nonatomic, strong) UIView *bottomSeparatorView;
@property (nonatomic, strong) UIView *firstSeparatorView;
@property (nonatomic, strong) UIView *secondSeparatorView;
@property (nonatomic, strong) UIView *thirdSeparatorView;
@end

@implementation PropertyDetailListingInfoTableViewCell
#pragma mark - initiation
/**
 * Lazily init the section title label
 * @return UILabel
 */
-(UILabel *)sectionTitleLabel {
    if (_sectionTitleLabel == nil) {
        _sectionTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 30, self.viewWidth - 40, 45)];
        _sectionTitleLabel.textAlignment = NSTextAlignmentCenter;
        _sectionTitleLabel.textColor = [FontColor themeColor];
        _sectionTitleLabel.numberOfLines = 2;
        _sectionTitleLabel.font = [UIFont fontWithName:@"AvenirNext-Medium" size:15];
    }
    return _sectionTitleLabel;
}

/**
 * Lazily init the host's label
 * @return UILabel
 */
-(UILabel *)propertyTypeLabel {
    if (_propertyTypeLabel == nil) {
        _propertyTypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(35, 75, self.viewWidth - 70, 20)];
        _propertyTypeLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:15];
        _propertyTypeLabel.textColor = [FontColor descriptionColor];
        _propertyTypeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _propertyTypeLabel;
}

/**
 * Lazily init the number of bedroom button
 * @return UIButton
 */
-(UIButton *)numBedroomButton {
    if (_numBedroomButton == nil) {
        _numBedroomButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 115, self.viewWidth/4, 50)];
        _numBedroomButton.userInteractionEnabled = NO;
        _numBedroomButton.titleLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:13];
        [_numBedroomButton setTitleColor:[FontColor descriptionColor] forState:UIControlStateNormal];
        [_numBedroomButton setImage:[UIImage imageNamed:LISTING_INFO_BEDROOM_GRAY] forState:UIControlStateNormal];
    }
    return _numBedroomButton;
}

/**
 * Lazily init the number of baths button
 * @return UIButton
 */
-(UIButton *)numBathButton {
    if (_numBathButton == nil) {
        _numBathButton = [[UIButton alloc] initWithFrame:CGRectMake(self.viewWidth/4, 115, self.viewWidth/4, 50)];
        _numBathButton.userInteractionEnabled = NO;
        _numBathButton.titleLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:13];
        [_numBathButton setTitleColor:[FontColor descriptionColor] forState:UIControlStateNormal];
        [_numBathButton setImage:[UIImage imageNamed:LISTING_INFO_BATHROOM_GRAY] forState:UIControlStateNormal];
    }
    return _numBathButton;
}

/**
 * Lazily init the number of beds button
 * @return UIButton
 */
-(UIButton *)numBedButton {
    if (_numBedButton == nil) {
        _numBedButton = [[UIButton alloc] initWithFrame:CGRectMake(self.viewWidth/2, 115, self.viewWidth/4, 50)];
        _numBedButton.userInteractionEnabled = NO;
        _numBedButton.titleLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:13];
        [_numBedButton setTitleColor:[FontColor descriptionColor] forState:UIControlStateNormal];
        [_numBedButton setImage:[UIImage imageNamed:LISTING_INFO_BED_GRAY] forState:UIControlStateNormal];
    }
    return _numBedButton;
}

/**
 * Lazily init the number of guests button
 * @return UIButton
 */
-(UIButton *)numGuestButton {
    if (_numGuestButton == nil) {
        _numGuestButton = [[UIButton alloc] initWithFrame:CGRectMake(3 * self.viewWidth/4, 115, self.viewWidth/4, 50)];
        _numGuestButton.userInteractionEnabled = NO;
        _numGuestButton.titleLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:13];
        [_numGuestButton setTitleColor:[FontColor descriptionColor] forState:UIControlStateNormal];
        [_numGuestButton setImage:[UIImage imageNamed:LISTING_INFO_GUEST_GRAY] forState:UIControlStateNormal];
    }
    return _numGuestButton;
}

/**
 * Lazily init the bottom separator view
 * @return UIView
 */
-(UIView *)bottomSeparatorView {
    if (_bottomSeparatorView == nil) {
        _bottomSeparatorView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.numGuestButton.frame) + 5, self.viewWidth, 1)];
        _bottomSeparatorView.backgroundColor = [FontColor tableSeparatorColor];
        _bottomSeparatorView.alpha = 0.3;
    }
    return _bottomSeparatorView;
}

/**
 * Lazily init the first separator view
 * @return UIView
 */
-(UIView *)firstSeparatorView {
    if (_firstSeparatorView == nil) {
        _firstSeparatorView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.numBedroomButton.frame), CGRectGetMinY(self.numBedroomButton.frame), 1, 55)];
        
        CAGradientLayer *gradient = [CAGradientLayer layer];
        gradient.frame = CGRectMake(0, 0, 1, 55);;
        gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor whiteColor] CGColor], (id)[[FontColor tableSeparatorColor] CGColor], nil];
        
        [_firstSeparatorView.layer insertSublayer:gradient atIndex:0];
        _firstSeparatorView.alpha = 0.3;
    }
    return _firstSeparatorView;
}

/**
 * Lazily init the second separator view
 * @return UIView
 */
-(UIView *)secondSeparatorView {
    if (_secondSeparatorView == nil) {
        _secondSeparatorView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.numBathButton.frame), CGRectGetMinY(self.numBathButton.frame), 1, 55)];
        
        CAGradientLayer *gradient = [CAGradientLayer layer];
        gradient.frame = CGRectMake(0, 0, 1, 55);;
        gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor whiteColor] CGColor], (id)[[FontColor tableSeparatorColor] CGColor], nil];
        
        [_secondSeparatorView.layer insertSublayer:gradient atIndex:0];
        _secondSeparatorView.alpha = 0.3;
    }
    return _secondSeparatorView;
}

/**
 * Lazily init the third separator view
 * @return UIView
 */
-(UIView *)thirdSeparatorView {
    if (_thirdSeparatorView == nil) {
        _thirdSeparatorView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.numBedButton.frame), CGRectGetMinY(self.numBedButton.frame), 1, 55)];
        
        CAGradientLayer *gradient = [CAGradientLayer layer];
        gradient.frame = CGRectMake(0, 0, 1, 55);;
        gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor whiteColor] CGColor], (id)[[FontColor tableSeparatorColor] CGColor], nil];
        
        [_thirdSeparatorView.layer insertSublayer:gradient atIndex:0];
        _thirdSeparatorView.alpha = 0.3;
    }
    return _thirdSeparatorView;
}

#pragma mark - public method
-(id)init {
    self = [super init];
    if (self) {
        self.viewWidth = [[UIScreen mainScreen] bounds].size.width;
        
        [self.contentView addSubview:[self sectionTitleLabel]];
        [self.contentView addSubview:[self propertyTypeLabel]];
        [self.contentView addSubview:[self numBedroomButton]];
        [self.contentView addSubview:[self numBathButton]];
        [self.contentView addSubview:[self numBedButton]];
        [self.contentView addSubview:[self numGuestButton]];
        [self.contentView addSubview:[self bottomSeparatorView]];
        [self.contentView addSubview:[self firstSeparatorView]];
        [self.contentView addSubview:[self secondSeparatorView]];
        [self.contentView addSubview:[self thirdSeparatorView]];
    }
    return self;
}

/**
 * Set the property object
 * @param PFObject
 */
-(void)setPropertyObject:(PFObject *)propertyObj {
    //set the name
    NSString *name = propertyObj[@"name"] ? propertyObj[@"name"] : @"";
    if (name.length > 0) name = [name stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[[name substringToIndex:1] uppercaseString]];
    self.sectionTitleLabel.text = name;
    
    //set the listing type
    NSString *propertyType = propertyObj[@"listingType"] ? propertyObj[@"listingType"] : @"";
    if ([propertyType isEqualToString:PROPERTY_LISTING_TYPE_PRIVATE_ROOM]) propertyType = @"Private space";
    else if ([propertyType isEqualToString:PROPERTY_LISTING_TYPE_SHARED_ROOM]) propertyType = @"Shared space";
    else propertyType = @"Entire place";
    self.propertyTypeLabel.text = propertyType;
    
    //set the number of bedrooms
    if (propertyObj[@"numBedrooms"]) {
        int numBedrooms = [propertyObj[@"numBedrooms"] intValue];
        if (numBedrooms > 6) [self.numBedroomButton setTitle:@"6+ bdrs" forState:UIControlStateNormal];
        else if (numBedrooms > 1) [self.numBedroomButton setTitle:[NSString stringWithFormat:@"%d bdrs", numBedrooms] forState:UIControlStateNormal];
        else [self.numBedroomButton setTitle:[NSString stringWithFormat:@"%d bdr", numBedrooms] forState:UIControlStateNormal];
    } else [self.numBedroomButton setTitle:@"n/a" forState:UIControlStateNormal];
    [self.numBedroomButton centerVerticallyWithPadding:8];
    
    //set number of bathrooms
    if (propertyObj[@"numBathrooms"]) {
        float numBaths = [propertyObj[@"numBathrooms"] floatValue];
        if (numBaths > 4) [self.numBathButton setTitle:@"4+ baths" forState:UIControlStateNormal];
        else if (numBaths > 1) {
            if (numBaths == (int)numBaths) [self.numBathButton setTitle:[NSString stringWithFormat:@"%d baths", (int)numBaths] forState:UIControlStateNormal];
            else [self.numBathButton setTitle:[NSString stringWithFormat:@"%.1f baths", numBaths] forState:UIControlStateNormal];
        } else {
            if (numBaths == (int)numBaths) [self.numBathButton setTitle:[NSString stringWithFormat:@"%d bath", (int)numBaths] forState:UIControlStateNormal];
            else [self.numBathButton setTitle:[NSString stringWithFormat:@"%.1f bath", numBaths] forState:UIControlStateNormal];
        }
    } else [self.numBathButton setTitle:@"n/a" forState:UIControlStateNormal];
    [self.numBathButton centerVerticallyWithPadding:8];
    
    //set number of beds
    if (propertyObj[@"numBeds"]) {
        int numBeds = [propertyObj[@"numBeds"] intValue];
        if (numBeds > 9) [self.numBedButton setTitle:@"9+ beds" forState:UIControlStateNormal];
        else if (numBeds > 1) [self.numBedButton setTitle:[NSString stringWithFormat:@"%d beds", numBeds] forState:UIControlStateNormal];
        else [self.numBedButton setTitle:[NSString stringWithFormat:@"%d bed", numBeds] forState:UIControlStateNormal];
    } else [self.numBedButton setTitle:@"n/a" forState:UIControlStateNormal];
    [self.numBedButton centerVerticallyWithPadding:8];

    //set the number of guests
    if (propertyObj[@"numGuests"]) {
        int numGuests = [propertyObj[@"numGuests"] intValue];
        if (numGuests > 9) [self.numGuestButton setTitle:@"9+ guests" forState:UIControlStateNormal];
        else if (numGuests > 1) [self.numGuestButton setTitle:[NSString stringWithFormat:@"%d guests", numGuests] forState:UIControlStateNormal];
        else [self.numGuestButton setTitle:[NSString stringWithFormat:@"%d guest", numGuests] forState:UIControlStateNormal];
    } else [self.numGuestButton setTitle:@"n/a" forState:UIControlStateNormal];
    [self.numGuestButton centerVerticallyWithPadding:8];
}

-(CGFloat)viewHeight {
    return 50 + 25 + 20 + 20 + 50 + 25;
}


@end
