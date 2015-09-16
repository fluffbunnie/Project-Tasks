//
//  MyplaceDetailViewController.m
//  Magpie
//
//  Created by minh thao nguyen on 5/10/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import "MyPlaceDetailViewController.h"
#import "JGActionSheet.h"
#import "Cloudinary.h"
#import "LoadingView.h"
#import "EditableTableViewCell.h"
#import "FontColor.h"
#import "ToastView.h"
#import "UIImage+ImageEffects.h"
#import "ErrorMessageDisplay.h"
#import "Property.h"
#import "MyPlaceLocationViewController.h"
#import "RoundButton.h"
#import "Device.h"
#import "ParseConstant.h"
#import "MyPlaceInfoViewController.h"
#import "EditPhotoObjViewController.h"
#import "MyPlaceAmenityViewController.h"
#import "UserManager.h"
#import "MyPlaceListViewController.h"
#import "ImportSelectionViewController.h"
#import "MyPlaceReviewViewController.h"

static NSString * CLOUDINARY_URL = @"cloudinary://556454867449341:Rtlqd_Lqzh_r3G1gX1DsxhLNq6k@magpie";
static NSString * LOADING_VIEW_TEXT = @"Uploading";

static NSString * VIEW_TITLE = @"House Profile";
static NSString * NAVIGATION_BAR_BACK_ICON_NAME = @"NavigationBarBackIconRed";

static NSString * DEFAULT_BACKGROUND_IMAGE_DARK = @"DefaultBackgroundImageDark";
static NSString * HEADER_MASK = @"PropertyImageMask";

static NSString *IMPORT_TITLE_TEXT = @"Have a place listed online already?";
static NSString * const CLOSE_BUTTON_NORMAL_IMAGE = @"NavigationBarCloseIconWhite";
static NSString * const CLOSE_BUTTON_HIGHLIGHT_IMAGE = @"NavigationBarCloseIconRed";

static NSString * APPROVAL_REQUIRE_IMAGE_ERROR_TITLE = @"Photo required for your place";
static NSString * APPROVAL_REQUIRE_IMAGE_ERROR_DESCRIPTION = @"Your place needs a photo. Please try again.";

static NSString * APPROVAL_REQUIRE_NAME_ERROR_TITLE = @"Missing home information";
static NSString * APPROVAL_REQUIRE_NAME_ERROR_DESCRIPTION = @"Your place needs to have a name. Please try again.";

static NSString * APPROVAL_REQUIRE_TYPE_ERROR_TITLE = @"Missing home information";
static NSString * APPROVAL_REQUIRE_TYPE_ERROR_DESCRIPTION = @"Your place needs to have a type. Please try again.";

static NSString * APPROVAL_REQUIRE_LOCATION_TITLE = @"Location required for your place";
static NSString * APPROVAL_REQUIRE_LOCATION_DESCRIPTION = @"Your place needs to have a location. Please try again.";

static NSString * APPROVAL_REQUIRE_PLACE_DESCRIPTION_TITLE = @"Missing home information";
static NSString * APPROVAL_REQUIRE_PLACE_DESCRIPTION_MESSAGE = @"Your place needs to have a description. Please try again.";

@interface MyPlaceDetailViewController ()
@property (nonatomic, strong) UIView *windowView;

@property (nonatomic, assign) CGFloat screenWidth;
@property (nonatomic, assign) CGFloat screenHeight;

@property (nonatomic, strong) JGActionSheet *photoPickerActionSheet;
@property (nonatomic, strong) JGActionSheet *photoEditActionSheet;
@property (nonatomic, strong) PhotoPicker *photoPicker;
@property (nonatomic, strong) CLCloudinary *cloudinary;
@property (nonatomic, strong) LoadingView *loadingView;

@property (nonatomic, strong) UIBarButtonItem *backButton;
@property (nonatomic, strong) UIButton *previewBt;
@property (nonatomic, strong) UIBarButtonItem *previewButton;

