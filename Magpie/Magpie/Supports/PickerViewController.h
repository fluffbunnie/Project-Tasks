//
//  PickerViewController.h
//  Magpie
//
//  Created by minh thao nguyen on 5/6/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoPicker.h"

@interface PickerViewController : UIViewController <UIScrollViewDelegate>
@property (nonatomic, strong) UIImage *pickedImage;
@property (nonatomic, weak) PhotoPicker *pickerRef;
@property (nonatomic, assign) BOOL editable;
@end
