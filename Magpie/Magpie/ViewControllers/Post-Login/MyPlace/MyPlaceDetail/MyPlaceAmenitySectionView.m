//
//  MyPlaceAmenitySectionView.m
//  Magpie
//
//  Created by minh thao nguyen on 5/25/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import "MyPlaceAmenitySectionView.h"
#import "AmenityItem.h"
#import "HousingLayoutView.h"
#import "FontColor.h"
#import "Amenity.h"

static NSString * CELL_IDENTIFIER = @"inputAmenityCell";
static NSString * HEADER_INSTRUCTION_TEXT = @"Please choose the amenities that are\navailable to your guest.";

@interface MyPlaceAmenitySectionView ()
@property (nonatomic, strong) NSMutableArray *amenityItems;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIImageView *headerIconView;
@property (nonatomic, strong) UILabel *headerInstructionView;
@end

@implementation MyPlaceAmenitySectionView
#pragma mark -initiation
/**
 * Lazily init the header view
 * @return UIView
 */
-(UIView *)headerView {
    if (_headerView == nil) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 100)];
        _headerView.backgroundColor = [UIColor whiteColor];
        [_headerView addSubview:[self headerIconView]];
        [_headerView addSubview:[self headerInstructionView]];
    }
    return _headerView;
}

/**
 * Lazily init the header icon view
 * @return UIImageView
 */
-(UIImageView *)headerIconView {
    if (_headerIconView == nil) {
        _headerIconView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 20, self.frame.size.width, 80)];
        _headerIconView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _headerIconView;
}

/**
 * Lazily init header direction label
 * @return UILabel
 */
-(UILabel *)headerInstructionView {
    if (_headerInstructionView == nil) {
        _headerInstructionView = [[UILabel alloc] initWithFrame:CGRectMake(0, 120, self.frame.size.width, 50)];
        _headerInstructionView.font = [UIFont fontWithName:@"AvenirNext-Regular" size:14];
        _headerInstructionView.textAlignment = NSTextAlignmentCenter;
        _headerInstructionView.textColor = [FontColor descriptionColor];
        _headerInstructionView.numberOfLines = 0;
        _headerInstructionView.text = HEADER_INSTRUCTION_TEXT;
    }
    return _headerInstructionView;
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
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        [_tableView registerClass:MyPlaceAmenityItemTableViewCell.class forCellReuseIdentifier:CELL_IDENTIFIER];
    }
    return _tableView;
}

#pragma mark - public method
-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.amenityItems = [[NSMutableArray alloc] init];
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:[self tableView]];
    }
    return self;
}

/**
 * Set the amenity obj and the amenity type
 * @param PFObject
 * @param NSInteger
 */
-(void)setAmenityObj:(PFObject *)amenityObj andAmenitySectionType:(NSInteger)type {
    if (type == HOUSING_LAYOUT_HOME_INDEX) {
        self.headerIconView.image = [UIImage imageNamed:HOUSING_LAYOUT_HOME_HIGHLIGHT_IMG_NAME];
        self.amenityItems = [NSMutableArray arrayWithArray:[Amenity getGeneralAmenities:amenityObj]];
        [self.tableView reloadData];
    } else if (type == HOUSING_LAYOUT_BEDROOM_INDEX) {
        self.headerIconView.image = [UIImage imageNamed:HOUSING_LAYOUT_BEDROOM_HIGHLIGHT_IMG_NAME];
        self.amenityItems = [NSMutableArray arrayWithArray:[Amenity getBedroomAmenities:amenityObj]];
        [self.tableView reloadData];
    } else if (type == HOUSING_LAYOUT_BATHROOM_INDEX) {
        self.headerIconView.image = [UIImage imageNamed:HOUSING_LAYOUT_BATHROOM_HIGHLIGHT_IMG_NAME];
        self.amenityItems = [NSMutableArray arrayWithArray:[Amenity getBathroomAmenities:amenityObj]];
        [self.tableView reloadData];
    } else if (type == HOUSING_LAYOUT_LIVINGROOM_INDEX) {
        self.headerIconView.image = [UIImage imageNamed:HOUSING_LAYOUT_LIVINGROOM_HIGHLIGHT_IMG_NAME];
        self.amenityItems = [NSMutableArray arrayWithArray:[Amenity getLivingroomAmenities:amenityObj]];
        [self.tableView reloadData];
    } else if (type == HOUSING_LAYOUT_KITCHEN_INDEX) {
        self.headerIconView.image = [UIImage imageNamed:HOUSING_LAYOUT_KITCHEN_HIGHLIGHT_IMG_NAME];
        self.amenityItems = [NSMutableArray arrayWithArray:[Amenity getKitchenAmenities:amenityObj]];
        [self.tableView reloadData];
    }
}

/**
 * Get the list of all amenity items
 * @return NSMutableArray
 */
-(NSMutableArray *)getAllAmentityItem {
    return self.amenityItems;
}

#pragma mark - text field begin editing
-(void)textFieldWillBeginEditting:(UITextField *)textField {
    MyPlaceAmenityItemTableViewCell *cell = (MyPlaceAmenityItemTableViewCell *) textField.superview.superview;
    [self.tableView scrollToRowAtIndexPath:[self.tableView indexPathForCell:cell] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [self headerView];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 200;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 200;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.amenityItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyPlaceAmenityItemTableViewCell *cell = [[MyPlaceAmenityItemTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_IDENTIFIER];
    cell.cellDelegate = self;
    
    AmenityItem *amenityItem = self.amenityItems[indexPath.row];
    [cell setAmenityItem:amenityItem];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    MyPlaceAmenityItemTableViewCell *cell = (MyPlaceAmenityItemTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    [cell cellClicked];
}

@end
