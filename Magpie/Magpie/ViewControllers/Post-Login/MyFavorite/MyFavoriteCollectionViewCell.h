//
//  MyFavoriteCollectionViewCell.h
//  Magpie
//
//  Created by minh thao nguyen on 5/8/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface MyFavoriteCollectionViewCell : UICollectionViewCell
+(CGSize)sizeForLikeObj:(PFObject *)likeObj;
-(void)setLikeObj:(PFObject *)likeObj;
@end
