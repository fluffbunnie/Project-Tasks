//
//  BrowsePropertyViewController.h
//  Magpie
//
//  Created by minh thao nguyen on 4/23/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BrowseCardAlbumView.h"
#import "BrowseDetailScrollView.h"
#import <Parse/Parse.h>
#import "ImportPropertyWebView.h"

@interface BrowsePropertyViewController : UIViewController <ImportPropertyWebViewDelegate>

@property (nonatomic, strong) PFGeoPoint *location;

@property (nonatomic, strong) NSString *searchedLocation;
@property (nonatomic, strong) NSString *deckName;
@property (nonatomic, strong) UIImage *capturedBackground;
@property (nonatomic, strong) NSArray *locations;

-(void)goBack;
-(void)cardSwipeYOffset:(CGFloat)yOffset;
-(void)hideCardDetail;
-(void)showCardDetail;
-(void)showNextCard;
-(void)showPrevCard;
-(void)likeClickForPropertyObj:(PFObject *)propertyObj;
-(void)findLikeStatusForPropertyObj:(PFObject *)propertyObj;
-(void)bookButtonClickForPropertyObj:(PFObject *)propertyObj;
-(void)messageButtonClickForPropertyObj:(PFObject *)propertyObj;

-(void)requestGetPhotosForPropertyObj:(PFObject *)propertyObj;

-(void)housingLayoutButtonClickAtIndex:(NSInteger)index forPropertyObj:(PFObject *)propertyObj;

@end
