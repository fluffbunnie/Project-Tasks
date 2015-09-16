//
//  MyProfileTableViewController.h
//  Magpie
//
//  Created by minh thao nguyen on 5/4/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <MapKit/MapKit.h>
#import "PhotoPicker.h"
#import "Cloudinary.h"
#import "CLUploader.h"
#import "SPGooglePlacesAutocompletePlace.h"

@interface MyProfileTableViewController : UITableViewController<UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, PhotoPickerDelegate>
-(void)setLocation:(SPGooglePlacesAutocompletePlace *)location;
-(void)setAboutMe:(NSString *)aboutMe;
@end
