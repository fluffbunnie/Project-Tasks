//
//  MyProfileViewController.h
//  Magpie
//
//  Created by minh thao nguyen on 9/10/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <MapKit/MapKit.h>
#import "PhotoPicker.h"
#import "Cloudinary.h"
#import "CLUploader.h"
#import "SPGooglePlacesAutocompletePlace.h"

@interface MyProfileViewController : UIViewController <UITextFieldDelegate, UITextViewDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate, PhotoPickerDelegate>
-(void)setLocation:(SPGooglePlacesAutocompletePlace *)place;
@end
