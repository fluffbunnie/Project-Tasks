//
//  HomePageView.m
//  Magpie
//
//  Created by minh thao nguyen on 4/21/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import "HomePageView.h"
#import "HomePageFirstSectionHeader.h"
#import "HomePageSecondSectionHeader.h"
#import "HomePageFirstSectionTableViewCell.h"
#import "AppDelegate.h"

static NSString * CELL_IDENTIFIER = @"deckCell";

static NSString * HOME_NAVIGATION_MENU_ICON_WHITE = @"NavigationBarHamburgerIconWhite";
static NSString * HOME_NAVIGATION_MENU_ICON_WHITE_WITH_RED_DOT = @"NavigationBarHamburgerIconWhiteWithRedDot";


static NSString * HEADER_IMAGE = @"HomePageHeaderImage";
static NSString * FIRST_SECTION_FIRST_IMAGE = @"HomePageFirstImage";
static NSString * FIRST_SECTION_SECOND_IMAGE = @"HomePageSecondImage";
static NSString * FIRST_SECTION_THIRD_IMAGE = @"HomePageThirdImage";
static NSString * SECOND_SECTION_FIRST_IMAGE = @"HomePageNewUserImage";

static NSString * FIRST_SECTION_FIRST_ITEM_TITLE = @"San Francisco Fog";
static NSString * FIRST_SECTION_SECOND_ITEM_TITLE = @"New York Skyline";
static NSString * FIRST_SECTION_THIRD_ITEM_TITLE = @"Miami Sand";
static NSString * SECOND_SECTION_FIRST_ITEM_TITLE = @"Our Newest Places";

@interface HomePageView()

@property (nonatomic, assign) CGFloat contentWidth;
@property (nonatomic, assign) CGFloat contentHeight;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIImageView *headerView;
@property (nonatomic, strong) UIView *emptyHeaderView;

@property (nonatomic, strong) HomePageFirstSectionHeader *sectionOneHeader;
@property (nonatomic, strong) HomePageSecondSectionHeader *sectionTwoHeader;

@property (nonatomic, strong) UIButton *hamburgerButton;

@end

@implementation HomePageView
#pragma mark - initiation
/**
 * Lazily init the header view
 * @return UIImageView
 */
-(UIImageView *)headerView {
    if (_headerView == nil) {
        _headerView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.contentWidth, 300)];
        _headerView.contentMode = UIViewContentModeScaleAspectFill;
        
        _headerView.image = [UIImage imageNamed:HEADER_IMAGE];
    }
    return _headerView;
}

/**
 * Lazily init the table view
 * @return UITableView
 */
-(UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.contentWidth, self.contentHeight) style:UITableViewStyleGrouped];
        _tableView.separatorStyle =  UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        [_tableView registerClass:HomePageFirstSectionTableViewCell.class forCellReuseIdentifier:CELL_IDENTIFIER];
    }
    return _tableView;
}

/**
 * Lazily init the empty header view
 * @return UIView
 */
-(UIView *)emptyHeaderView {
    if (_emptyHeaderView == nil) {
        _emptyHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.contentWidth, 300)];
        _emptyHeaderView.backgroundColor = [UIColor clearColor];
        _emptyHeaderView.userInteractionEnabled = YES;
    }
    return _emptyHeaderView;
}

/**
 * Lazily init the section one header view
 * @return UIView
 */
-(HomePageFirstSectionHeader *)sectionOneHeader {
    if (_sectionOneHeader == nil) {
        _sectionOneHeader = [[HomePageFirstSectionHeader alloc] initWithFrame:CGRectMake(0, 0, self.contentWidth, 110)];
    }
    return _sectionOneHeader;
}

/**
 * Lazily init the section two header view
 * @return UIView
 */