@property (nonatomic, strong) UITableView *placeDetailTableView;
@property (nonatomic, strong) MyPlaceDetailHeaderView *headerView;

@property (nonatomic, strong) EditableTableViewCell *addressCell;
@property (nonatomic, strong) EditableTableViewCell *homeInfoCell;
@property (nonatomic, strong) EditableTableViewCell *amenitiesCell;

@property (nonatomic, strong) UIView *importView;
@property (nonatomic, strong) UIButton *importViewCloseButton;
@property (nonatomic, strong) UILabel *importTitleLabel;
@property (nonatomic, strong) UIButton *importButton;

@end

@implementation MyPlaceDetailViewController
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
 * Lazily init the photo edit action sheet
 * @return JGActionSheet
 */
-(JGActionSheet *)photoEditActionSheet {
    if (_photoEditActionSheet == nil) {
        JGActionSheetSection *section1 = [JGActionSheetSection sectionWithTitle:nil message:nil buttonTitles:@[@"Set as cover photo", @"Edit photo's description", @"Remove from album"] buttonStyle:JGActionSheetButtonStyleDefault];
        JGActionSheetSection *cancelSection = [JGActionSheetSection sectionWithTitle:nil message:nil buttonTitles:@[@"Cancel"] buttonStyle:JGActionSheetButtonStyleCancel];
        
        _photoEditActionSheet = [JGActionSheet actionSheetWithSections:@[section1, cancelSection]];
        
        __weak typeof(self) weakSelf = self;
        [_photoEditActionSheet setButtonPressedBlock:^(JGActionSheet *sheet, NSIndexPath *indexPath) {
            if (indexPath.section == 0) {
                if (indexPath.row == 0) weakSelf.propertyObj[@"coverPic"] = weakSelf.headerView.currentPhotoObj[@"photoUrl"];
                else if (indexPath.row == 1) {
                    EditPhotoObjViewController *editPhotoViewController = [[EditPhotoObjViewController alloc] init];
                    editPhotoViewController.photoObj = weakSelf.headerView.currentPhotoObj;
                    [weakSelf.navigationController pushViewController:editPhotoViewController animated:YES];
                } else if (indexPath.row == 2) {
                    PFRelation *relation = [weakSelf.propertyObj relationForKey:@"photos"];
                    [relation removeObject:weakSelf.headerView.currentPhotoObj];
                    [weakSelf.propertyObj saveInBackground];
                    [weakSelf.headerView removeCurrentPhoto];
                }
            }
            [sheet dismissAnimated:YES];
        }];
    }
    return _photoEditActionSheet;
}

/**
 * Lazily init the photo picker obj
 * @return PhotoPicker
 */
-(PhotoPicker *)photoPicker {
    if (_photoPicker == nil) {
        _photoPicker = [[PhotoPicker alloc] initWithViewController:self];
        _photoPicker.editable = YES;
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
 * Lazily init the pushing button item
 * @return UIBarButtonItem
 */
-(UIBarButtonItem *)previewButton {
    if (_previewButton == nil) {
        self.previewBt = [[UIButton alloc] init];
        self.previewBt.titleLabel.font = [UIFont fontWithName:@"AvenirNext-Medium" size:14];
        [self.previewBt setTitle:@"Preview" forState:UIControlStateNormal];
        [self.previewBt setTitleColor:[FontColor themeColor] forState:UIControlStateNormal];
        [self.previewBt setTitleColor:[FontColor defaultBackgroundColor] forState:UIControlStateDisabled];
        [self.previewBt setTitleColor:[FontColor navigationButtonHighlightColor] forState:UIControlStateHighlighted];
        [self.previewBt sizeToFit];
        [self.previewBt addTarget:self action:@selector(previewButtonClick) forControlEvents:UIControlEventTouchUpInside];
        
        _previewButton = [[UIBarButtonItem alloc] initWithCustomView:self.previewBt];
    }
    return _previewButton;
}

/**
 * Lazily init the place's detail table view
 * @return UITableView
 */
-(UITableView *)placeDetailTableView {
    if (_placeDetailTableView == nil) {
        _placeDetailTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.screenWidth, self.screenHeight)];
        _placeDetailTableView.backgroundColor = [UIColor whiteColor];
        _placeDetailTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _placeDetailTableView.scrollEnabled = NO;
        _placeDetailTableView.delegate = self;
        _placeDetailTableView.dataSource = self;
    }
    return _placeDetailTableView;
}

