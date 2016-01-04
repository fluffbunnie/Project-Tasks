//
//  MyPlaceAmenityItemTableViewCell.m
//  Magpie
//
//  Created by minh thao nguyen on 5/25/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import "MyPlaceAmenityItemTableViewCell.h"
#import "FontColor.h"

@interface MyPlaceAmenityItemTableViewCell()
@property (nonatomic, strong) AmenityItem *amenity;
@property (nonatomic, assign) CGFloat viewWidth;
@property (nonatomic, strong) UIView *borderView;
@property (nonatomic, strong) UIImageView *iconImage;
@property (nonatomic, strong) UITextField *descriptionText;

@property (nonatomic, strong) NSDictionary *placeholderTextAttribute;
@end

@implementation MyPlaceAmenityItemTableViewCell
#pragma mark - initiation
/**
 * Lazily init the border view
 * @return UIView
 */
-(UIView *)borderView {
    if (_borderView == nil) {
        _borderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.viewWidth, 1)];
        _borderView.backgroundColor = [FontColor tableSeparatorColor];
    }
    return _borderView;
}
/**
 * Lazily init the icon image
 * @return UIImageView
 */
-(UIImageView *)iconImage {
    if (_iconImage == nil) {
        _iconImage = [[UIImageView alloc] initWithFrame:CGRectMake(9, 7, 36, 36)];
        _iconImage.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _iconImage;
}

/**
 * Lazily init the description text
 * @return UITextField
 */
-(UITextField *)descriptionText {
    if (_descriptionText == nil) {
        _descriptionText = [[UITextField alloc] initWithFrame:CGRectMake(55, 5, self.viewWidth - 65, 40)];
        _descriptionText.font = [UIFont fontWithName:@"AvenirNext-Regular" size:14];
        _descriptionText.textColor = [FontColor titleColor];
        _descriptionText.userInteractionEnabled = NO;
        _descriptionText.delegate = self;
        
        [_descriptionText addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    }
    return _descriptionText;
}

#pragma mark - public method
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.viewWidth = [UIScreen mainScreen].bounds.size.width;
        self.placeholderTextAttribute = @{NSForegroundColorAttributeName:[FontColor descriptionColor],
                                          NSFontAttributeName:[UIFont fontWithName:@"AvenirNext-Regular" size:14]};
        [self.contentView addSubview:[self borderView]];
        [self.contentView addSubview:[self iconImage]];
        [self.contentView addSubview:[self descriptionText]];
    }
    return self;
}

/**
 * Set the amenity item for the cell
 * @param AmenityItem
 */
-(void)setAmenityItem:(AmenityItem *)item {
    self.amenity = item;
    [self relayoutView];
}

/**
 * Handle the behavior when the cell is clicked
 */
-(void)cellClicked {
    self.amenity.amenityEnabled = !self.amenity.amenityEnabled;
    [self relayoutView];
    if (self.amenity.amenityEnabled) [self.descriptionText becomeFirstResponder];
}

#pragma mark - view format helper
/**
 * Display and format the amenity item
 */
-(void)relayoutView {
    if (self.amenity.amenityEnabled) {
        self.iconImage.image = self.amenity.amenityImageActive;
        self.descriptionText.text = self.amenity.amenityDescription;
        self.descriptionText.userInteractionEnabled = YES;
        self.descriptionText.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.amenity.amenitySelectedPlaceholder attributes:self.placeholderTextAttribute];
    } else {
        self.iconImage.image = self.amenity.amenityImageInactive;
        self.descriptionText.userInteractionEnabled = NO;
        self.descriptionText.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.amenity.amenityName attributes:self.placeholderTextAttribute];
        self.descriptionText.text = @"";
        self.amenity.amenityDescription = @"";
    }
}

#pragma mark - text field
/**
 * TextField begin editing
 * @param UITextField
 */
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    [self.cellDelegate textFieldWillBeginEditting:textField];
    return YES;
}

/**
 * TextField end editing
 * @param UITextField
 */
-(void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField.text.length == 0) {
        textField.text = self.amenity.amenityDefaultActiveText;
        self.amenity.amenityDescription = self.amenity.amenityDefaultActiveText;
    }
}

/**
 * TextField should return
 * @param UITextField
 */
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.descriptionText resignFirstResponder];
    return YES;
}

/**
 * Textfield changed
 * @param UITextField
 */
-(void)textFieldChanged:(UITextField *)textField {
    self.amenity.amenityDescription = textField.text;
}

@end
