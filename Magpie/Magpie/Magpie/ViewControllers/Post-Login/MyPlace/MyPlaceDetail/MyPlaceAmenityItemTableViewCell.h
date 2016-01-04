//
//  MyPlaceAmenityItemTableViewCell.h
//  Magpie
//
//  Created by minh thao nguyen on 5/25/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AmenityItem.h"

@protocol MyPlaceAmenityItemTableViewCellDelegate <NSObject>
-(void)textFieldWillBeginEditting:(UITextField *)textField;
@end

@interface MyPlaceAmenityItemTableViewCell : UITableViewCell <UITextFieldDelegate>
@property (nonatomic, weak) id<MyPlaceAmenityItemTableViewCellDelegate> cellDelegate;
-(void)setAmenityItem:(AmenityItem *)item;
-(void)cellClicked;
@end
