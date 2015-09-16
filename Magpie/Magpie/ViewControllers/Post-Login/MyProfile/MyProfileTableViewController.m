//
//  MyProfileTableViewController.m
//  Magpie
//
//  Created by minh thao nguyen on 5/4/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import "MyProfileTableViewController.h"
#import <Parse/Parse.h>
#import "UserManager.h"
#import "FontColor.h"
#import "SquircleProfileImage.h"
#import "EditableTableViewCell.h"
#import "NoneEditableTableViewCell.h"
#import "UserManager.h"
#import "HomePageViewController.h"
#import "ToastView.h"
#import "MyProfileDescriptionViewController.h"
#import "MyProfileLocationViewController.h"
#import "JGActionSheet.h"
#import "PhotoPicker.h"
#import "UIImage+ImageEffects.h"
#import "LoadingView.h"
#import "ErrorMessageDisplay.h"
#import "SettingViewController.h"
#import "Mixpanel.h"

static NSString * CLOUDINARY_URL = @"cloudinary://556454867449341:Rtlqd_Lqzh_r3G1gX1DsxhLNq6k@magpie";
static NSString * LOADING_VIEW_TEXT = @"Uploading";

static NSString * VIEW_TITLE = @"Profile";
static NSString * NAVIGATION_BAR_BACK_ICON_NAME = @"NavigationBarBackIconRed";
static NSString * NAVIGATION_BAR_SETTING_ICON_NAME = @"NavigationBarSettingIconRed";

static NSString * DEFAULT_BACKGROUND_IMAGE_DARK = @"DefaultBackgroundImageDark";
static NSString * HEADER_MASK = @"PropertyImageMask";
static NSString * NAME_PLACE_HOLDER = @"Enter your name";

@interface MyProfileTableViewController ()
@property (nonatomic, strong) UIView *windowView;

@property (nonatomic, strong) PFObject *userObj;

@property (nonatomic, assign) CGFloat screenWidth;
@property (nonatomic, assign) CGFloat screenHeight;

@property (nonatomic, strong) JGActionSheet *photoPickerActionSheet;
@property (nonatomic, strong) PhotoPicker *photoPicker;
@property (nonatomic, strong) CLCloudinary *cloudinary;
@property (nonatomic, strong) LoadingView *loadingView;

@property (nonatomic, strong) UIBarButtonItem *backButton;
@property (nonatomic, strong) UIBarButtonItem *settingsButton;

@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) SquircleProfileImage *profileImageBorder;
@property (nonatomic, strong) SquircleProfileImage *profileImage;
@property (nonatomic, strong) UITextField *profileName;

@property (nonatomic, strong) NoneEditableTableViewCell *userEmailCell;
@property (nonatomic, strong) EditableTableViewCell *userLocationCell;
@property (nonatomic, strong) EditableTableViewCell *userDescriptionCell;
@end

@implementation MyProfileTableViewController

#pragma mark - initiation
/**
 * Lazily init the photo picker action sheet
 * @return JGActionSheet
 */
-(JGActionSheet *)photoPickerActionSheet {
    if (_photoPickerActionSheet == nil) {
        JGActionSheetSection *section1 = [JGActionSheetSection sectionWithTitle:nil message:nil buttonTitles:@[@"Upload from your photo library"] buttonStyle:JGActionSheetButtonStyleDefault];
        JGActionSheetSection *cancelSection = [JGActionSheetSection sectionWithTitle:nil message:nil buttonTitles:@[@"Cancel"] buttonStyle:JGActionSheetButtonStyleCancel];

        _photoPickerActionSheet = [JGActionSheet actionSheetWithSections:@[section1, cancelSection]];
        
        __weak typeof(self) weakSelf = self;
        [_photoPickerActionSheet setButtonPressedBlock:^(JGActionSheet *sheet, NSIndexPath *indexPath) {
            if (indexPath.section == 0) [weakSelf showPhotoPicker];
            [sheet dismissAnimated:YES];
        }];
    }
    return _photoPickerActionSheet;
}

/**
 * Lazily init the photo picker obj
 * @return PhotoPicker
 */
-(PhotoPicker *)photoPicker {
    if (_photoPicker == nil) {
        _photoPicker = [[PhotoPicker alloc] initWithViewController:self];
        _photoPicker.photoPickerDelegate = self;
    }
    return _photoPicker;
}

/**
 * Lazily init the cloudinary object
 * @return CLUploader
 */
-(CLCloudinary *)cloudinary {
    if (_cloudinary == nil) _cloudinary = [[CLCloudinary alloc] initWithUrl:CLOUDINARY_URL];
    return _cloudinary;
}

