//
//  MyMessageViewController.m
//  Magpie
//
//  Created by minh thao nguyen on 5/6/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import "MyMessageViewController.h"
#import "FontColor.h"
#import "MyFavoriteViewController.h"
#import "MyMessageTableViewCell.h"
#import "UserManager.h"
#import "ChatViewController.h"
#import "Mixpanel.h"

static NSString * CELL_IDENTIFIER = @"messageCell";

static NSString * VIEW_TITLE = @"Messages";
static NSString * NAVIGATION_BAR_BACK_ICON_NAME = @"NavigationBarBackIconRed";

@interface MyMessageViewController ()
@property (nonatomic, assign) CGFloat screenWidth;
@property (nonatomic, assign) CGFloat screenHeight;
@property (nonatomic, strong) PFObject *userObj;
@property (nonatomic, strong) NSArray *messagesArray;

@property (nonatomic, strong) UIBarButtonItem *backButton;
@property (nonatomic, strong) MyMessageEmptyView *emptyView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIImageView *loadingView;
@end

@implementation MyMessageViewController
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
 * Lazily init the list of messages
 * @return UITableView
 */
-(UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.screenWidth, self.screenHeight)];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor clearColor];
        [_tableView registerClass:MyMessageTableViewCell.class forCellReuseIdentifier:CELL_IDENTIFIER];
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
 * @return MyMessageEmptyView
 */
-(MyMessageEmptyView *)emptyView {
    if (_emptyView == nil) {
        _emptyView = [[MyMessageEmptyView alloc] initWithFrame:CGRectMake(0, 64, self.screenWidth, self.screenHeight - 64)];
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
    self.messagesArray = [[NSArray alloc] init];
    self.view.backgroundColor = [FontColor tableSeparatorColor];
    
    self.navigationItem.leftBarButtonItem = [self backButton];
    [self.view addSubview:[self tableView]];
    
    [[UserManager sharedUserManager] getUserWithCompletionHandler:^(PFObject *userObj) {
        self.userObj = userObj;
        if ([userObj[@"numConversations"] integerValue] == 0) {
            [self.view addSubview:[self emptyView]];
        }
    }];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarHidden = NO;
    [self.navigationController setNavigationBarHidden:NO animated:false];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
    [[UserManager sharedUserManager] getUserWithCompletionHandler:^(PFObject *userObj) {
        self.userObj = userObj;
        if ([userObj[@"numConversations"] integerValue] > 0) {
            self.emptyView.hidden = YES;
            self.tableView.tableHeaderView = [self loadingView];
            self.view.backgroundColor = [UIColor whiteColor];
            PFQuery *query1 = [PFQuery queryWithClassName:@"Conversation"];
            [query1 whereKey:@"user1" equalTo:self.userObj];
            
            PFQuery *query2 = [PFQuery queryWithClassName:@"Conversation"];
            [query2 whereKey:@"user2" equalTo:self.userObj];
            
            PFQuery *query = [PFQuery orQueryWithSubqueries:@[query1, query2]];
            [query includeKey:@"user1"];
            [query includeKey:@"user2"];
            [query includeKey:@"user2Property"];
            [query includeKey:@"user2Property.owner"];
            [query includeKey:@"user2Property.amenity"];
            [query includeKey:@"snippet"];
            [query includeKey:@"snippet.sender"];
            [query includeKey:@"snippet.receiver"];
            [query orderByDescending:@"lastUpdate"];
            [query setLimit:1000];
            
            [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                self.messagesArray = objects;
                self.tableView.tableHeaderView = nil;
                [self.tableView reloadData];
            }];
        }
    }];
}

#pragma mark - table delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.messagesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER];
    if (cell == nil) cell = [[MyMessageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_IDENTIFIER];
    [cell setMessageObj:self.messagesArray[indexPath.row]];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    ChatViewController *chatViewController = [[ChatViewController alloc] init];
    chatViewController.userObj = self.userObj;
    chatViewController.conversationObj = self.messagesArray[indexPath.row];
    [self.navigationController pushViewController:chatViewController animated:YES];
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
-(void)goToFavorites {
    [[Mixpanel sharedInstance] track:@"Message Empty - Favorite Click"];
    MyFavoriteViewController *myFavoriteViewController = [[MyFavoriteViewController alloc] init];
    [self.navigationController pushViewController:myFavoriteViewController animated:YES];
}

@end
