//
//  MyPlaceAmenityViewController.m
//  Magpie
//
//  Created by minh thao nguyen on 5/25/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import "MyPlaceAmenityViewController.h"
#import "PhotoButton.h"
#import "HousingLayoutView.h"
#import "MyPlaceAmenitySectionView.h"

static NSString * NAVIGATION_BAR_BACK_ICON_NAME = @"NavigationBarBackIconRed";
static NSString * NAVIGATION_BAR_TITLE = @"Amenities checklist";

@interface MyPlaceAmenityViewController ()
@property (nonatomic, assign) CGFloat screenWidth;
@property (nonatomic, assign) CGFloat screenHeight;
@property (nonatomic, assign) CGFloat buttonSize;

@property (nonatomic, strong) UIBarButtonItem *backButton;
@property (nonatomic, strong) UIScrollView *containerView;

@property (nonatomic, strong) MyPlaceAmenitySectionView *generalSection;
@property (nonatomic, strong) MyPlaceAmenitySectionView *bedroomSection;
@property (nonatomic, strong) MyPlaceAmenitySectionView *bathroomSection;
@property (nonatomic, strong) MyPlaceAmenitySectionView *livingroomSection;
@property (nonatomic, strong) MyPlaceAmenitySectionView *kitchenSection;

@property (nonatomic, strong) PhotoButton *generalButton;
@property (nonatomic, strong) PhotoButton *bedroomButton;
@property (nonatomic, strong) PhotoButton *bathroomButton;
@property (nonatomic, strong) PhotoButton *livingroomButton;
@property (nonatomic, strong) PhotoButton *kitchenButton;
@end

@implementation MyPlaceAmenityViewController
#pragma mark - initiation
/**
 * Lazily init the back button item
 * @return UIBarButtonItem
 */
-(UIBarButtonItem *)backButton {
    if (_backButton == nil) {
        _backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:NAVIGATION_BAR_BACK_ICON_NAME]
                                                       style:UIBarButtonItemStyleBordered
                                                      target:self
                                                      action:@selector(goBack)];
    }
    return _backButton;
}

/**
 * Lazily init the content's scroll view
 * @return UIScrollView
 */
-(UIScrollView *)containerView {
    if (_containerView == nil) {
        _containerView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.screenWidth, self.screenHeight)];
        _containerView.contentSize = CGSizeMake(5 * self.screenWidth, self.screenHeight - 64);
        _containerView.scrollEnabled = YES;
        _containerView.pagingEnabled = YES;
        _containerView.showsHorizontalScrollIndicator = NO;
        _containerView.showsVerticalScrollIndicator = NO;
        _containerView.delegate = self;
        [_containerView layoutIfNeeded];
        _containerView.tag = 10;
    }
    return _containerView;
}

/**
 * Lazily init the general's section view
 * @return MyPlaceAmenitySectionViewController
 */
-(MyPlaceAmenitySectionView *)generalSection {
    if (_generalSection == nil) {
        _generalSection = [[MyPlaceAmenitySectionView alloc] initWithFrame:CGRectMake(0, 0, self.screenWidth, self.screenHeight - 114 - self.buttonSize)];
        [_generalSection setAmenityObj:self.amenityObj andAmenitySectionType:HOUSING_LAYOUT_HOME_INDEX];
    }
    return _generalSection;
}
/**
 * Lazily init the bedroom section view
 * @return MyPlaceAmenitySectionView
 */
-(MyPlaceAmenitySectionView *)bedroomSection {
    if (_bedroomSection == nil) {
        _bedroomSection = [[MyPlaceAmenitySectionView alloc] initWithFrame:CGRectMake(self.screenWidth, 0, self.screenWidth, self.screenHeight - 114 - self.buttonSize)];
        [_bedroomSection setAmenityObj:self.amenityObj andAmenitySectionType:HOUSING_LAYOUT_BEDROOM_INDEX];
    }
    return _bedroomSection;
}

/**
 * Lazily init the bathroom's section view
 * @return MyPlaceAmenitySectionView
 */