/**
 * Lazily init the loading view
 * @return LoadingView
 */
-(LoadingView *)loadingView {
    if (_loadingView == nil) {
        _loadingView = [[LoadingView alloc] initWithMessage:LOADING_VIEW_TEXT];
    }
    return _loadingView;
}

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
 * Lazily init the setting button item
 * @return UIBarButtonItem
 */
-(UIBarButtonItem *)settingsButton {
    if (_settingsButton == nil) {
        _settingsButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:NAVIGATION_BAR_SETTING_ICON_NAME]
                                                       style:UIBarButtonItemStyleBordered
                                                      target:self
                                                      action:@selector(goToSetting)];
    }
    return _settingsButton;
}

/**
 * Lazily init the header view
 * @return UIView
 */
-(UIView *)headerView {
    if (_headerView == nil) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.screenWidth, 160)];
        
        [_headerView addSubview:[self backgroundImageView]];
        [_headerView addSubview:[self profileImageBorder]];
        [_headerView addSubview:[self profileImage]];
        [_headerView addSubview:[self profileName]];
    }
    return _headerView;
}

/**
 * Lazily init the masked background image view
 * @return UIImageView
 */
-(UIImageView *)backgroundImageView {
    if (_backgroundImageView == nil) {
        _backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.screenWidth, 160)];
        _backgroundImageView.image = [UIImage imageNamed:DEFAULT_BACKGROUND_IMAGE_DARK];
        _backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
        _backgroundImageView.clipsToBounds = YES;
        
        CALayer *maskLayer = [CALayer layer];
        maskLayer.contents = (id)[[UIImage imageNamed:HEADER_MASK] CGImage];
        maskLayer.frame = CGRectMake(0, 0, self.screenWidth, 160);
        _backgroundImageView.layer.mask = maskLayer;
        _backgroundImageView.layer.masksToBounds = YES;
    }
    return _backgroundImageView;
}

/**
 * Lazily init the profile image border
 * @return SquircleProfileImage
 */
-(SquircleProfileImage *)profileImageBorder {
    if (_profileImageBorder == nil) {
        _profileImageBorder = [[SquircleProfileImage alloc] initWithFrame:CGRectMake(self.screenWidth/2 - 38, 28, 76, 76)];
    }
    return _profileImageBorder;
}

/**
 * Lazily init the profile image
 * @return profile image
 */
-(SquircleProfileImage *)profileImage {
    if (_profileImage == nil) {
        _profileImage = [[SquircleProfileImage alloc] initWithFrame:CGRectMake(self.screenWidth/2 - 35, 31, 70, 70)];
        [_profileImage setProfileImageWithUrl:self.userObj[@"profilePic"]];
        _profileImage.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showUploadPhotoActionSheet)];
        [_profileImage addGestureRecognizer:tapGesture];
    }
    return _profileImage;
}

/**
 * Lazily init the profile name
 * @return UITextField
 */
-(UITextField *)profileName {
    if (_profileName == nil) {
        _profileName = [[UITextField alloc] initWithFrame:CGRectMake(20, 115, self.screenWidth - 40, 20)];
        _profileName.textAlignment = NSTextAlignmentCenter;
        _profileName.textColor = [UIColor whiteColor];
        _profileName.font = [UIFont fontWithName:@"AvenirNext-Medium" size:16];
        _profileName.text = [UserManager getUserNameFromUserObj:self.userObj];
        _profileName.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NAME_PLACE_HOLDER attributes:@{NSForegroundColorAttributeName:[FontColor descriptionColor],
            NSFontAttributeName:[UIFont fontWithName:@"AvenirNext-Regular" size:14]}];
        
        _profileName.delegate = self;
    }
    return _profileName;
}

/**
 * Lazily init the user email cell
 * @return NoneEditableTableViewCell
 */
-(NoneEditableTableViewCell *)userEmailCell {
    if (_userEmailCell == nil) {
        _userEmailCell = [[NoneEditableTableViewCell alloc] init];
        _userEmailCell.titleLabel.text = @"E-mail";
        _userEmailCell.descriptionLabel.text = self.userObj[@"email"];
    }
    return _userEmailCell;
}

/**
 * Lazily init the user location cell
 * @return EditableTableViewCell
 */
