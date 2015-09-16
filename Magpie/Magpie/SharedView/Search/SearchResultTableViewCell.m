//
//  SearchResultTableViewCell.m
//  Magpie
//
//  Created by minh thao nguyen on 4/29/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import "SearchResultTableViewCell.h"
#import "FontColor.h"

@interface SearchResultTableViewCell()

@property (nonatomic, assign) CGFloat cellWidth;
@property (nonatomic, strong) UIView *borderView;
@property (nonatomic, strong) UILabel *searchResultLabel;

@end

@implementation SearchResultTableViewCell
#pragma mark - initiation
/**
 * Lazily init the border view
 * @return UIView
 */
-(UIView *)borderView {
    if (_borderView == nil) {
        _borderView = [[UIView alloc] initWithFrame:CGRectMake(12, 0, self.cellWidth - 30, 1)];
        _borderView.backgroundColor = [FontColor tableSeparatorColor];
    }
    return _borderView;
}

/**
 * Lazily init the search result label
 * @return UILabel
 */
-(UILabel *)searchResultLabel {
    if (_searchResultLabel == nil) {
        _searchResultLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 1, self.cellWidth - 35, 39)];
        _searchResultLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:13];
        _searchResultLabel.textColor = [FontColor titleColor];
    }
    return _searchResultLabel;
}

#pragma mark - public methods
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.cellWidth = [[UIScreen mainScreen] bounds].size.width - 70;
        [self.contentView addSubview:[self borderView]];
        [self.contentView addSubview:[self searchResultLabel]];
    }
    return self;
}

/**
 * Set the location label using the location object
 * @param NSString
 */
-(void)setLocation:(NSString *)location {
    self.searchResultLabel.text = location;
}

@end
