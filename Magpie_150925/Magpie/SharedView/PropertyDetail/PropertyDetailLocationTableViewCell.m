//
//  PropertyDetailLocationTableViewCell.m
//  Easyswap
//
//  Created by minh thao nguyen on 12/21/14.
//  Copyright (c) 2014 Easyswap Inc. All rights reserved.
//

#import "PropertyDetailLocationTableViewCell.h"
#import "Property.h"
#import <MapKit/MapKit.h>
#import <MapKit/MKMapSnapshotter.h>
#import <MapKit/MKMapSnapshotOptions.h>
#import "FontColor.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface PropertyDetailLocationTableViewCell()
@property (nonatomic, assign) CGFloat viewWidth;
@property (nonatomic, strong) PFGeoPoint *coordinate;
@property (nonatomic, strong) UIView *shadowView;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIImageView *mapView;
@property (nonatomic, strong) UIImageView *locationIcon;
@property (nonatomic, strong) UILabel *locationAddress;

@property (nonatomic, strong) MKMapSnapshotOptions *snapOptions;
@property (nonatomic, assign) BOOL mapShown;
@end

@implementation PropertyDetailLocationTableViewCell
#pragma mark - initiation
/**
 * Lazily init the shadow view
 * @return UIView
 */
-(UIView *)shadowView {
    if (_shadowView == nil) {
        _shadowView = [[UIView alloc] initWithFrame:CGRectMake(20, 20, self.viewWidth - 40, 0.7 * self.viewWidth)];
        _shadowView.backgroundColor = [UIColor whiteColor];
        
        [_shadowView.layer setCornerRadius:20];
        [_shadowView.layer setMasksToBounds:NO];
        [_shadowView.layer setShadowColor:[[UIColor blackColor] CGColor]];
        [_shadowView.layer setShadowRadius:2];
        [_shadowView.layer setShadowOffset:CGSizeMake(0, 2)];
        [_shadowView.layer setShadowOpacity:0.1f];
    }
    return _shadowView;
}

/**
 * Lazily init the container view
 * @return UIView
 */
-(UIView *)containerView {
    if (_containerView == nil) {
        _containerView = [[UIView alloc] initWithFrame:CGRectMake(20, 20, self.viewWidth - 40, 0.7 * self.viewWidth)];
        [_containerView.layer setCornerRadius:20];
        [_containerView.layer setMasksToBounds:YES];
        _containerView.clipsToBounds = YES;
    }
    return _containerView;
}

/**
 * Lazily init the map image view
 * @return UIImageView
 */
-(UIImageView *)mapView {
    if (_mapView == nil) {
        _mapView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.viewWidth - 40, 0.52 * self.viewWidth)];
        _mapView.backgroundColor = [FontColor defaultBackgroundColor];
        _mapView.contentMode = UIViewContentModeScaleAspectFill;
        _mapView.clipsToBounds = YES;
    }
    return _mapView;
}

/**
 * Lazily init the location icon
 * @return UIImageView
 */
-(UIImageView *)locationIcon {
    if (_locationIcon == nil) {
        _locationIcon = [[UIImageView alloc] initWithFrame:CGRectMake(15, 0.52 * self.viewWidth + 17, 0.67 * (0.18 * self.viewWidth - 40) , 0.18 * self.viewWidth - 40)];
        _locationIcon.contentMode = UIViewContentModeScaleAspectFit;
        _locationIcon.image = [UIImage imageNamed:@"PropertyLocationIcon"];
    }
    return _locationIcon;
}

/**
 * Lazily init the location address
 * @return UILabel
 */
-(UILabel *)locationAddress {
    if (_locationAddress == nil) {
        CGFloat xOrigin = 30 + 0.67 * (0.18 * self.viewWidth - 40);
        _locationAddress= [[UILabel alloc] initWithFrame:CGRectMake(xOrigin, 0.52 * self.viewWidth, self.viewWidth - 40 - xOrigin, 0.17 * self.viewWidth)];
        _locationAddress.textColor = [FontColor descriptionColor];
        _locationAddress.font = [UIFont fontWithName:@"AvenirNext-Regular" size:14];
    }
    return _locationAddress;
}

/**
 * Lazily init the snapshot options for the map
 * @return MKMapSnapshotOptions
 */
-(MKMapSnapshotOptions *)snapOptions {
    if (_snapOptions == nil) {
        _snapOptions = [[MKMapSnapshotOptions alloc] init];
        _snapOptions.scale = [UIScreen mainScreen].scale;
        _snapOptions.size = CGSizeMake(self.viewWidth - 40, 0.52 * self.viewWidth);
        _snapOptions.showsBuildings = NO;
        _snapOptions.showsPointsOfInterest = NO;
    }
    return _snapOptions;
}

#pragma mark - public methods
-(id)init {
    self = [super init];
    if (self) {
        self.viewWidth = [[UIScreen mainScreen] bounds].size.width;
        [self.contentView addSubview:[self shadowView]];
        [self.contentView addSubview:[self containerView]];
        [self.containerView addSubview:[self mapView]];
        [self.containerView addSubview:[self locationIcon]];
        [self.containerView addSubview:[self locationAddress]];
    }
    return self;
}

/**
 * Set the property object, from that display the place's location
 * @param PFObject
 */
-(void)setPropertyObject:(PFObject *)propertyObj {
    self.mapShown = NO;
    self.mapView.image = [FontColor imageWithColor:[FontColor defaultBackgroundColor]];
    self.locationAddress.text = propertyObj[@"location"] ? propertyObj[@"location"] : @"";
    
    self.coordinate = propertyObj[@"coordinate"];
    [self showMap];
//    CLLocationCoordinate2D propertyCoordinate = CLLocationCoordinate2DMake(self.coordinate.latitude, self.coordinate.longitude);
//    [self snapOptions].region = MKCoordinateRegionMakeWithDistance(propertyCoordinate, 8000, 4000);
//    MKMapSnapshotter *snapshotter = [[MKMapSnapshotter alloc] initWithOptions:self.snapOptions];
//    [snapshotter startWithCompletionHandler:^(MKMapSnapshot *snapshot, NSError *error) {
//        self.mapShown = YES;
//        self.mapView.image = snapshot.image;
//    }];
    
//    [self performSelector:@selector(showMap) withObject:nil afterDelay:1];
}

/**
 * Show the map when snapshotter fail to retreive the map
 */
-(void)showMap {
    if (!self.mapShown) {
        NSString *staticMapUrl = [NSString stringWithFormat:@"http://maps.google.com/maps/api/staticmap?markers=color:red|%f,%f&zoom=12&size=%dx%d&sensor=true", self.coordinate.latitude, self.coordinate.longitude, (int)((self.viewWidth - 40) * [UIScreen mainScreen].scale), (int)((0.52 * self.viewWidth) * [UIScreen mainScreen].scale)];
        NSURL *mapUrl = [NSURL URLWithString:[staticMapUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        [self.mapView setImageWithURL:mapUrl];
    }
}

-(CGFloat)viewHeight {
    return 20 + 0.7 * self.viewWidth + 60;
}



@end