-(EditableTableViewCell *)userLocationCell {
    if (_userLocationCell == nil) {
        _userLocationCell = [[EditableTableViewCell alloc] init];
        _userLocationCell.titleLabel.text = @"Location";
        if (self.userObj[@"fullLocation"]) _userLocationCell.descriptionLabel.text = self.userObj[@"fullLocation"];
        else if (self.userObj[@"location"]) _userLocationCell.descriptionLabel.text = self.userObj[@"location"];
        
        [_userLocationCell setPlaceHolderText:@"Enter your address"];
    }
    return _userLocationCell;
}

/**
 * Lazily init the user's about me cell
 * @return EditableTableViewCell
 */
-(EditableTableViewCell *)userDescriptionCell {
    if (_userDescriptionCell == nil) {
        _userDescriptionCell = [[EditableTableViewCell alloc] init];
        _userDescriptionCell.titleLabel.text = @"About me";
        if (self.userObj[@"description"]) _userDescriptionCell.descriptionLabel.text = self.userObj[@"description"];
        
        [_userDescriptionCell setPlaceHolderText:@"Write about yourself"];
    }
    return _userDescriptionCell;
}


#pragma mark - public method
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.windowView = [[[[UIApplication sharedApplication] keyWindow] subviews] lastObject];
    [[UserManager sharedUserManager] getUserWithCompletionHandler:^(PFObject *userObj) {
        self.userObj = userObj;
    }];
    
    self.screenWidth = [[UIScreen mainScreen] bounds].size.width;
    self.screenHeight = [[UIScreen mainScreen] bounds].size.height;
    self.title = VIEW_TITLE;
    self.navigationItem.leftBarButtonItem = [self backButton];
    self.navigationItem.rightBarButtonItem = [self settingsButton];
    
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.scrollEnabled = NO;
    self.tableView.tableHeaderView = [self headerView];
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    gestureRecognizer.cancelsTouchesInView = NO;
    [self.tableView addGestureRecognizer:gestureRecognizer];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarHidden = NO;
    [self.navigationController setNavigationBarHidden:NO animated:false];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

/**
 * Set user's location
 * @param SPGooglePlacesAutocompletePlace
 */
-(void)setLocation:(SPGooglePlacesAutocompletePlace *)place {
    [place resolveToPlacemark:^(CLPlacemark *location, NSString *addressString, NSError *error) {
        if (location && !error) {
            NSDictionary *locationDictionary = location.addressDictionary;
            
            NSString *street = locationDictionary[@"Street"] ? locationDictionary[@"Street"] : nil;
            if (street == nil) street = locationDictionary[@"Name"] ? locationDictionary[@"Name"] : nil;
            
            NSMutableArray *descriptionArray = [[NSMutableArray alloc] init];
            if (locationDictionary[@"City"]) [descriptionArray addObject:locationDictionary[@"City"]];
            if (locationDictionary[@"State"]) [descriptionArray addObject:locationDictionary[@"State"]];
            if (locationDictionary[@"Country"]) [descriptionArray addObject:locationDictionary[@"Country"]];
            NSString *shortLocation = [descriptionArray componentsJoinedByString:@", "];
            
            if (shortLocation.length > 0) self.userObj[@"location"] = shortLocation;
            else if (street.length > 0) self.userObj[@"location"] = street;
            
            if (street.length > 0 && shortLocation.length > 0) self.userLocationCell.descriptionLabel.text = [NSString stringWithFormat:@"%@, %@", street, shortLocation];
            else if (shortLocation.length > 0) self.userLocationCell.descriptionLabel.text = shortLocation;
            
            self.userObj[@"fullLocation"] = self.userLocationCell.descriptionLabel.text;
            self.userObj[@"coordinate"] = [PFGeoPoint geoPointWithLocation:location.location];
            [self.tableView reloadData];
        } else {
            [place getLocation:^(NSDictionary *location, NSString *addressString, NSError *error) {
                if (location[@"results"]) {
                    NSArray *locations = location[@"results"];
                    if (locations.count > 0) {
                        NSDictionary *firstMatch = locations[0];
                        NSString *mLoc = firstMatch[@"formatted_address"] ? firstMatch[@"formatted_address"] : @"";
                        self.userObj[@"location"] = mLoc;
                        self.userObj[@"fullLocation"] = mLoc;
                        self.userLocationCell.descriptionLabel.text = mLoc;
                        
                        NSDictionary *geometry = firstMatch[@"geometry"] ? firstMatch[@"geometry"] : nil;
                        NSDictionary *coordinate = (geometry && geometry[@"location"]) ? geometry[@"location"] : nil;
                        if (coordinate != nil && coordinate[@"lat"] && coordinate[@"lng"]) {
                            double lat = [coordinate[@"lat"] doubleValue];
                            double lng = [coordinate[@"lng"] doubleValue];
                            self.userObj[@"coordinate"] = [PFGeoPoint geoPointWithLatitude:lat longitude:lng];
                        }
                        [self.tableView reloadData];
                    }
                }
            }];
        }
    }];
}

