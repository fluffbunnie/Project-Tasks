//
//  SettingViewController.m
//  Magpie
//
//  Created by minh thao nguyen on 5/30/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import "SettingViewController.h"
#import "FontColor.h"
#import "TermsOfServiceViewController.h"
#import "PrivacyPolicyViewController.h"
#import "FAQViewController.h"
#import "AboutViewController.h"
#import "Mixpanel.h"
#import "HowItWorkViewController.h"
#import "Device.h"

static NSString * VIEW_TITLE = @"Settings";
static NSString * NAVIGATION_BAR_BACK_ICON_NAME = @"NavigationBarBackIconRed";
static NSString * APP_VERSION = @"Copyright © 2015 Magpie Labs\nVersion %@";

@interface SettingViewController ()
@property (nonatomic, assign) CGFloat screenWidth;
@property (nonatomic, assign) CGFloat screenHeight;

@property (nonatomic, strong) UIBarButtonItem *backButton;
@property (nonatomic, strong) UITableView *settingItemsTable;
@property (nonatomic, strong) UILabel *versionLabel;
@end

@implementation SettingViewController
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
 * Lazily init the setting items table
 * @return UITable
 */
-(UITableView *)settingItemsTable {
    if (_settingItemsTable == nil) {
        _settingItemsTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.screenWidth, self.screenHeight)];
        _settingItemsTable.backgroundColor = [FontColor tableSeparatorColor];
        _settingItemsTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        _settingItemsTable.dataSource = self;
        _settingItemsTable.delegate = self;
    }
    return _settingItemsTable;
}

/**
 * Lazily init the version's label
 * @return UILabel
 */
-(UILabel *)versionLabel {
    if (_versionLabel == nil) {
        _versionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.screenHeight - 60, self.screenWidth, 50)];
        _versionLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:12];
        _versionLabel.textColor = [FontColor descriptionColor];
        _versionLabel.textAlignment = NSTextAlignmentCenter;
        _versionLabel.numberOfLines = 0;
        _versionLabel.text = [NSString stringWithFormat:APP_VERSION, [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
    }
    return _versionLabel;
}

#pragma mark - public method
-(void)viewDidLoad {
    [super viewDidLoad];
    self.title = VIEW_TITLE;
    self.screenWidth = [[UIScreen mainScreen] bounds].size.width;
    self.screenHeight = [[UIScreen mainScreen] bounds].size.height;
    self.view.backgroundColor = [FontColor tableSeparatorColor];
    
    self.navigationItem.leftBarButtonItem = [self backButton];
    [self.view addSubview:[self settingItemsTable]];
    [self.view addSubview:[self versionLabel]];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarHidden = NO;
    [self.navigationController setNavigationBarHidden:NO animated:false];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

-(void)goBack {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - table view delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    cell.contentView.backgroundColor = [UIColor whiteColor];
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, self.screenWidth - 100, 50)];
    title.font = [UIFont fontWithName:@"AvenirNext-Regular" size:15];
    title.textColor = [FontColor descriptionColor];
    [cell addSubview:title];
    
    //also set the arrow
    UIImageView *editableArrow = [[UIImageView alloc] initWithFrame:CGRectMake(self.screenWidth - 28, 0, 8, 50)];
    editableArrow.contentMode = UIViewContentModeScaleAspectFit;
    editableArrow.image = [UIImage imageNamed:@"ProfilingEditableArrowIcon"];
    [cell.contentView addSubview:editableArrow];
    
    //add separator
    UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(5, 49, self.screenWidth - 10, 1)];
    separator.backgroundColor = [FontColor tableSeparatorColor];
    [cell.contentView addSubview:separator];
    
    //if (indexPath.row == 0) title.text = @"About";
    
    if (indexPath.row == 0) title.text = @"Privacy Policy";
    if (indexPath.row == 1) title.text = @"Terms of Service";
    if (indexPath.row == 2) title.text = @"How It Works";
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    if (indexPath.row == 0) {
//        AboutViewController *aboutViewController = [[AboutViewController alloc] init];
//        [self.navigationController pushViewController:aboutViewController animated:YES];
//    } else
//    if (indexPath.row == 0) {
//        [[Mixpanel sharedInstance] track:@"Setting - FAQ Click"];
//        HowItWorkViewController *howItWorkViewController = [[HowItWorkViewController alloc] init];
//        howItWorkViewController.capturedBackground = [Device captureDeviceImage:self.view];
//        [self.navigationController pushViewController:howItWorkViewController animated:NO];
//        FAQViewController *faqViewController = [[FAQViewController alloc] init];
//        [self.navigationController pushViewController:faqViewController animated:YES];
//    } else
    if (indexPath.row == 0) {
        [[Mixpanel sharedInstance] track:@"Setting - Privacy Policy Click"];
        PrivacyPolicyViewController *privacyPolicyViewController = [[PrivacyPolicyViewController alloc] init];
        [self.navigationController pushViewController:privacyPolicyViewController animated:YES];
    } else if (indexPath.row == 1) {
        [[Mixpanel sharedInstance] track:@"Setting - Terms Click"];
        TermsOfServiceViewController *termsOfServiceViewController = [[TermsOfServiceViewController alloc] init];
        [self.navigationController pushViewController:termsOfServiceViewController animated:YES];
    } else if (indexPath.row == 2) {
        [[Mixpanel sharedInstance] track:@"Setting - How it Work Click"];
        HowItWorkViewController *howItWorkViewController = [[HowItWorkViewController alloc] init];
        howItWorkViewController.capturedBackground = [Device captureDeviceImage:self.view];
        [self.navigationController pushViewController:howItWorkViewController animated:NO];
        
//        [[Mixpanel sharedInstance] track:@"Setting - FAQ Click"];
//        FAQViewController *faqViewController = [[FAQViewController alloc] init];
//        [self.navigationController pushViewController:faqViewController animated:YES];
    }
}


@end
