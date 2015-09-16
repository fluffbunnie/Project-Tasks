//
//  MyPlaceDetailHeaderView.h
//  Magpie
//
//  Created by minh thao nguyen on 5/11/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@protocol MyPlaceDetailHeaderViewDelegate <NSObject>
-(void)addNewPhoto;
-(void)editCurrentPhoto;
@end

@interface MyPlaceDetailHeaderView : UIView <UIScrollViewDelegate>
@property (nonatomic, weak) id<MyPlaceDetailHeaderViewDelegate> headerDelegate;
@property (nonatomic, strong) PFObject *currentPhotoObj;
-(void)setPropertyPhotos:(NSArray *)photos;
-(void)appendPhoto:(PFObject *)photoObj;
-(void)removeCurrentPhoto;
@end