/**
 * Set user's description
 * @param NSString
 */
-(void)setAboutMe:(NSString *)aboutMe {
    self.userDescriptionCell.descriptionLabel.text = aboutMe;
    self.userObj[@"description"] = aboutMe ? aboutMe : [NSNull null];
    [self.tableView reloadData];
}


#pragma mark - click listener and delegate
/**
 * handle the behavior when the user click on the back button
 */
-(void)goBack {
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 * Handle the behavior when user clicked on the setting button
 */
-(void)goToSetting {
    [[Mixpanel sharedInstance] track:@"Setting Click"];
    SettingViewController *settingViewController = [[SettingViewController alloc] init];
    [self.navigationController pushViewController:settingViewController animated:YES];
}

/**
 * Handle the behavior when user tap on the profile picture
 */
-(void)showUploadPhotoActionSheet {
    [self hideKeyboard];
    [self.profileName resignFirstResponder];
    [[self photoPickerActionSheet] showInView:self.windowView animated:YES];
}

/**
 * Handle the action when user click on upload new photo button in the action sheet
 */
-(void)showPhotoPicker {
    [[self photoPicker] showMediaBrowser];
}

/**
 * Handle the action when user updated the new photo
 * @param UIImage
 */
-(void)uploadImage:(UIImage *)image {
    [self dismissViewControllerAnimated:YES completion:^{
        [[self loadingView] showInView:self.windowView];
        
        CLUploader *photoUploader = [[CLUploader alloc] init:[self cloudinary] delegate:nil];
        
        UIImage *scaledImage = [image scaleToSizeKeepAspect:CGSizeMake(1440, 1440)];
        NSData* data = UIImageJPEGRepresentation(scaledImage, 0.8);
        [photoUploader upload:data options:nil withCompletion:^(NSDictionary *successResult, NSString *errorResult, NSInteger code, id context) {
            if (successResult) {
                self.userObj[@"profilePic"] = successResult[@"url"];
                
                [self.userObj saveInBackground];
                [self.profileImage setProfileImageWithUrl:self.userObj[@"profilePic"]];
                [self.loadingView dismiss];
            } else {
                [self.loadingView dismiss];
                [ErrorMessageDisplay displayErrorAlertOnViewController:self withTitle:PHOTO_UPLOAD_FAIL_TITLE andMessage:PHOTO_UPLOAD_FAIL_DESCRIPTION];
            }
        } andProgress:^(NSInteger bytesWritten, NSInteger totalBytesWritten, NSInteger totalBytesExpectedToWrite, id context) {}];
    }];
}

#pragma mark - textfield and keyboard
/**
 * Handle the behavior when user click on outside the username editext
 */
-(void)hideKeyboard {
    [self.profileName resignFirstResponder];
}

/**
 * UITextField delegate
 * When the text field click on return button
 */
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    self.userObj[@"username"] = textField.text ? textField.text : [NSNull null];
    self.userObj[@"firstname"] = textField.text ? textField.text : [NSNull null];
    return YES;
}

#pragma mark - table view delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.userObj[@"email"]) return 3;
    else return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.userObj[@"email"]) {
        if (indexPath.row == 0) return [self userEmailCell];
        else if (indexPath.row == 1) return [self userLocationCell];
        else return [self userDescriptionCell];
    } else {
        if (indexPath.row == 0) return [self userLocationCell];
        else return [self userDescriptionCell];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

-(BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return !(self.userObj[@"email"] && indexPath.row == 0);
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.profileName resignFirstResponder];
    if ((self.userObj[@"email"] && indexPath.row == 1) || (!self.userObj[@"email"] && indexPath.row == 0)) {
        MyProfileLocationViewController *myProfileLocationViewController = [[MyProfileLocationViewController alloc] init];
        myProfileLocationViewController.userLocation = self.userLocationCell.descriptionLabel.text;
        [self.navigationController pushViewController:myProfileLocationViewController animated:YES];
    } else if ((self.userObj[@"email"] && indexPath.row == 2) || (!self.userObj[@"email"] && indexPath.row == 1)) {
        MyProfileDescriptionViewController *myProfileDescriptionViewController = [[MyProfileDescriptionViewController alloc] init];
        myProfileDescriptionViewController.userDescription = self.userDescriptionCell.descriptionLabel.text;
        [self.navigationController pushViewController:myProfileDescriptionViewController animated:YES];
    }
}

@end
