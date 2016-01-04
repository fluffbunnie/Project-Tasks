//
//  LocationTableViewCell.m
//  Magpie
//
//  Created by minh thao nguyen on 5/5/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import "LocationTableViewCell.h"
#import "FontColor.h"

@interface LocationTableViewCell()
@property (nonatomic, assign) CGFloat viewWidth;
@property (nonatomic, assign) CGFloat viewHeight;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *descriptionLabel;
@property (nonatomic, strong) UIView *separator;
@end

@implementation LocationTableViewCell
#pragma mark - instantiation
/**
 * Lazily init the title label. This is basically the street in the location dictionary
 * @return UILabel
 */
-(UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, self.viewWidth - 40, 20)];
        _titleLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:15];
        _titleLabel.textColor = [FontColor titleColor];
    }
    return _titleLabel;
}

/**
 * Lazily init the description label. This is form by using format of city, state, country
 * @return UILabel
 */
-(UILabel *)descriptionLabel {
    if (_descriptionLabel == nil) {
        _descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 30, self.viewWidth - 40, 19)];
        _descriptionLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:12];
        _descriptionLabel.textColor = [FontColor descriptionColor];
    }
    return _descriptionLabel;
}

/**
 * Lazily init the separator view
 * @return UIView
 */
-(UIView *)separator {
    if (_separator == nil) {
        _separator = [[UIView alloc] initWithFrame:CGRectMake(20, 59, self.viewWidth - 20, 1)];
        _separator.backgroundColor = [FontColor tableSeparatorColor];
    }
    return _separator;
}

#pragma mark - public method
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.viewWidth = [[UIScreen mainScreen] bounds].size.width;
        self.viewHeight = [[UIScreen mainScreen] bounds].size.height;
        
        [self.contentView addSubview:[self titleLabel]];
        [self.contentView addSubview:[self descriptionLabel]];
        [self.contentView addSubview:[self separator]];
    }
    return self;
}

/**
 * Set the location dictionary
 * @param NSDictionary
 */
-(void)setLocationDictionarty:(NSDictionary *)location {
    if (location[@"Street"]) self.titleLabel.text = location[@"Street"];
    else if (location[@"Name"]) self.titleLabel.text = location[@"Name"];
    
    NSMutableArray *descriptionArray = [[NSMutableArray alloc] init];
    if (location[@"City"]) [descriptionArray addObject:location[@"City"]];
    if (location[@"State"]) [descriptionArray addObject:location[@"State"]];
    if (location[@"Country"]) [descriptionArray addObject:location[@"Country"]];
    self.descriptionLabel.text = [descriptionArray componentsJoinedByString:@", "];
}

/**
 * Set the location String
 * @param NSString
 */
-(void)setLocationString:(NSString *)location {
    NSUInteger separatorIndex = [location rangeOfString:@","].location;
    if (separatorIndex != NSNotFound) {
        self.titleLabel.text = [location substringToIndex:separatorIndex];
        self.descriptionLabel.text = (location.length > (separatorIndex + 1)) ? [location substringFromIndex:separatorIndex + 2] : @"";
    } else {
        self.titleLabel.text = location ? location : @"";
        self.descriptionLabel.text = @"";
    }
}

@end
