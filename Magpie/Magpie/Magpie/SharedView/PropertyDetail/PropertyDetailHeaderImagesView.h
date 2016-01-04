//
//  PropertyDetailHeaderImagesView.h
//  Magpie
//
//  Created by minh thao nguyen on 2/16/15.
//  Copyright (c) 2015 Easyswap Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@protocol PropertyDetailHeaderImagesViewDelegate <NSObject>
-(void)propertyHeaderClicked;
@end

@interface PropertyDetailHeaderImagesView : UIScrollView <UIScrollViewDelegate>
@property (nonatomic, weak) id<PropertyDetailHeaderImagesViewDelegate> headerDelegate;
-(void)setViewFrame:(CGRect)frame;
-(void)setPropertyPhotos:(NSArray *)photos;
-(void)setCoverPhoto:(NSString *)url;
-(void)showPropertyDescription:(BOOL)shouldShow;
@end
