//
//  HomePageViewController.h
//  Magpie
//
//  Created by minh thao nguyen on 4/22/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomePageView.h"
#import "MenuView.h"
#import "SearchTableView.h"
#import <Parse/Parse.h>

@interface HomePageViewController : UIViewController <HomePageViewDelegate, MenuViewDelegate, SearchTableViewDelegate>
@end