-(MyPlaceAmenitySectionView *)bathroomSection {
    if (_bathroomSection == nil) {
        _bathroomSection = [[MyPlaceAmenitySectionView alloc] initWithFrame:CGRectMake(2 * self.screenWidth, 0, self.screenWidth, self.screenHeight - 114 - self.buttonSize)];
        [_bathroomSection setAmenityObj:self.amenityObj andAmenitySectionType:HOUSING_LAYOUT_BATHROOM_INDEX];
    }
    return _bathroomSection;
}

/**
 * Lazily init the livingroom's section view
 * @return MyPlaceAmenitySectionView
 */
-(MyPlaceAmenitySectionView *)livingroomSection {
    if (_livingroomSection == nil) {
        _livingroomSection = [[MyPlaceAmenitySectionView alloc] initWithFrame:CGRectMake(3 * self.screenWidth, 0, self.screenWidth, self.screenHeight - 114 - self.buttonSize)];
        [_livingroomSection setAmenityObj:self.amenityObj andAmenitySectionType:HOUSING_LAYOUT_LIVINGROOM_INDEX];
    }
    return _livingroomSection;
}

/**
 * Lazily init the kitchen's section view
 * @return MyPlaceAmenitySectionView
 */
-(MyPlaceAmenitySectionView *)kitchenSection {
    if (_kitchenSection == nil) {
        _kitchenSection = [[MyPlaceAmenitySectionView alloc] initWithFrame:CGRectMake(4 * self.screenWidth, 0, self.screenWidth, self.screenHeight - 114 - self.buttonSize)];
        [_kitchenSection setAmenityObj:self.amenityObj andAmenitySectionType:HOUSING_LAYOUT_KITCHEN_INDEX];
    }
    return _kitchenSection;
}

/**
 * Lazily init the general button
 * @return PhotoButton
 */