/**
 * Lazily init the header view of the detail table
 * @return MyPlaceDetailHeaderView
 */
-(MyPlaceDetailHeaderView *)headerView {
    if (_headerView == nil) {
        _headerView = [[MyPlaceDetailHeaderView alloc] initWithFrame:CGRectMake(0, 64, self.screenWidth, 200)];
        _headerView.userInteractionEnabled = YES;
        _headerView.headerDelegate = self;
    }
    return _headerView;
}

/**
 * Lazily init the home info cell
 * @return EditableTableViewCell
 */
-(EditableTableViewCell *)homeInfoCell {
    if (_homeInfoCell == nil) {
        _homeInfoCell = [[EditableTableViewCell alloc] init];
        _homeInfoCell.titleLabel.text = @"Basic Info";
        _homeInfoCell.descriptionLabel.text = [self getPropertyInfoString];
        [_homeInfoCell setPlaceHolderText:@"Enter your home info"];
    }
    return _homeInfoCell;
}

/**
 * Lazily init the address cell in the table view
 * @return EditableTableViewCell
 */
-(EditableTableViewCell *)addressCell {
    if (_addressCell == nil) {
        _addressCell = [[EditableTableViewCell alloc] init];
        _addressCell.titleLabel.text = @"Address";
        if (self.propertyObj[@"fullLocation"]) _addressCell.descriptionLabel.text = self.propertyObj[@"fullLocation"];
        else if (self.propertyObj[@"location"]) _addressCell.descriptionLabel.text = self.propertyObj[@"location"];
        
        [_addressCell setPlaceHolderText:@"Enter your address"];
    }
    return _addressCell;
}

/**
 * Lazily init the amenities cell
 * @return EditableTableViewCell
 */
-(EditableTableViewCell *)amenitiesCell {
    if (_amenitiesCell == nil) {
        _amenitiesCell = [[EditableTableViewCell alloc] init];
        _amenitiesCell.titleLabel.text = @"Amenities";
        _amenitiesCell.descriptionLabel.text = @"Click to edit";
    }
    return _amenitiesCell;
}

/**
 * Lazily init the import view
 * @return UIView
 */
-(UIView *)importView {
    if (_importView == nil) {
        CGRect frame = CGRectMake(0, self.screenHeight - 150, self.screenWidth, 150);
        if ([Device isIphone4]) frame = CGRectMake(0, self.screenHeight - 66, self.screenWidth, 66);
        _importView = [[UIView alloc] initWithFrame:frame];
        _importView.backgroundColor = [FontColor backgroundOverlayColor];
        _importView.clipsToBounds = YES;
        _importView.transform = CGAffineTransformMakeTranslation(0, frame.size.height);
    }
    return _importView;
}

/**
 * Lazily init the import view close button
 * @return UIButton
 */
