//
//  MyPlaceLocationViewController.h
//  Magpie
//
//  Created by minh thao nguyen on 5/12/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyPlaceLocationViewController : UIViewController<UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSString *placeLocation;
@end
