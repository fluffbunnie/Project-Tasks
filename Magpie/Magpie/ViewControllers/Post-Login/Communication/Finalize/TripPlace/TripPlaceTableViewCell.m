//
//  TripPlaceTableViewCell.m
//  Magpie
//
//  Created by minh thao nguyen on 5/27/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import "TripPlaceTableViewCell.h"
#import "TripDetailPlaceView.h"
#import "FontColor.h"

@interface TripPlaceTableViewCell()
@property (nonatomic, strong) TripDetailPlaceView *placeItem;
@end

@implementation TripPlaceTableViewCell
#pragma mark - initiation
/**
 * Lazily init the place item view
 * @return TripDetailPlaceView
 */
-(TripDetailPlaceView *)placeItem {
    if (_placeItem == nil) {
        CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
        _placeItem = [[TripDetailPlaceView alloc] initWithFrame:CGRectMake(15, 20, screenWidth - 30, 200)];
        _placeItem.userInteractionEnabled = NO;
    }
    return _placeItem;
}

#pragma mark - public method
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [FontColor tableSeparatorColor];
        [self.contentView addSubview:[self placeItem]];
    }
    return self;
}

/**
 * Set the property obj to be display
 * @param PFObject
 */
-(void)setPropertyObj:(PFObject *)propertyObj {
    [self.placeItem setPropertyObj:propertyObj];
}


@end
