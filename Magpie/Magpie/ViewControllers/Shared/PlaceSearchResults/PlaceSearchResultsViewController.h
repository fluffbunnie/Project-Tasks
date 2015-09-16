//
//  PlaceSearchResultsViewController.h
//  Magpie
//
//  Created by minh thao nguyen on 8/28/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "CHTCollectionViewWaterfallLayout.h"

@interface PlaceSearchResultsViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, CHTCollectionViewDelegateWaterfallLayout>
@property (nonatomic, strong) NSString *searchedAddress;
@property (nonatomic, strong) PFGeoPoint *searchedLocation;
@end
