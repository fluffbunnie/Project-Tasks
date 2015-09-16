//
//  MyProfileLocationViewController.m
//  Magpie
//
//  Created by minh thao nguyen on 5/4/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import "MyProfileLocationViewController.h"
#import "FontColor.h"
#import <MapKit/MapKit.h>
#import "LocationTableViewCell.h"
#import "MyProfileTableViewController.h"
#import "SPGooglePlacesAutocompleteQuery.h"
#import "SPGooglePlacesAutocompletePlace.h"

static NSString *CELL_IDENTIFIER = @"locationCell";

static NSString *NAVIGATION_BAR_BACK_ICON_NAME = @"NavigationBarBackIconRed";
static NSString *SEARCH_PLACEHOLDER = @"Please enter your full address";

@interface MyProfileLocationViewController ()
@property (nonatomic, assign) CGFloat screenWidth;
@property (nonatomic, assign) CGFloat screenHeight;
@property (nonatomic, strong) UIBarButtonItem *backButton;

@property (nonatomic, strong) CLGeocoder *geocoder;
@property (nonatomic, strong) NSArray *results;
@property (nonatomic, strong) UITextField *searchTextField;
@property (nonatomic, strong) UIView *separator;
@property (nonatomic, strong) UITableView *searchResultsTable;
@end

@implementation MyProfileLocationViewController
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
 * Lazily init the search textfield
 * @return UITextField
 */
-(UITextField *)searchTextField {
    if (_searchTextField == nil) {
        _searchTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, 79, self.screenWidth - 20, 40)];
        _searchTextField.leftViewMode = UITextFieldViewModeAlways;
        _searchTextField.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SearchIcon"]];
        _searchTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:SEARCH_PLACEHOLDER attributes:@{NSForegroundColorAttributeName:[FontColor descriptionColor], NSFontAttributeName:[UIFont fontWithName:@"AvenirNext-Regular" size:15]}];
        _searchTextField.font = [UIFont fontWithName:@"AvenirNext-Regular" size:15];
        _searchTextField.textColor = [FontColor titleColor];
        _searchTextField.text = self.userLocation;
        
        _searchTextField.layer.cornerRadius = 20;
        _searchTextField.layer.borderColor = [FontColor defaultBackgroundColor].CGColor;
        _searchTextField.layer.borderWidth = 1;
        _searchTextField.returnKeyType = UIReturnKeyDone;
        _searchTextField.delegate = self;
        [_searchTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _searchTextField;
}

/**
 * Lazily init the separator between the search text field and the result table
 * @return UIView
 */
-(UIView *)separator {
    if (_separator == nil) {
        _separator = [[UIView alloc] initWithFrame:CGRectMake(0, 133, self.screenWidth, 2)];
        _separator.backgroundColor = [FontColor tableSeparatorColor];
    }
    return _separator;
}

/**
 * Lazily init the search results table
 * @return UITableView
 */
-(UITableView *)searchResultsTable {
    if (_searchResultsTable == nil) {
        _searchResultsTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 135, self.screenWidth, self.screenHeight - 145)];
        _searchResultsTable.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _searchResultsTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        _searchResultsTable.delegate = self;
        _searchResultsTable.dataSource = self;
        [_searchResultsTable registerClass:LocationTableViewCell.class forCellReuseIdentifier:CELL_IDENTIFIER];
    }
    return _searchResultsTable;
}

#pragma mark - view delegate
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Address";
    self.view.backgroundColor = [UIColor whiteColor];
    self.screenWidth = [[UIScreen mainScreen] bounds].size.width;
    self.screenHeight = [[UIScreen mainScreen] bounds].size.height;
    
    self.results = [[NSArray alloc] init];
    self.geocoder = [[CLGeocoder alloc] init];
    self.navigationItem.leftBarButtonItem = [self backButton];
    
    [self.view addSubview:[self searchTextField]];
    [self.view addSubview:[self separator]];
    [self.view addSubview:[self searchResultsTable]];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    tap.cancelsTouchesInView = NO;
    [self.searchResultsTable addGestureRecognizer:tap];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarHidden = NO;
    [self.navigationController setNavigationBarHidden:NO animated:false];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

#pragma mark - action changes
/**
 * UITextField delegate
 * Handle the behavior when user click the search button
 * @param UITextField
 * @return BOOL
 */
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

/**
 * Custom delegate for UITextField
 * Call this function when the text field is editted
 * @param UITextField
 */
-(void)textFieldDidChange:(UITextField *)textField {
    if (textField.text.length > 0) {
        SPGooglePlacesAutocompleteQuery *query = [SPGooglePlacesAutocompleteQuery query];
        query.input = textField.text;
        query.language = @"en";
        query.types = SPPlaceTypeGeocode;
        [query fetchPlaces:^(NSArray *places, NSError *error) {
            if (!error) {
                self.results = places;
                [self.searchResultsTable reloadData];
            }
        }];
    } else {
        self.results = [[NSArray alloc] init];
        [self.searchResultsTable reloadData];
    }
}

/**
 * Handle the behavior when keyboard is dismiss
 */
-(void)dismissKeyboard {
    [self.searchTextField resignFirstResponder];
}

/**
 * Handle the behavior when user click on the back button
 */
-(void)goBack {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - table view delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.results.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LocationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER];
    if (cell == nil) cell = [[LocationTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_IDENTIFIER];
    NSString *address = ((SPGooglePlacesAutocompletePlace *)self.results[indexPath.row]).name;
    [cell setLocationString:address];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSInteger currentViewControllerIndex = [self.navigationController.viewControllers indexOfObject:self];
    MyProfileTableViewController *myProfileTableViewController = [self.navigationController.viewControllers objectAtIndex:currentViewControllerIndex-1];
    [myProfileTableViewController setLocation:self.results[indexPath.row]];
    [self goBack];
}

@end
