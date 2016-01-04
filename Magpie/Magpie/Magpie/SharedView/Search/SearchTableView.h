//
//  SearchTableView.h
//  Magpie
//
//  Created by minh thao nguyen on 4/27/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@protocol SearchTableViewDelegate <NSObject>
-(void)searchLocation:(PFGeoPoint *)location andAddress:(NSString *)address;
@end

@interface SearchTableView : UIView <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, weak) id<SearchTableViewDelegate> searchDelegate;
-(id)initWithOrigin:(CGPoint)origin andWidth:(CGFloat)width;
-(void)resignTextFieldFirstResponder;
@end
