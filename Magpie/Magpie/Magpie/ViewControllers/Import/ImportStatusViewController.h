//
//  ImportingStatusViewController.h
//  Magpie
//
//  Created by minh thao nguyen on 5/9/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "ImportPropertyListWebView.h"
#import "ImportPropertyWebView.h"
#import "ImportCompleteView.h"

@interface ImportStatusViewController : UIViewController <ImportPropertyListWebViewDelegate, ImportPropertyWebViewDelegate, ImportCompleteViewDelegate, UIAlertViewDelegate>
@property (nonatomic, strong) NSString *airbnbUid;
@end