-(UIButton *)importViewCloseButton {
    if (_importViewCloseButton == nil) {
        _importViewCloseButton = [[UIButton alloc] initWithFrame:CGRectMake(self.screenWidth - 40, -10, 50, 50)];
        [_importViewCloseButton setImage:[UIImage imageNamed:CLOSE_BUTTON_NORMAL_IMAGE] forState:UIControlStateNormal];
        [_importViewCloseButton setImage:[UIImage imageNamed:CLOSE_BUTTON_HIGHLIGHT_IMAGE] forState:UIControlStateHighlighted];
        [_importViewCloseButton addTarget:self action:@selector(importCloseButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _importViewCloseButton;
}

/**
 * Lazily init the title text
 * @return UILabel
 */
-(UILabel *)importTitleLabel {
    if (_importTitleLabel == nil) {
        if (![Device isIphone4]) {
            _importTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 35, self.screenWidth, 30)];
            _importTitleLabel.font = [UIFont fontWithName:@"AvenirNext-Medium" size:15];
            _importTitleLabel.textAlignment = NSTextAlignmentCenter;
            _importTitleLabel.textColor = [UIColor whiteColor];
            _importTitleLabel.text = IMPORT_TITLE_TEXT;
        }
    }
    return _importTitleLabel;
}

/**
 * Lazily init the import button
 * @return UIButton
 */
-(UIButton *)importButton {
    if (_importButton == nil) {
        CGRect frame = CGRectMake((self.screenWidth - 250)/2, 80, 250, 50);
        if ([Device isIphone4]) frame = CGRectMake(25, 10, self.screenWidth - 50, 50);
        _importButton = [[UIButton alloc] initWithFrame:frame];
        _importButton.titleLabel.font = [UIFont fontWithName:@"AvenirNext-Medium" size:15];
        _importButton.layer.cornerRadius = 25;
        _importButton.layer.masksToBounds = YES;
        if ([Device isIphone4]) [_importButton setTitle:@"Import your place" forState:UIControlStateNormal];
        else [_importButton setTitle:@"Import" forState:UIControlStateNormal];
        [_importButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_importButton setBackgroundImage:[FontColor imageWithColor:[FontColor themeColor]] forState:UIControlStateNormal];
        [_importButton setBackgroundImage:[FontColor imageWithColor:[FontColor darkThemeColor]] forState:UIControlStateHighlighted];
        
        [_importButton addTarget:self action:@selector(importButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _importButton;
}

#pragma mark - private methods
/**
 * String for the property object info
 * @return NSString
 */
-(NSString *)getPropertyInfoString {
    NSMutableString *propertyInfo = [[NSMutableString alloc] init];
    if (self.propertyObj[@"listingType"])
        [propertyInfo stringByAppendingString:self.propertyObj[@"listingType"]];
    
    if (self.propertyObj[@"numBedrooms"]) {
        if (propertyInfo.length > 0) [propertyInfo stringByAppendingString:@" ∙ "];
        [propertyInfo stringByAppendingString: [self getDisplayableRoomNumber:self.propertyObj[@"numBedrooms"]]];
    }
    
    if (self.propertyObj[@"numBathrooms"]) {
        if (propertyInfo.length > 0) [propertyInfo stringByAppendingString:@" ∙ "];
        [propertyInfo stringByAppendingString: [self getDisplayableRoomNumber:self.propertyObj[@"numBathrooms"]]];
    }
    
    if (propertyInfo.length == 0 && self.propertyObj[@"name"]) propertyInfo = self.propertyObj[@"name"];
    
    return propertyInfo;
}

/**
 * Get displayable room number
 * @param nsnumber
 * @return nsstring
 */
-(NSString *)getDisplayableRoomNumber:(NSNumber *)roomNumberObj {
    float roomNumber = [roomNumberObj floatValue];
    if (roomNumber == (int)roomNumber)
        return [NSString stringWithFormat:@"%d", (int)roomNumber];
    else return [NSString stringWithFormat:@"%.1f", roomNumber];
}

#pragma mark - public methods
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.windowView = [[[[UIApplication sharedApplication] keyWindow] subviews] lastObject];
    self.screenWidth = [[UIScreen mainScreen] bounds].size.width;
    self.screenHeight = [[UIScreen mainScreen] bounds].size.height;
    self.title = VIEW_TITLE;
    self.navigationItem.leftBarButtonItem = [self backButton];
    self.navigationItem.rightBarButtonItem = [self previewButton];

    [self.view addSubview:[self placeDetailTableView]];
    [self.view addSubview:[self headerView]];
    if (self.propertyObj.objectId) {
        [Property getPhotosFromPropertyObject:self.propertyObj withCompletionHandler:^(NSArray *photos) {
            [self.headerView setPropertyPhotos:photos];
        }];
    } else {
        [self.headerView setPropertyPhotos:nil];
        [self.view addSubview:[self importView]];
        [self.importView addSubview:[self importViewCloseButton]];
        [self.importView addSubview:[self importTitleLabel]];
        [self.importView addSubview:[self importButton]];
        [UIView animateWithDuration:0.3 delay:0.5 options:UIViewAnimationOptionAllowAnimatedContent animations:^{
            self.importView.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            //do nothing for now
        }];
    }
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarHidden = NO;
    [self.navigationController setNavigationBarHidden:NO animated:false];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.propertyObj.objectId) [self.propertyObj saveInBackground];
}

/**
 * Set the place's location
 * @param SPGooglePlacesAutocompletePlace
 */
-(void)setLocation:(SPGooglePlacesAutocompletePlace *)place {
    [place resolveToPlacemark:^(CLPlacemark *location, NSString *addressString, NSError *error) {
        if (location && !error) {
            //now we update the new location
            NSDictionary *locationDictionary = location.addressDictionary;
            NSString *street = locationDictionary[@"Street"] ? locationDictionary[@"Street"] : nil;
            if (street == nil) street = locationDictionary[@"Name"] ? locationDictionary[@"Name"] : nil;
            
            NSMutableArray *descriptionArray = [[NSMutableArray alloc] init];
            if (locationDictionary[@"City"]) [descriptionArray addObject:locationDictionary[@"City"]];
            if (locationDictionary[@"State"]) [descriptionArray addObject:locationDictionary[@"State"]];
            if (locationDictionary[@"Country"]) [descriptionArray addObject:locationDictionary[@"Country"]];
            NSString *shortLocation = [descriptionArray componentsJoinedByString:@", "];
            
            if (shortLocation.length > 0) self.propertyObj[@"location"] = shortLocation;
            else if (street.length > 0) self.propertyObj[@"location"] = street;
            
            if (street.length > 0 && shortLocation.length > 0) {
                self.addressCell.descriptionLabel.text = [NSString stringWithFormat:@"%@, %@", street, shortLocation];
                self.propertyObj[@"fullLocation"] = self.addressCell.descriptionLabel.text;
            } else if (shortLocation.length > 0) {
                self.addressCell.descriptionLabel.text = shortLocation;
                self.propertyObj[@"fullLocation"] = shortLocation;
            }
            
            self.propertyObj[@"coordinate"] = [PFGeoPoint geoPointWithLocation:location.location];
            if (self.propertyObj.objectId) [self.placeDetailTableView reloadData];
            else [self reloadInformation];
        } else {
            [place getLocation:^(NSDictionary *location, NSString *addressString, NSError *error) {
                if (location[@"results"]) {
                    NSArray *locations = location[@"results"];
                    if (locations.count > 0) {
                        NSDictionary *firstMatch = locations[0];
                        NSString *mLoc = firstMatch[@"formatted_address"] ? firstMatch[@"formatted_address"] : @"";
                        self.propertyObj[@"location"] = mLoc;
                        self.propertyObj[@"fullLocation"] = mLoc;
                        self.addressCell.descriptionLabel.text = mLoc;
                        
                        NSDictionary *geometry = firstMatch[@"geometry"] ? firstMatch[@"geometry"] : nil;
                        NSDictionary *coordinate = (geometry && geometry[@"location"]) ? geometry[@"location"] : nil;
                        if (coordinate != nil && coordinate[@"lat"] && coordinate[@"lng"]) {
                            double lat = [coordinate[@"lat"] doubleValue];
                            double lng = [coordinate[@"lng"] doubleValue];
                            self.propertyObj[@"coordinate"] = [PFGeoPoint geoPointWithLatitude:lat longitude:lng];
                        }
                        if (self.propertyObj.objectId) [self.placeDetailTableView reloadData];
                        else [self reloadInformation];
                    }
                }
            }];
        }
    }];
}

/**
 * Set the new property object
 * @param PFObject
 */
-(void)setNewPropertyObj:(PFObject *)propertyObj {
    self.propertyObj = propertyObj;
    [self reloadInformation];
}

/**
 * Reload the data with the updated information
 */
-(void)reloadInformation {
    self.homeInfoCell.descriptionLabel.text = [self getPropertyInfoString];
    [self saveProperty];
}

/**
 * Save the property if needed
 */
-(void)saveProperty {
    if (self.propertyObj.objectId == nil) {
        [self.propertyObj saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            self.view.userInteractionEnabled =  YES;
            [[UserManager sharedUserManager] addUserProperty:self.propertyObj];
            [self.propertyObj pinInBackgroundWithName:@"places"];
            [self.placeDetailTableView reloadData];
        }];
        [UIView animateWithDuration:0.3 animations:^{
            self.importView.transform = CGAffineTransformMakeTranslation(0, self.importView.frame.size.height);
        }];
    } else {
        [self.placeDetailTableView reloadData];
        [self.propertyObj saveInBackground];
    }
}

#pragma mark - header delegate
-(void)addNewPhoto {
    [[self photoPickerActionSheet] showInView:self.windowView animated:YES];
}

-(void)editCurrentPhoto {
    [[self photoEditActionSheet] showInView:self.windowView animated:YES];
}

#pragma mark - click listener and delegate
/**
 * Handle the behavior when the user click on the back button
 */
-(void)goBack {
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 * Handle the behavior when user click on the close button in import view
 */
-(void)importCloseButtonClick {
    [UIView animateWithDuration:0.3 animations:^{
        self.importView.transform = CGAffineTransformMakeTranslation(0, self.importView.frame.size.height);
    } completion:^(BOOL finished) {
        if (finished) [self.importView removeFromSuperview];
    }];
}

/**
 * Handle the behavior when user click on the import button
 */
-(void)importButtonClick {
    ImportSelectionViewController *importSelectionViewController = [[ImportSelectionViewController alloc] init];
    [self.navigationController pushViewController:importSelectionViewController animated:YES];
}

/**
 * Handle the behavior when user click on the preview button
 */
-(void)previewButtonClick {
    NSString *location = self.propertyObj[@"location"] ? self.propertyObj[@"location"] : @"";
    NSString *coverPic = self.propertyObj[@"coverPic"] ? self.propertyObj[@"coverPic"] : @"";
    NSString *placeType = self.propertyObj[@"listingType"] ? self.propertyObj[@"listingType"] : @"";
    NSString *name = self.propertyObj[@"name"] ? self.propertyObj[@"name"] : @"";
    NSString *placeDescription = self.propertyObj[@"fullDescription"] ? self.propertyObj[@"fullDescription"] : @"";
    
    if (location.length == 0) {
        [ErrorMessageDisplay displayErrorAlertOnViewController:self withTitle:APPROVAL_REQUIRE_LOCATION_TITLE andMessage:APPROVAL_REQUIRE_LOCATION_DESCRIPTION];
    } else if (coverPic.length == 0) {
        [ErrorMessageDisplay displayErrorAlertOnViewController:self withTitle:APPROVAL_REQUIRE_IMAGE_ERROR_TITLE andMessage:APPROVAL_REQUIRE_IMAGE_ERROR_DESCRIPTION];
    } else if (placeType.length == 0) {
        [ErrorMessageDisplay displayErrorAlertOnViewController:self withTitle:APPROVAL_REQUIRE_TYPE_ERROR_TITLE andMessage:APPROVAL_REQUIRE_TYPE_ERROR_DESCRIPTION];
    } else if (name.length == 0) {
        [ErrorMessageDisplay displayErrorAlertOnViewController:self withTitle:APPROVAL_REQUIRE_NAME_ERROR_TITLE andMessage:APPROVAL_REQUIRE_NAME_ERROR_DESCRIPTION];
    } else if (placeDescription.length == 0) {
        [ErrorMessageDisplay displayErrorAlertOnViewController:self withTitle:APPROVAL_REQUIRE_PLACE_DESCRIPTION_TITLE andMessage:APPROVAL_REQUIRE_PLACE_DESCRIPTION_MESSAGE];
    } else {
        MyPlaceReviewViewController *reviewViewController = [[MyPlaceReviewViewController alloc] init];
        reviewViewController.capturedBackground = [Device captureScreenshot];
        reviewViewController.propertyObj = self.propertyObj;
        [self.navigationController pushViewController:reviewViewController animated:NO];
    }
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
-(void)uploadImage:(UIImage *)image withDescription:(NSString *)description {
    [self dismissViewControllerAnimated:YES completion:^{
        [[self loadingView] showInView:self.windowView];
        
        CLUploader *photoUploader = [[CLUploader alloc] init:[self cloudinary] delegate:nil];
        
        UIImage *scaledImage = [image scaleToSizeKeepAspect:CGSizeMake(1440, 1440)];
        NSData* data = UIImageJPEGRepresentation(scaledImage, 0.8);
        [photoUploader upload:data options:nil withCompletion:^(NSDictionary *successResult, NSString *errorResult, NSInteger code, id context) {
            if (successResult) {
                NSString *currentCoverPic = self.propertyObj[@"coverPic"] ? self.propertyObj[@"coverPic"] : @"";
                if (currentCoverPic.length == 0) self.propertyObj[@"coverPic"] = successResult[@"url"];
                
                PFObject *photoObj = [PFObject objectWithClassName:@"PropertyPhoto"];
                photoObj[@"photoUrl"] = successResult[@"url"];
                photoObj[@"photoDescription"] = (description.length > 0) ? description : @"";
                [photoObj saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (!error) {
                        PFRelation *relation = [self.propertyObj relationForKey:@"photos"];
                        [relation addObject:photoObj];
                        [self.headerView appendPhoto:photoObj];
                        if (self.propertyObj.objectId == nil) [self saveProperty];
                        else [self.propertyObj saveInBackground];
                    }
                    [self.loadingView dismiss];
                }];
            
            } else {
                [self.loadingView dismiss];
                [ErrorMessageDisplay displayErrorAlertOnViewController:self withTitle:PHOTO_UPLOAD_FAIL_TITLE andMessage:PHOTO_UPLOAD_FAIL_DESCRIPTION];
            }
        } andProgress:^(NSInteger bytesWritten, NSInteger totalBytesWritten, NSInteger totalBytesExpectedToWrite, id context) {}];
    }];
}

#pragma mark - table view delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 200;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
            return [self homeInfoCell];
        
        case 1:
            return [self addressCell];
        
        default:
            return [self amenitiesCell];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        MyPlaceInfoViewController *infoViewController = [[MyPlaceInfoViewController alloc] init];
        infoViewController.propertyObj = self.propertyObj;
        [self.navigationController pushViewController:infoViewController animated:YES];
    } else if (indexPath.row == 1) {
        MyPlaceLocationViewController *locationViewController = [[MyPlaceLocationViewController alloc] init];
        locationViewController.placeLocation = self.addressCell.descriptionLabel.text;
        [self.navigationController pushViewController:locationViewController animated:YES];
    } else if (indexPath.row == 2) {
        MyPlaceAmenityViewController *amenityViewController = [[MyPlaceAmenityViewController alloc] init];
        amenityViewController.amenityObj =self.propertyObj[@"amenity"];
        [self.navigationController pushViewController:amenityViewController animated:YES];
    }
}

@end
