//
//  SearchTableView.m
//  Magpie
//
//  Created by minh thao nguyen on 4/27/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import "SearchTableView.h"
#import "FontColor.h"
#import "SearchResultTableViewCell.h"
#import "Mixpanel.h"
#import "SPGooglePlacesAutocompleteQuery.h"
#import "SPGooglePlacesAutocompletePlace.h"

static NSString * CELL_IDENTIFIER = @"searchResultCell";
static CGFloat VIEW_CORNER_RADIUS = 15;
static NSString *SEARCH_PLACEHOLDER = @"What city is calling your name?";

@interface SearchTableView()
@property (nonatomic, assign) CGRect minimizeSearchView;
@property (nonatomic, assign) CGRect maximizeSearchView;

@property (nonatomic, strong) UIView *shadowView;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UITextField *searchTextField;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *locationArray;
@end

@implementation SearchTableView

#pragma mark - initiation

/**
 * Lazily init the shadow view
 * @return UIView
 */
-(UIView *)shadowView {
    if (_shadowView == nil) {
        _shadowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.minimizeSearchView), CGRectGetHeight(self.minimizeSearchView))];
        _shadowView.backgroundColor = [UIColor whiteColor];
        _shadowView.layer.cornerRadius = VIEW_CORNER_RADIUS;
        _shadowView.layer.shadowColor = [[UIColor blackColor] CGColor];
        _shadowView.layer.shadowRadius = 1;
        _shadowView.layer.shadowOffset = CGSizeMake(1, 1);
        _shadowView.layer.shadowOpacity = 0.7;
    }
    return _shadowView;
}

/**
 * Lazily init the container view
 * @return UIView
 */
-(UIView *)containerView {
    if (_containerView == nil) {
        _containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.minimizeSearchView), CGRectGetHeight(self.minimizeSearchView))];
        _containerView.layer.cornerRadius = VIEW_CORNER_RADIUS;
        _containerView.clipsToBounds = YES;
        _containerView.layer.masksToBounds = YES;
    }
    return _containerView;
}

/**
 * Lazily init the search textfield
 * @return UITextField
 */
-(UITextField *)searchTextField {
    if (_searchTextField == nil) {
        _searchTextField = [[UITextField alloc] initWithFrame:CGRectMake(5, 0, self.minimizeSearchView.size.width - 10, 34)];
        _searchTextField.leftViewMode = UITextFieldViewModeAlways;
        _searchTextField.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SearchIcon"]];
        _searchTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:SEARCH_PLACEHOLDER attributes:@{NSForegroundColorAttributeName:[FontColor descriptionColor], NSFontAttributeName:[UIFont fontWithName:@"AvenirNext-Regular" size:13]}];
        _searchTextField.font = [UIFont fontWithName:@"AvenirNext-Regular" size:13];
        _searchTextField.textColor = [FontColor titleColor];
        _searchTextField.delegate = self;
        
        [_searchTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _searchTextField;
}

/**
 * Lazily init the search table view
 * @return UITableView
 */
-(UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 34, CGRectGetWidth(self.minimizeSearchView), 146)];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.scrollsToTop = NO;
        _tableView.layer.masksToBounds = YES;
        _tableView.layer.cornerRadius = VIEW_CORNER_RADIUS;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.scrollEnabled = NO;
        _tableView.bounces = NO;
        
        [_tableView registerClass:SearchResultTableViewCell.class forCellReuseIdentifier:CELL_IDENTIFIER];
    }
    return _tableView;
}

#pragma mark - public methods
/**
 * Init the search view using view's origin and width
 * @return CGPoint
 * @return CGFloat
 */
-(id)initWithOrigin:(CGPoint)origin andWidth:(CGFloat)width {
    self.minimizeSearchView = CGRectMake(origin.x, origin.y, width, 34);
    self.maximizeSearchView = CGRectMake(origin.x, origin.y, width, 180);
    self = [super initWithFrame:self.minimizeSearchView];
    if (self) {
        [self addSubview:[self shadowView]];
        [self addSubview:[self containerView]];
        [self.containerView addSubview:[self searchTextField]];
        [self.containerView addSubview:[self tableView]];
        
        self.locationArray = [[NSArray alloc] init];
        [self addSubview:[self searchTextField]];
    }
    return self;
}

-(void)dealloc {
    self.tableView.delegate = nil;
    self.tableView.dataSource = nil;
}

/**
 * Check if the search field is currently the first responder. If so, resign it
 */
-(void)resignTextFieldFirstResponder {
    if ([self.searchTextField isFirstResponder]) [self.searchTextField resignFirstResponder];
}

