//
//  HousingPlanViewController.m
//  Magpie
//
//  Created by minh thao nguyen on 5/15/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import "HousingPlanViewController.h"
#import "PhotoButton.h"
#import "HousingLayoutView.h"
#import "AmenityDisplayTableViewCell.h"
#import "Amenity.h"
#import "HousingAmenitySectionView.h"

static NSString * CELL_IDENTIFIER = @"amenityCell";

static NSString *DEFAULT_BACKGROUND_IMAGE_LIGHT = @"DefaultBackgroundImageLight";

static NSString *BACK_BUTTON_IMAGE_HIGHLIGHT = @"NavigationBarSwipeViewBackIconHighlight";
static NSString *BACK_BUTTON_IMAGE_NORMAL = @"NavigationBarSwipeViewBackIconNormal";

@interface HousingPlanViewController ()
@property (nonatomic, assign) CGFloat screenWidth;
@property (nonatomic, assign) CGFloat screenHeight;
@property (nonatomic, assign) CGFloat buttonSize;

@property (nonatomic, strong) CAGradientLayer *gradientLayer;

@property (nonatomic, strong) NSMutableArray *amenities;

@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIImageView *backgroundImage;

@property (nonatomic, strong) UIScrollView *containerView;

@property (nonatomic, strong) HousingAmenitySectionView *generalSection;
@property (nonatomic, strong) HousingAmenitySectionView *bedroomSection;
@property (nonatomic, strong) HousingAmenitySectionView *bathroomSection;
@property (nonatomic, strong) HousingAmenitySectionView *livingroomSection;
@property (nonatomic, strong) HousingAmenitySectionView *kitchenSection;

@property (nonatomic, strong) UIImageView *generalIcon;
@property (nonatomic, strong) UIImageView *bedroomIcon;
@property (nonatomic, strong) UIImageView *bathroomIcon;
@property (nonatomic, strong) UIImageView *livingroomIcon;
@property (nonatomic, strong) UIImageView *kitchenIcon;

@property (nonatomic, strong) PhotoButton *generalButton;
@property (nonatomic, strong) PhotoButton *bedroomButton;
@property (nonatomic, strong) PhotoButton *bathroomButton;
@property (nonatomic, strong) PhotoButton *livingroomButton;
@property (nonatomic, strong) PhotoButton *kitchenButton;

@end

@implementation HousingPlanViewController
#pragma mark - initation
/**
 * Lazily init the back button
 * @return UIButton
 */
-(UIButton *)backButton {
    if (_backButton == nil) {
        _backButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 20, 44, 44)];
        [_backButton setImage:[UIImage imageNamed:BACK_BUTTON_IMAGE_NORMAL] forState:UIControlStateNormal];
        [_backButton setImage:[UIImage imageNamed:BACK_BUTTON_IMAGE_HIGHLIGHT] forState:UIControlStateHighlighted];
        
        [_backButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}

/**
 * Lazily init the background image
 * @return UIImageView
 */
-(UIImageView *)backgroundImage {
    if (_backgroundImage == nil) {
        _backgroundImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.screenWidth, self.screenHeight)];
        _backgroundImage.contentMode = UIViewContentModeScaleAspectFill;
        _backgroundImage.image = [UIImage imageNamed:DEFAULT_BACKGROUND_IMAGE_LIGHT];
    }
    return _backgroundImage;
}

/**
 * Lazily init the content's scroll view
 * @return UIScrollView
 */
-(UIScrollView *)containerView {
    if (_containerView == nil) {
        _containerView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.screenWidth, self.screenHeight)];
        _containerView.contentSize = CGSizeMake(5 * self.screenWidth, self.screenHeight);
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
 * Lazily init the top gradient layer
 * @return Gradient
 */
