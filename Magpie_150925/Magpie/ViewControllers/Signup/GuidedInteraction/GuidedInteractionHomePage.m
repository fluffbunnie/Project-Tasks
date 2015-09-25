//
//  GuidedInteractionHomePage.m
//  Magpie
//
//  Created by minh thao nguyen on 8/14/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import "GuidedInteractionHomePage.h"
#import "HomePageView.h"
#import "SearchTableView.h"

@interface GuidedInteractionHomePage()
@property (nonatomic, assign) CGFloat viewWidth;
@property (nonatomic, assign) CGFloat viewHeight;

@property (nonatomic, strong) HomePageView *homePageView;
@property (nonatomic, strong) SearchTableView *searchTableView;
@end

@implementation GuidedInteractionHomePage
#pragma mark - initiation
/**
 * Lazily init the home page view
 * @return HomePageView
 */
-(HomePageView *)homePageView {
    if (_homePageView == nil) {
        _homePageView = [[HomePageView alloc] initWithFrame:CGRectMake(0, 0, self.viewWidth, self.viewHeight)];
    }
    return _homePageView;
}

/**
 * Lazily init the search table view
 * @return SearchTableView
 */
-(SearchTableView *)searchTableView {
    if (_searchTableView == nil) {
        _searchTableView = [[SearchTableView alloc] initWithOrigin:CGPointMake(52, 25) andWidth:self.viewWidth - 70];
    }
    return _searchTableView;
}


#pragma mark - public method
-(id)init {
    self.viewWidth = [UIScreen mainScreen].bounds.size.width;
    self.viewHeight = [UIScreen mainScreen].bounds.size.height;
    self = [super initWithFrame:CGRectMake(0, -self.viewHeight, self.viewWidth, self.viewHeight)];
    if (self) {
        [self addSubview:[self homePageView]];
        [self addSubview:[self searchTableView]];
        self.userInteractionEnabled = NO;
    }
    return self;
}

@end
