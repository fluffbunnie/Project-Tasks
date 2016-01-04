//
//  HousingAmenitySectionView.m
//  Magpie
//
//  Created by minh thao nguyen on 5/19/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import "HousingAmenitySectionView.h"
#import "UIVerticalButton.h"
#import "FontColor.h"

static NSString * CELL_IDENTIFIER = @"amenityCell";

@interface HousingAmenitySectionView()
@property (nonatomic, strong) NSArray *amenityItems;
@property (nonatomic, strong) CAGradientLayer *topGradient;
@property (nonatomic, strong) CAGradientLayer *bottomGradient;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *emptyView;
@end

@implementation HousingAmenitySectionView
#pragma mark - initiation
/**
 * Lazily init the top gradient layer
 * @param CAGradientLayer
 */
-(CAGradientLayer *)topGradient {
    if (_topGradient == nil) {
        _topGradient = [CAGradientLayer layer];
        _topGradient.frame = CGRectMake(0, 0, self.frame.size.width, 50);
        _topGradient.colors = [NSArray arrayWithObjects:(id)[UIColor whiteColor].CGColor, (id)[UIColor whiteColor].CGColor, (id)[UIColor whiteColor].CGColor, (id)[UIColor colorWithWhite:1 alpha:0].CGColor, nil];
    }
    return _topGradient;
}

/**
 * Lazily init the bottom gradient layer
 * @param CAGradientLayer
 */
-(CAGradientLayer *)bottomGradient {
    if (_bottomGradient == nil) {
        _bottomGradient = [CAGradientLayer layer];
        _bottomGradient.frame = CGRectMake(0, self.frame.size.height - 50, self.frame.size.width, 50);
        _bottomGradient.colors = [NSArray arrayWithObjects:(id)[UIColor colorWithWhite:1 alpha:0].CGColor, (id)[UIColor whiteColor].CGColor, (id)[UIColor whiteColor].CGColor, nil];
    }
    return _bottomGradient;
}

/**
 * Lazily init the table view
 * @param UITableView
 */
-(UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [_tableView registerClass:AmenityDisplayTableViewCell.class forCellReuseIdentifier:CELL_IDENTIFIER];
    }
    return _tableView;
}

/**
 * Lazily init the empty view
 * @param UIButton
 */
-(UIView *)emptyView {
    if (_emptyView == nil) {
        _emptyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _emptyView.backgroundColor = [UIColor whiteColor];
        
        UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.frame.size.height/2 - 45, self.frame.size.width, 50)];
        icon.contentMode = UIViewContentModeScaleAspectFit;
        icon.image = [UIImage imageNamed:@"NoAmenityIcon"];
        [_emptyView addSubview:icon];
        
        UILabel *text = [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.height/2 + 15, self.frame.size.width, 30)];
        text.textAlignment = NSTextAlignmentCenter;
        text.textColor = [FontColor defaultBackgroundColor];
        text.font = [UIFont fontWithName:@"AvenirNext-Regular" size:15];
        text.text = @"There are no ameneties in this room.";
        [_emptyView addSubview:text];
    }
    return _emptyView;
}

#pragma mark - public method
-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor =[UIColor whiteColor];
        self.layer.cornerRadius = 20;
        self.clipsToBounds = YES;
    }
    return self;
}

-(void)setAmenities:(NSArray *)amenities {
    self.amenityItems = amenities;
    if (self.amenityItems.count == 0) [self addSubview:[self emptyView]];
    else [self addSubview:[self tableView]];
    [self.layer addSublayer:[self topGradient]];
    [self.layer addSublayer:[self bottomGradient]];
}

#pragma mark - table delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 40)];
    view.backgroundColor = [UIColor whiteColor];
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.height, 40)];
    view.backgroundColor = [UIColor whiteColor];
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 40;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.amenityItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AmenityDisplayTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER];
    if (cell == nil) cell = [[AmenityDisplayTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_IDENTIFIER];
    [cell setAmenityItem:self.amenityItems[indexPath.row]];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [AmenityDisplayTableViewCell heightForAmenity:self.amenityItems[indexPath.row]];
}

-(BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}


@end
