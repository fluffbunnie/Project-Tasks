//
//  MyPlaceListViewController.m
//  Magpie
//
//  Created by minh thao nguyen on 5/6/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import "MyPlaceListViewController.h"
#import "FontColor.h"
#import "UserManager.h"
#import "ImportAirbnbViewController.h"
#import "Device.h"
#import "UnderLineButton.h"
#import "MyPlaceListTableViewCell.h"
#import "MyPlaceDetailViewController.h"
#import "Amenity.h"
#import "ParseConstant.h"
#import "Mixpanel.h"

static NSString * CELL_IDENTIFIER = @"myPlaceCell";
static NSString * VIEW_TITLE = @"Your Place";
static NSString * NAVIGATION_BAR_BACK_ICON_NAME = @"NavigationBarBackIconRed";

static NSString * TABLE_VIEW_FOOTER_BUTTON_TEXT = @"Create another place";

@interface MyPlaceListViewController ()
@property (nonatomic, assign) CGFloat screenWidth;
@property (nonatomic, assign) CGFloat screenHeight;

@property (nonatomic, strong) NSArray *places;
@property (nonatomic, strong) UIBarButtonItem *backButton;
@property (nonatomic, strong) UITableView *myPlacesTable;

@property (nonatomic, strong) UnderLineButton *createNewPlaceButton;
@end

@implementation MyPlaceListViewController
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
 * Lazily init the my places table view
 * @return UITableView
 */
-(UITableView *)myPlacesTable {
    if (_myPlacesTable == nil) {
        _myPlacesTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.screenWidth, self.screenHeight)];
        _myPlacesTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        _myPlacesTable.dataSource = self;
        _myPlacesTable.delegate = self;
        _myPlacesTable.backgroundColor = [UIColor clearColor];
        _myPlacesTable.tableFooterView = [self createNewPlaceButton];
        [_myPlacesTable registerClass:MyPlaceListTableViewCell.class forCellReuseIdentifier:CELL_IDENTIFIER];
    }
    return _myPlacesTable;
}

/**
 * Lazily init the create new place button
 * @return UnderlineButton
 */
-(UnderLineButton *)createNewPlaceButton {
    if (_createNewPlaceButton == nil) {
        _createNewPlaceButton = [UnderLineButton createButton];
        _createNewPlaceButton.frame = CGRectMake(0, 0, self.screenWidth, 40);
        [_createNewPlaceButton setTitle:TABLE_VIEW_FOOTER_BUTTON_TEXT forState:UIControlStateNormal];
        [_createNewPlaceButton addTarget:self action:@selector(createNewPlace) forControlEvents:UIControlEventTouchUpInside];
    }
    return _createNewPlaceButton;
}

#pragma mark - public methods
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = VIEW_TITLE;
    self.screenWidth = [[UIScreen mainScreen] bounds].size.width;
    self.screenHeight = [[UIScreen mainScreen] bounds].size.height;
    self.view.backgroundColor = [FontColor tableSeparatorColor];
    
    self.navigationItem.leftBarButtonItem = [self backButton];
    self.places = [[NSArray alloc] init];
    [self.view addSubview:[self myPlacesTable]];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarHidden = NO;
    [self.navigationController setNavigationBarHidden:NO animated:false];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
    [[UserManager sharedUserManager] getPropertiesWithCompletionHandler:^(NSArray *properties) {
        self.places = properties;
        [self.myPlacesTable reloadData];
    }];
}

#pragma mark - table view delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.places.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyPlaceListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER];
    if (cell == nil) cell = [[MyPlaceListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_IDENTIFIER];
    
    [cell setPlace:self.places[indexPath.row]];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 215;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MyPlaceDetailViewController *detailViewController = [[MyPlaceDetailViewController alloc] init];
    detailViewController.propertyObj = self.places[indexPath.row];
    [self.navigationController pushViewController:detailViewController animated:YES];
}

#pragma mark - button click/delegate
/**
 * Handle the behavior when user click on the back button
 */
-(void)goBack {
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 * Handle the action when user wish to create the listing manually
 */
-(void)createNewPlace {
    self.view.userInteractionEnabled = NO;
    PFObject *amenity = [Amenity newAmenityObj];
    [amenity saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        PFObject *newProperty = [PFObject objectWithClassName:@"Property"];
        newProperty[@"owner"] = self.userObj;
        newProperty[@"state"] = PROPERTY_APPROVAL_STATE_PRIVATE;
        newProperty[@"amenity"] = amenity;
        
        MyPlaceDetailViewController *detailViewController = [[MyPlaceDetailViewController alloc] init];
        detailViewController.propertyObj = newProperty;
        [self.navigationController pushViewController:detailViewController animated:YES];
        Mixpanel *mixpanel = [Mixpanel sharedInstance];
        [mixpanel track:@"Create New Place Click"];
    }];
}

@end
