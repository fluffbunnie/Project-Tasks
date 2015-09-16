//
//  MyUpcomingTripViewController.m
//  Magpie
//
//  Created by minh thao nguyen on 5/6/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import "MyUpcomingTripViewController.h"
#import "FontColor.h"
#import "MyMessageViewController.h"
#import "UserManager.h"
#import "PMCalendar.h"
#import "MyUpcomingTripGuestTableViewCell.h"
#import "MyUpcomingTripHostTableViewCell.h"

static NSString * HOST_CELL_IDENTIFIER = @"hostCell";
static NSString * GUEST_CELL_IDENTIFIER =  @"guestCell";

static NSString * VIEW_TITLE = @"Upcoming Trips";
static NSString * NAVIGATION_BAR_BACK_ICON_NAME = @"NavigationBarBackIconRed";

@interface MyUpcomingTripViewController ()
@property (nonatomic, assign) CGFloat screenWidth;
@property (nonatomic, assign) CGFloat screenHeight;
@property (nonatomic, strong) PFObject *userObj;

@property (nonatomic, strong) NSMutableArray *upcomingTrips;

@property (nonatomic, strong) UIBarButtonItem *backButton;
@property (nonatomic, strong) UIImageView *loadingView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) MyUpcomingTripEmptyView *emptyView;
@end

@implementation MyUpcomingTripViewController

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
 * Lazily init the upcoming trip view
 * @return UITableView
 */
-(UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.screenWidth, self.screenHeight)];
        _tableView.backgroundColor = [FontColor tableSeparatorColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:MyUpcomingTripGuestTableViewCell.class forCellReuseIdentifier:GUEST_CELL_IDENTIFIER];
        [_tableView registerClass:MyUpcomingTripHostTableViewCell.class forCellReuseIdentifier:HOST_CELL_IDENTIFIER];
    }
    return _tableView;
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

/**
 * Lazily init the empty view
 * @return MyUpcomingTripEmptyView
 */
-(MyUpcomingTripEmptyView *)emptyView {
    if (_emptyView == nil) {
        _emptyView = [[MyUpcomingTripEmptyView alloc] initWithFrame:CGRectMake(0, 64, self.screenWidth, self.screenHeight - 64)];
        _emptyView.emptyViewDelegate = self;
    }
    return _emptyView;
}

#pragma mark - public methods
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = VIEW_TITLE;
    self.screenWidth = [[UIScreen mainScreen] bounds].size.width;
    self.screenHeight = [[UIScreen mainScreen] bounds].size.height;
    self.upcomingTrips = [[NSMutableArray alloc] init];
    
    self.view.backgroundColor = [FontColor tableSeparatorColor];
    self.navigationItem.leftBarButtonItem = [self backButton];
    
    [self.view addSubview:[self tableView]];
    [self.view addSubview:[self emptyView]];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarHidden = NO;
    [self.navigationController setNavigationBarHidden:NO animated:false];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
    self.emptyView.hidden = YES;
    self.tableView.tableHeaderView = [self loadingView];
    [[UserManager sharedUserManager] getUserWithCompletionHandler:^(PFObject *userObj) {
        self.userObj = userObj;
        NSString *currentDate = [[[NSDate alloc] init] dateStringWithFormat:@"yyyy-MM-dd"];
        
        PFQuery *query1 = [PFQuery queryWithClassName:@"Trip"];
        [query1 whereKey:@"host" equalTo:userObj];
        
        PFQuery *query2 = [PFQuery queryWithClassName:@"Trip"];
        [query2 whereKey:@"guest" equalTo:userObj];
        
        PFQuery *query = [PFQuery orQueryWithSubqueries:@[query1, query2]];
        [query includeKey:@"host"];
        [query includeKey:@"guest"];
        [query includeKey:@"place"];
        [query includeKey:@"place.owner"];
        [query whereKey:@"approval" equalTo:@"YES"];
        [query whereKey:@"endDate" greaterThanOrEqualTo:currentDate];
        [query orderByAscending:@"startDate"];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            self.tableView.tableHeaderView = nil;
            if (!error && objects.count > 0) {
                self.upcomingTrips = [NSMutableArray arrayWithArray:objects];
                [self.tableView reloadData];
            } else self.emptyView.hidden = NO;
        }];
    }];
}

#pragma mark - table delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.upcomingTrips.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PFObject *tripObj = self.upcomingTrips[indexPath.row];
    if ([self.userObj.objectId isEqual:((PFObject *)tripObj[@"guest"]).objectId]) {
        MyUpcomingTripGuestTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:GUEST_CELL_IDENTIFIER forIndexPath:indexPath];
        [cell setTripObj:tripObj];
        return cell;
    } else {
        MyUpcomingTripHostTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:HOST_CELL_IDENTIFIER forIndexPath:indexPath];
        [cell setTripObj:tripObj];
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    PFObject *tripObj = self.upcomingTrips[indexPath.row];
    if ([self.userObj.objectId isEqual:((PFObject *)tripObj[@"guest"]).objectId]) return 225;
    else return 155;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - button click/delegate
/**
 * Handle the behavior when user click on the back button
 */
-(void)goBack {
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 * Handle the behavior when user click on go to favorite button
 */
-(void)goToMessages {
    MyMessageViewController *myMessageViewController = [[MyMessageViewController alloc] init];
    [self.navigationController pushViewController:myMessageViewController animated:YES];
}

@end
