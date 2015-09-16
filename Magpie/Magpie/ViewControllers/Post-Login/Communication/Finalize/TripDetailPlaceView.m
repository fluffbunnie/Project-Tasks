//
//  TripDetailPlaceView.m
//  Magpie
//
//  Created by minh thao nguyen on 5/26/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import "TripDetailPlaceView.h"
#import "TripDetailEmptyPlaceButton.h"
#import "TripDetailPlaceItemView.h"

@interface TripDetailPlaceView()
@property (nonatomic, strong) TripDetailPlaceItemView *placeItemView;
@property (nonatomic, strong) TripDetailEmptyPlaceButton *pickPlaceButton;
@end

@implementation TripDetailPlaceView
#pragma mark - initiation
/**
 * Lazily init the place item view
 * @return TripDetailPlaceItemView
 */
-(TripDetailPlaceItemView *)placeItemView {
    if (_placeItemView == nil) {
        _placeItemView = [[TripDetailPlaceItemView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _placeItemView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectNewProperty)];
        [_placeItemView addGestureRecognizer:tap];
    }
    return _placeItemView;
}

/**
 * Lazily init the pick a place button
 * @return TripDetailEmptyPlaceButton
 */
-(TripDetailEmptyPlaceButton *)pickPlaceButton {
    if (_pickPlaceButton == nil) {
        _pickPlaceButton = [[TripDetailEmptyPlaceButton alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        [_pickPlaceButton addTarget:self action:@selector(selectNewProperty) forControlEvents:UIControlEventTouchUpInside];
    }
    return _pickPlaceButton;
}


#pragma mark - public method
-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.clipsToBounds = YES;
        self.layer.cornerRadius = 5;
        self.layer.masksToBounds = NO;
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowOpacity = 0.07;
        self.layer.shadowRadius = 2;
        self.layer.shadowOffset = CGSizeMake(0, 1);
        
        [self addSubview:[self placeItemView]];
        [self addSubview:[self pickPlaceButton]];
    }
    return self;
}

/**
 * Set the property object to be display
 * @param PFObject
 */
-(void)setPropertyObj:(PFObject *)propertyObj {
    self.pickPlaceButton.hidden = YES;
    [self.placeItemView setPropertyObj:propertyObj];
}

#pragma mark - UI gesture
/**
 * Handle when user click to select a new place
 */
-(void)selectNewProperty {
    [self.tripDetailPlaceDelegate selectNewProperty];
}

@end
