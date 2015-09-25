//
//  MenuItemTableViewCell.h
//  Magpie
//
//  Created by minh thao nguyen on 4/23/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuItemTableViewCell : UITableViewCell
-(void)setIcon:(UIImage *)icon highlighedStateIcon:(UIImage *)highlightIcon andTitle:(NSString *)title;
-(void)setNotificationLabel:(NSString *)label;
@end
