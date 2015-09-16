//
//  MyPlaceDetailViewController.h
//  Magpie
//
//  Created by minh thao nguyen on 5/10/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "PhotoPicker.h"
#import "MyPlaceDetailHeaderView.h"
#import <MapKit/MapKit.h>
#import "SPGooglePlacesAutocompletePlace.h"

@interface MyPlaceDetailViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, PhotoPickerDelegate, MyPlaceDetailHeaderViewDelegate, UIAlertViewDelegate>
@property (nonatomic, strong) PFObject *propertyObj;
-(void)setLocation:(SPGooglePlacesAutocompletePlace *)location;
-(void)setNewPropertyObj:(PFObject *)propertyObj;
@end
