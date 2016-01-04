//
//  TripPlaceSelectTableViewController.m
//  Magpie
//
//  Created by minh thao nguyen on 5/27/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import "TripPlaceSelectTableViewController.h"
#import "FontColor.h"
#import "TripPlaceTableViewCell.h"
#import "ParseConstant.h"
#import "TripDetailViewController.h"

static NSString * CELL_IDENTIFIER = @"placeCell";
static NSString * VIEW_TITLE = @"Pick a place";
static NSString * NAVIGATION_BAR_BACK_ICON_NAME = @"NavigationBarBackIconRed";

@interface TripPlaceSelectTableViewController ()
@property (nonatomic, assign) CGFloat screenWidth;
@property (nonatomic, strong) NSArray *propertiesObj;
@property (nonatomic, strong) UIBarButtonItem *backButton;
@property (nonatomic, strong) UIImageView *loadingView;
@end

@implementation TripPlaceSelectTableViewController
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
 * Lazily init the loading view when the table view is refreshed
 * @return UIImageView
 */
-(UIImageView *)loadingView {
    if (_loadingView == nil) {
        _loadingView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.screenWidth, 40)];
        _loadingView.contentMode = UIViewContentModeScaleAspectFit;
        _loadingView.backgroundColor = [FontColor tableSeparatorColor];
        _loadingView.image = [UIImage animatedImageNamed:@"LoadingDark" duration:0.7];
    }
    return _loadingView;
}

#pragma mark - public method
- (void)viewDidLoad {
    [super viewDidLoad];
    self.propertiesObj = [[NSArray alloc] init];
    self.screenWidth = [UIScreen mainScreen].bounds.size.width;
    self.view.backgroundColor = [FontColor tableSeparatorColor];
    self.title = VIEW_TITLE;
    self.navigationItem.leftBarButtonItem = [self backButton];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:TripPlaceTableViewCell.class forCellReuseIdentifier:CELL_IDENTIFIER];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarHidden = NO;
    [self.navigationController setNavigationBarHidden:NO animated:false];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
    self.tableView.tableHeaderView = [self loadingView];
    PFQuery *propertyQuery = [PFQuery queryWithClassName:@"Property"];
    [propertyQuery whereKey:@"owner" equalTo:self.userObj];
    [propertyQuery whereKey:@"state" notEqualTo:PROPERTY_APPROVAL_STATE_PRIVATE];
    [propertyQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        self.tableView.tableHeaderView = nil;
        if (objects.count > 0) self.propertiesObj = objects;
        [self.tableView reloadData];
    }];
}

#pragma mark - UI gesture
/**
 * Go back to the previous screen
 */
-(void)goBack {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.propertiesObj.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 221;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TripPlaceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER forIndexPath:indexPath];
    [cell setPropertyObj:self.propertiesObj[indexPath.row]];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PFObject *propertyObj = self.propertiesObj[indexPath.row];
    NSInteger currentViewControllerIndex = [self.navigationController.viewControllers indexOfObject:self];
    TripDetailViewController *tripDetailViewController = [self.navigationController.viewControllers objectAtIndex:currentViewControllerIndex-1];
    [tripDetailViewController setNewPropertyObj:propertyObj];
    
    [self.navigationController popViewControllerAnimated:YES];
}



@end
