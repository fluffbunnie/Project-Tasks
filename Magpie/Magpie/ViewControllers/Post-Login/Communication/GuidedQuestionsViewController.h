//
//  GuidedQuestionsViewController.h
//  Magpie
//
//  Created by minh thao nguyen on 4/23/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatViewController.h"

@interface GuidedQuestionsViewController : UITableViewController
@property (nonatomic, weak) ChatViewController *chatController;
@end