-(CAGradientLayer *)gradientLayer {
    if (_gradientLayer == nil) {
        _gradientLayer = [CAGradientLayer layer];
        _gradientLayer.frame = CGRectMake(0, 0, self.screenWidth - 40, 50);
        _gradientLayer.colors = [NSArray arrayWithObjects:(id)[UIColor whiteColor].CGColor, (id)[UIColor whiteColor].CGColor, (id)[UIColor colorWithWhite:1 alpha:0].CGColor, nil];
    }
    return _gradientLayer;
}

/**
 * Lazily init the general's section view
 * @return HousingAmentitySectionView
 */
-(HousingAmenitySectionView *)generalSection {
    if (_generalSection == nil) {
        _generalSection = [[HousingAmenitySectionView alloc] initWithFrame:CGRectMake(20, 100, self.screenWidth - 40, self.screenHeight - 150 - self.buttonSize)];
    }
    return _generalSection;
}
/**
 * Lazily init the bedroom section view
 * @return HousingAmentitySectionView
 */
-(HousingAmenitySectionView *)bedroomSection {
    if (_bedroomSection == nil) {
        _bedroomSection = [[HousingAmenitySectionView alloc] initWithFrame:CGRectMake(self.screenWidth + 20, 100, self.screenWidth - 40, self.screenHeight - 150 - self.buttonSize)];
    }
    return _bedroomSection;
}

/**
 * Lazily init the bathroom's section view
 * @return HousingAmentitySectionView
 */
-(HousingAmenitySectionView *)bathroomSection {
    if (_bathroomSection == nil) {
        _bathroomSection = [[HousingAmenitySectionView alloc] initWithFrame:CGRectMake(2 * self.screenWidth + 20, 100, self.screenWidth - 40, self.screenHeight - 150 - self.buttonSize)];
    }
    return _bathroomSection;
}

/**
 * Lazily init the livingroom's section view
 * @return HousingAmentitySectionView
 */
-(HousingAmenitySectionView *)livingroomSection {
    if (_livingroomSection == nil) {
        _livingroomSection = [[HousingAmenitySectionView alloc] initWithFrame:CGRectMake(3 * self.screenWidth + 20, 100, self.screenWidth - 40, self.screenHeight - 150 - self.buttonSize)];
    }
    return _livingroomSection;
}

/**
 * Lazily init the kitchen's section view
 * @return HousingAmentitySectionView
 */
-(HousingAmenitySectionView *)kitchenSection {
    if (_kitchenSection == nil) {
        _kitchenSection = [[HousingAmenitySectionView alloc] initWithFrame:CGRectMake(4 * self.screenWidth + 20, 100, self.screenWidth - 40, self.screenHeight - 150 - self.buttonSize)];
    }
    return _kitchenSection;
}

/**
 * Lazily init the general icon
 * @return UIImageView
 */
-(UIImageView *)generalIcon {
    if (_generalIcon == nil) {
        _generalIcon = [[UIImageView alloc] initWithFrame:CGRectMake((self.screenWidth - 80)/2, 60, 80, 80)];
        _generalIcon.contentMode = UIViewContentModeScaleAspectFit;
        _generalIcon.image = [UIImage imageNamed:HOUSING_LAYOUT_HOME_HIGHLIGHT_IMG_NAME];
    }
    return _generalIcon;
}

/**
 * Lazily init the bedroom icon
 * @return UIImageView
 */
-(UIImageView *)bedroomIcon {
    if (_bedroomIcon == nil) {
        _bedroomIcon = [[UIImageView alloc] initWithFrame:CGRectMake(self.screenWidth + (self.screenWidth - 80)/2, 60, 80, 80)];
        _bedroomIcon.contentMode = UIViewContentModeScaleAspectFit;
        _bedroomIcon.image = [UIImage imageNamed:HOUSING_LAYOUT_BEDROOM_HIGHLIGHT_IMG_NAME];
    }
    return _bedroomIcon;
}

/**
 * Lazily init the bathroom icon
 * @return UIImageView
 */
