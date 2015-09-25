//
//  MyPlaceInfoViewController.h
//  Magpie
//
//  Created by minh thao nguyen on 5/12/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface MyPlaceInfoViewController : UIViewController <UITextFieldDelegate, UITextViewDelegate, UIScrollViewDelegate>
@property (nonatomic, strong) PFObject *propertyObj;
@end
