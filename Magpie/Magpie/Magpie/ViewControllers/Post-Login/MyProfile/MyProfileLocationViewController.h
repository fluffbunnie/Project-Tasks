//
//  MyProfileLocationViewController.h
//  Magpie
//
//  Created by minh thao nguyen on 5/4/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyProfileLocationViewController : UIViewController <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSString *userLocation;
@end