-(PhotoButton *)generalButton {
    if (_generalButton == nil) {
        _generalButton = [[PhotoButton alloc] initWithNormalImage:[UIImage imageNamed:HOUSING_LAYOUT_HOME_NORMAL_IMG_NAME] highlightImage:[UIImage imageNamed:HOUSING_LAYOUT_HOME_HIGHLIGHT_IMG_NAME] andSelectedImage:[UIImage imageNamed:HOUSING_LAYOUT_HOME_HIGHLIGHT_IMG_NAME] andFrame:CGRectMake(20, self.screenHeight - self.buttonSize - 25, self.buttonSize, self.buttonSize)];
        _generalButton.tag = HOUSING_LAYOUT_HOME_INDEX;
        
        [_generalButton addTarget:self action:@selector(moveToRoom:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _generalButton;
}

/**
 * Lazily init the bedroom button
 * @return PhotoButton
 */
-(PhotoButton *)bedroomButton {
    if (_bedroomButton == nil) {
        _bedroomButton = [[PhotoButton alloc] initWithNormalImage:[UIImage imageNamed:HOUSING_LAYOUT_BEDROOM_NORMAL_IMG_NAME] highlightImage:[UIImage imageNamed:HOUSING_LAYOUT_BEDROOM_HIGHLIGHT_IMG_NAME] andSelectedImage:[UIImage imageNamed:HOUSING_LAYOUT_BEDROOM_HIGHLIGHT_IMG_NAME] andFrame:CGRectMake((self.buttonSize + 10) + 20, self.screenHeight - self.buttonSize - 25, self.buttonSize, self.buttonSize)];
        _bedroomButton.tag = HOUSING_LAYOUT_BEDROOM_INDEX;
        
        [_bedroomButton addTarget:self action:@selector(moveToRoom:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bedroomButton;
}

/**
 * Lazily init the bathroom button
 * @return PhotoButton
 */
-(PhotoButton *)bathroomButton {
    if (_bathroomButton == nil) {
        _bathroomButton = [[PhotoButton alloc] initWithNormalImage:[UIImage imageNamed:HOUSING_LAYOUT_BATHROOM_NORMAL_IMG_NAME] highlightImage:[UIImage imageNamed:HOUSING_LAYOUT_BATHROOM_HIGHLIGHT_IMG_NAME] andSelectedImage:[UIImage imageNamed:HOUSING_LAYOUT_BATHROOM_HIGHLIGHT_IMG_NAME] andFrame:CGRectMake(2 * (self.buttonSize + 10) + 20, self.screenHeight - self.buttonSize - 25, self.buttonSize, self.buttonSize)];
        _bathroomButton.tag = HOUSING_LAYOUT_BATHROOM_INDEX;
        
        [_bathroomButton addTarget:self action:@selector(moveToRoom:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bathroomButton;
}

/**
 * Lazily init the livingroom button
 * @return PhotoButton
 */
-(PhotoButton *)livingroomButton {
    if (_livingroomButton == nil) {
        _livingroomButton = [[PhotoButton alloc] initWithNormalImage:[UIImage imageNamed:HOUSING_LAYOUT_LIVINGROOM_NORMAL_IMG_NAME] highlightImage:[UIImage imageNamed:HOUSING_LAYOUT_LIVINGROOM_HIGHLIGHT_IMG_NAME] andSelectedImage:[UIImage imageNamed:HOUSING_LAYOUT_LIVINGROOM_HIGHLIGHT_IMG_NAME] andFrame:CGRectMake(3 * (self.buttonSize + 10) + 20, self.screenHeight - self.buttonSize - 25, self.buttonSize, self.buttonSize)];
        _livingroomButton.tag = HOUSING_LAYOUT_LIVINGROOM_INDEX;
        
        [_livingroomButton addTarget:self action:@selector(moveToRoom:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _livingroomButton;
}

/**
 * Lazily init the kitchen button
 * @return PhotoButton
 */
-(PhotoButton *)kitchenButton {
    if (_kitchenButton == nil) {
        _kitchenButton = [[PhotoButton alloc] initWithNormalImage:[UIImage imageNamed:HOUSING_LAYOUT_KITCHEN_NORMAL_IMG_NAME] highlightImage:[UIImage imageNamed:HOUSING_LAYOUT_KITCHEN_HIGHLIGHT_IMG_NAME] andSelectedImage:[UIImage imageNamed:HOUSING_LAYOUT_KITCHEN_HIGHLIGHT_IMG_NAME] andFrame:CGRectMake(4 * (self.buttonSize + 10) + 20, self.screenHeight - self.buttonSize - 25, self.buttonSize, self.buttonSize)];
        _kitchenButton.tag = HOUSING_LAYOUT_KITCHEN_INDEX;
        
        [_kitchenButton addTarget:self action:@selector(moveToRoom:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _kitchenButton;
}

#pragma mark - public method
- (void)viewDidLoad {
    [super viewDidLoad];
    self.screenWidth = [[UIScreen mainScreen] bounds].size.width;
    self.screenHeight = [[UIScreen mainScreen] bounds].size.height;
    self.buttonSize = (self.screenWidth - 80) / 5;
    
    self.title = NAVIGATION_BAR_TITLE;
    self.navigationItem.leftBarButtonItem = [self backButton];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:[self containerView]];
    [self.containerView addSubview:[self generalSection]];
    [self.containerView addSubview:[self bedroomSection]];
    [self.containerView addSubview:[self bathroomSection]];
    [self.containerView addSubview:[self livingroomSection]];
    [self.containerView addSubview:[self kitchenSection]];
    
    [self.view addSubview:[self generalButton]];
    [self.view addSubview:[self bedroomButton]];
    [self.view addSubview:[self bathroomButton]];
    [self.view addSubview:[self livingroomButton]];
    [self.view addSubview:[self kitchenButton]];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarHidden = NO;
    [self.navigationController setNavigationBarHidden:NO animated:false];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

#pragma mark - UI gesture
/**
 * Go back to the previous screen
 */
-(void)goBack {
    for (AmenityItem *amenityItem in [self.generalSection getAllAmentityItem]) {
        NSString *amenityId = amenityItem.amenityId;
        NSString *amenityDescriptionId = [NSString stringWithFormat:@"%@Description", amenityId];
        self.amenityObj[amenityId] = [NSNumber numberWithBool:amenityItem.amenityEnabled];
        self.amenityObj[amenityDescriptionId] = amenityItem.amenityDescription;
    }
    
    for (AmenityItem *amenityItem in [self.bedroomSection getAllAmentityItem]) {
        NSString *amenityId = amenityItem.amenityId;
        NSString *amenityDescriptionId = [NSString stringWithFormat:@"%@Description", amenityId];
        self.amenityObj[amenityId] = [NSNumber numberWithBool:amenityItem.amenityEnabled];
        self.amenityObj[amenityDescriptionId] = amenityItem.amenityDescription;
    }
    
    for (AmenityItem *amenityItem in [self.bathroomSection getAllAmentityItem]) {
        NSString *amenityId = amenityItem.amenityId;
        NSString *amenityDescriptionId = [NSString stringWithFormat:@"%@Description", amenityId];
        self.amenityObj[amenityId] = [NSNumber numberWithBool:amenityItem.amenityEnabled];
        self.amenityObj[amenityDescriptionId] = amenityItem.amenityDescription;
    }
    
    for (AmenityItem *amenityItem in [self.livingroomSection getAllAmentityItem]) {
        NSString *amenityId = amenityItem.amenityId;
        NSString *amenityDescriptionId = [NSString stringWithFormat:@"%@Description", amenityId];
        self.amenityObj[amenityId] = [NSNumber numberWithBool:amenityItem.amenityEnabled];
        self.amenityObj[amenityDescriptionId] = amenityItem.amenityDescription;
    }
    
    for (AmenityItem *amenityItem in [self.kitchenSection getAllAmentityItem]) {
        NSString *amenityId = amenityItem.amenityId;
        NSString *amenityDescriptionId = [NSString stringWithFormat:@"%@Description", amenityId];
        self.amenityObj[amenityId] = [NSNumber numberWithBool:amenityItem.amenityEnabled];
        self.amenityObj[amenityDescriptionId] = amenityItem.amenityDescription;
    }
    
    [self.amenityObj saveInBackground];
    
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 * Handle the behavior when user tap on the amenity's section button
 * @param PhotoButton
 */
-(void)moveToRoom:(PhotoButton *)button {
    [self moveToRoomWithIndex:button.tag animated:YES];
}

/**
 * Move to a room with a given index
 * @param NSInteger
 * @param BOOL
 */
-(void)moveToRoomWithIndex:(NSInteger)tag animated:(BOOL)animated{
    if (self.generalButton.tag == tag) [self.generalButton setSelected:YES];
    else [self.generalButton setSelected:NO];
    
    if (self.bedroomButton.tag == tag) [self.bedroomButton setSelected:YES];
    else [self.bedroomButton setSelected:NO];
    
    if (self.bathroomButton.tag == tag) [self.bathroomButton setSelected:YES];
    else [self.bathroomButton setSelected:NO];
    
    if (self.livingroomButton.tag == tag) [self.livingroomButton setSelected:YES];
    else [self.livingroomButton setSelected:NO];
    
    if (self.kitchenButton.tag == tag) [self.kitchenButton setSelected:YES];
    else [self.kitchenButton setSelected:NO];
    
    if (animated) {
        [UIView animateWithDuration:0.25 animations:^{
            self.containerView.contentOffset = CGPointMake(tag * self.screenWidth, -64);
        }];
    } else self.containerView.contentOffset = CGPointMake(tag * self.screenWidth, -64);
}

#pragma mark - scrollview delegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView.tag == 10) {
        [self.generalButton setSelected:NO];
        [self.bedroomButton setSelected:NO];
        [self.bathroomButton setSelected:NO];
        [self.livingroomButton setSelected:NO];
        [self.kitchenButton setSelected:NO];
        
        if ([self getCurrentPage] == self.generalButton.tag) [self.generalButton setSelected:YES];
        if ([self getCurrentPage] == self.bedroomButton.tag) [self.bedroomButton setSelected:YES];
        if ([self getCurrentPage] == self.bathroomButton.tag) [self.bathroomButton setSelected:YES];
        if ([self getCurrentPage] == self.livingroomButton.tag) [self.livingroomButton setSelected:YES];
        if ([self getCurrentPage] == self.kitchenButton.tag) [self.kitchenButton setSelected:YES];
    }
}

-(NSInteger)getCurrentPage {
    return MIN(MAX(self.containerView.contentOffset.x/self.screenWidth, 0), 4);
}


@end