-(HomePageSecondSectionHeader *)sectionTwoHeader {
    if (_sectionTwoHeader == nil) {
        _sectionTwoHeader = [[HomePageSecondSectionHeader alloc] initWithFrame:CGRectMake(0, 0, self.contentWidth, 50)];
    }
    return _sectionTwoHeader;
}

/**
 * Lazily init the hamburger icon
 * @return UIButton
 */
-(UIButton *)hamburgerButton {
    if (_hamburgerButton == nil) {
        _hamburgerButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 20, 50, 50)];
        AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
        if (appDelegate.numNotif > 0) [_hamburgerButton setImage:[UIImage imageNamed:HOME_NAVIGATION_MENU_ICON_WHITE_WITH_RED_DOT] forState:UIControlStateNormal];
        else [_hamburgerButton setImage:[UIImage imageNamed:HOME_NAVIGATION_MENU_ICON_WHITE] forState:UIControlStateNormal];
        [_hamburgerButton addTarget:self action:@selector(hamburgerButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _hamburgerButton;
}

#pragma mark - view init
-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.contentWidth = frame.size.width;
        self.contentHeight = frame.size.height;
        self.backgroundColor = [UIColor whiteColor];
        
        [self addSubview:[self headerView]];
        [self addSubview:[self tableView]];
        self.tableView.tableHeaderView = [self emptyHeaderView];
        
        [self addSubview:[self hamburgerButton]];
    }
    return self;
}

-(void)dealloc {
    self.tableView.delegate = nil;
    self.tableView.dataSource = nil;
}

/**
 * Reload the hamburger icon to tell whether if it still have more notification
 */
-(void)reloadHamburger {
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    if (appDelegate.numNotif > 0) [_hamburgerButton setImage:[UIImage imageNamed:HOME_NAVIGATION_MENU_ICON_WHITE_WITH_RED_DOT] forState:UIControlStateNormal];
    else [_hamburgerButton setImage:[UIImage imageNamed:HOME_NAVIGATION_MENU_ICON_WHITE] forState:UIControlStateNormal];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) [self sectionOneHeader];
    else return [self sectionTwoHeader];
    return [self sectionOneHeader];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) return 110;
    return 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) return 3;
    else return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HomePageFirstSectionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER];
    if (cell == nil) cell = [[HomePageFirstSectionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_IDENTIFIER];
    
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
                [cell setBackgroundImage:[UIImage imageNamed:FIRST_SECTION_FIRST_IMAGE] andTitle:FIRST_SECTION_FIRST_ITEM_TITLE];
                break;
                
            case 1:
                [cell setBackgroundImage:[UIImage imageNamed:FIRST_SECTION_SECOND_IMAGE] andTitle:FIRST_SECTION_SECOND_ITEM_TITLE];
                break;
                
            case 2:
                [cell setBackgroundImage:[UIImage imageNamed:FIRST_SECTION_THIRD_IMAGE] andTitle:FIRST_SECTION_THIRD_ITEM_TITLE];
                break;
                
            default:
                break;
        }
    } else {
        [cell setBackgroundImage:[UIImage imageNamed:SECOND_SECTION_FIRST_IMAGE] andTitle:SECOND_SECTION_FIRST_ITEM_TITLE];
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 215;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.section == 0) [self.homePageDelegate homePageItemClickAtIndex:indexPath];
    else [self.homePageDelegate homePageHeaderViewClick];
}

#pragma mark - click action
/**
 * Handle the action when the user tap on the hamburger icon
 */
-(void)hamburgerButtonClicked {
    [self.homePageDelegate homePageHamburgerIconClick];
}

#pragma mark - scroll view delegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([scrollView isKindOfClass:[UITableView class]]) {
        CGFloat scrollOffset = scrollView.contentOffset.y;
        if (scrollOffset < 0) self.headerView.frame = CGRectMake(0, scrollOffset, self.contentWidth, 300 - 2 * scrollOffset);
        else self.headerView.frame = CGRectMake(0, -scrollOffset, self.contentWidth, 300);
    }
}



@end
