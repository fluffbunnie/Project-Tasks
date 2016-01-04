//
//  PropertyDetailAboutUserTableViewCell.h
//  Easyswap
//
//  Created by minh thao nguyen on 12/23/14.
//  Copyright (c) 2014 Easyswap Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@protocol PropertyDetailAboutUserDelegate <NSObject>
-(void)refreshTable;
@optional
-(void)goToUserProfile;
@end

@interface PropertyDetailAboutUserTableViewCell : UITableViewCell

@property (nonatomic, weak) id<PropertyDetailAboutUserDelegate> delegate;
@property (nonatomic, assign) BOOL shouldAllowUserToEditProfile;
-(void)setUserObject:(PFObject *)userObj;
-(CGFloat)viewHeight;

@end