-(UIImageView *)bathroomIcon {
    if (_bathroomIcon == nil) {
        _bathroomIcon = [[UIImageView alloc] initWithFrame:CGRectMake(2 * self.screenWidth + (self.screenWidth - 80)/2, 60, 80, 80)];
        _bathroomIcon.contentMode = UIViewContentModeScaleAspectFit;
        _bathroomIcon.image = [UIImage imageNamed:HOUSING_LAYOUT_BATHROOM_HIGHLIGHT_IMG_NAME];
    }
    return _bathroomIcon;
}

/**
 * Lazily init the livingroom icon
 * @return UIImageView
 */
-(UIImageView *)livingroomIcon {
    if (_livingroomIcon == nil) {
        _livingroomIcon = [[UIImageView alloc] initWithFrame:CGRectMake(3 * self.screenWidth + (self.screenWidth - 80)/2, 60, 80, 80)];
        _livingroomIcon.contentMode = UIViewContentModeScaleAspectFit;
        _livingroomIcon.image = [UIImage imageNamed:HOUSING_LAYOUT_LIVINGROOM_HIGHLIGHT_IMG_NAME];
    }
    return _livingroomIcon;
}

/**
 * Lazily init the kitchen icon
 * @return UIImageView
 */
-(UIImageView *)kitchenIcon {
    if (_kitchenIcon == nil) {
        _kitchenIcon = [[UIImageView alloc] initWithFrame:CGRectMake(4 * self.screenWidth + (self.screenWidth - 80)/2, 60, 80, 80)];
        _kitchenIcon.contentMode = UIViewContentModeScaleAspectFit;
        _kitchenIcon.image = [UIImage imageNamed:HOUSING_LAYOUT_KITCHEN_HIGHLIGHT_IMG_NAME];
    }
    return _kitchenIcon;
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
    
    self.amenities = [[NSMutableArray alloc] initWithObjects:
                      [Amenity getGeneralActiveAmenities:self.amenityObj],
                      [Amenity getBedroomActiveAmenities:self.amenityObj],
                      [Amenity getBathroomActiveAmenities:self.amenityObj],
                      [Amenity getLivingroomActiveAmenities:self.amenityObj],
                      [Amenity getKitchenActiveAmenities:self.amenityObj], nil];
    
    [self.view addSubview:[self backgroundImage]];
    [self.view addSubview:[self containerView]];
    
    [self.containerView addSubview:[self generalSection]];
    [self.containerView addSubview:[self generalIcon]];
    
    [self.containerView addSubview:[self bedroomSection]];
    [self.containerView addSubview:[self bedroomIcon]];
    
    [self.containerView addSubview:[self bathroomSection]];
    [self.containerView addSubview:[self bathroomIcon]];
    
    [self.containerView addSubview:[self livingroomSection]];
    [self.containerView addSubview:[self livingroomIcon]];
    
    [self.containerView addSubview:[self kitchenSection]];
    [self.containerView addSubview:[self kitchenIcon]];
    
    [self.view addSubview:[self generalButton]];
    [self.view addSubview:[self bedroomButton]];
    [self.view addSubview:[self bathroomButton]];
    [self.view addSubview:[self livingroomButton]];
    [self.view addSubview:[self kitchenButton]];
    
    [self.view addSubview:[self backButton]];
    
    [self.generalSection setAmenities:self.amenities[0]];
    [self.bedroomSection setAmenities:self.amenities[1]];
    [self.bathroomSection setAmenities:self.amenities[2]];
    [self.livingroomSection setAmenities:self.amenities[3]];
    [self.kitchenSection setAmenities:self.amenities[4]];
    
    [self moveToRoomWithIndex:self.currentPageIndex animated:NO];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarHidden = YES;
    [self.navigationController setNavigationBarHidden:YES animated:false];
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

#pragma mark - ui action
/**
 * Go back to the previous screen
 */
-(void)goBack {
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
            self.containerView.contentOffset = CGPointMake(tag * self.screenWidth, 0);
        }];
    } else self.containerView.contentOffset = CGPointMake(tag * self.screenWidth, 0);
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
