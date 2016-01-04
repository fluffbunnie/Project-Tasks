//
//  TripDetailPlaceView.h
//  Magpie
//
//  Created by minh thao nguyen on 5/26/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@protocol TripDetailPlaceViewDelegate <NSObject>
-(void)selectNewProperty;
@end

@interface TripDetailPlaceView : UIView
@property (nonatomic, weak) id<TripDetailPlaceViewDelegate> tripDetailPlaceDelegate;
-(void)setPropertyObj:(PFObject *)propertyObj;
@end