#pragma mark - table view delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.locationArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SearchResultTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER];
    if (cell == nil) cell = [[SearchResultTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_IDENTIFIER];
    
    NSString *address = ((SPGooglePlacesAutocompletePlace *)self.locationArray[indexPath.row]).name;
    [cell setLocation:address];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    SPGooglePlacesAutocompletePlace *place = self.locationArray[indexPath.row];
    
    [place getLocation:^(NSDictionary *location, NSString *addressString, NSError *error) {
        if (location[@"results"]) {
            NSArray *locations = location[@"results"];
            if (locations.count > 0) {
                NSDictionary *firstMatch = locations[0];
                NSDictionary *geometry = firstMatch[@"geometry"] ? firstMatch[@"geometry"] : nil;
                NSDictionary *coordinate = (geometry && geometry[@"location"]) ? geometry[@"location"] : nil;
                if (coordinate != nil && coordinate[@"lat"] && coordinate[@"lng"]) {
                    double lat = [coordinate[@"lat"] doubleValue];
                    double lng = [coordinate[@"lng"] doubleValue];
                    [self.searchDelegate searchLocation:[PFGeoPoint geoPointWithLatitude:lat longitude:lng] andAddress:addressString];
                }
            }
        }
    }];
}

#pragma mark - textview delegate
/**
 * UITextField delegate
 * When the text field begin editing and if the text is not nil, then we show the search result
 * @param UITextField
 */
-(void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField.text.length > 1) {
        [UIView animateWithDuration:0.2 animations:^{
            self.frame = self.maximizeSearchView;
            self.containerView.frame = CGRectMake(0, 0, CGRectGetWidth(self.maximizeSearchView), CGRectGetHeight(self.maximizeSearchView));
            self.shadowView.frame = CGRectMake(0, 0, CGRectGetWidth(self.maximizeSearchView), CGRectGetHeight(self.maximizeSearchView));
        } completion:^(BOOL finished) {
            self.tableView.scrollEnabled = YES;
        }];
    }
}

/**
 * UITextView delegate
 * When the text field end editing, and have no text information, we simply 
 * collapse the search view
 * @param UITextField
 */
-(void)textFieldDidEndEditing:(UITextField *)textField {
    [UIView animateWithDuration:0.2 animations:^{
        self.frame = self.minimizeSearchView;
        self.containerView.frame = CGRectMake(0, 0, CGRectGetWidth(self.minimizeSearchView), CGRectGetHeight(self.minimizeSearchView));
        self.shadowView.frame = CGRectMake(0, 0, CGRectGetWidth(self.minimizeSearchView), CGRectGetHeight(self.minimizeSearchView));
    } completion:^(BOOL finished) {
        self.tableView.scrollEnabled = NO;
    }];

}

/**
 * Custom delegate for UITextField
 * Call this function when the text field is editted
 * @param UITextField
 */
-(void)textFieldDidChange:(UITextField *)textField {
    if (textField.text.length > 1) {
        [UIView animateWithDuration:0.2 animations:^{
            self.frame = self.maximizeSearchView;
            self.containerView.frame = CGRectMake(0, 0, CGRectGetWidth(self.maximizeSearchView), CGRectGetHeight(self.maximizeSearchView));
            self.shadowView.frame = CGRectMake(0, 0, CGRectGetWidth(self.maximizeSearchView), CGRectGetHeight(self.maximizeSearchView));
        } completion:^(BOOL finished) {
            self.tableView.scrollEnabled = YES;
        }];

        SPGooglePlacesAutocompleteQuery *query = [SPGooglePlacesAutocompleteQuery query];
        query.input = textField.text;
        query.language = @"en";
        query.types = SPPlaceTypeGeocode;
        [query fetchPlaces:^(NSArray *places, NSError *error) {
            if (!error) {
                self.locationArray = places;
                [self.tableView reloadData];
            }
        }];
    } else {
        [UIView animateWithDuration:0.2 animations:^{
            self.frame = self.minimizeSearchView;
            self.containerView.frame = CGRectMake(0, 0, CGRectGetWidth(self.minimizeSearchView), CGRectGetHeight(self.minimizeSearchView));
            self.shadowView.frame = CGRectMake(0, 0, CGRectGetWidth(self.minimizeSearchView), CGRectGetHeight(self.minimizeSearchView));
        } completion:^(BOOL finished) {
            self.tableView.scrollEnabled = NO;
        }];
        
        self.locationArray = [[NSArray alloc] init];
        [self.tableView reloadData];
    }
}

/**
 * Handle the behavior when the user click on the done button
 * @param UITextField
 * @return BOOL
 */
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

@end
