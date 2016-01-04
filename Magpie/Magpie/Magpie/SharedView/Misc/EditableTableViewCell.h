//
//  EditableTableViewCell.h
//  Magpie
//
//  Created by minh thao nguyen on 5/4/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditableTableViewCell : UITableViewCell
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UITextField *descriptionLabel;
@property (nonatomic, strong) UIView *separator;

-(void)setPlaceHolderText:(NSString *)placeholder;
@end
