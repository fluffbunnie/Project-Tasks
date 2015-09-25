//
//  EditPhotoObjViewController.h
//  Magpie
//
//  Created by minh thao nguyen on 5/18/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface EditPhotoObjViewController : UIViewController <UIScrollViewDelegate>
@property (nonatomic, strong) PFObject *photoObj;
@end
