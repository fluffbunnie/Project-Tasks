//
//  PlaceSearchResultsCollectionViewCell.h
//  Magpie
//
//  Created by minh thao nguyen on 8/28/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface PlaceSearchResultsCollectionViewCell : UICollectionViewCell
+(CGSize)sizeForPropertyObj:(PFObject *)propertyObj withDistance:(double)distance;
-(void)setPropertyObj:(PFObject *)propertyObj withDistance:(double)distance;
@end
