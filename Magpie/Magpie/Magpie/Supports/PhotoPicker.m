//
//  PhotoPicker.m
//  Magpie
//
//  Created by minh thao nguyen on 5/5/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import "PhotoPicker.h"
#import "PickerViewController.h"

@interface PhotoPicker()
@property (nonatomic, strong) UIViewController *parentViewController;
@property (nonatomic, strong) UIImagePickerController *imagePickerController;
@end

@implementation PhotoPicker
#pragma mark - initation
/**
 * Lazily init the image picker controller
 * @return UIImagePickerController
 */
-(UIImagePickerController *)imagePickerController {
    if (_imagePickerController == nil) {
        _imagePickerController = [[UIImagePickerController alloc] init];
        _imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        _imagePickerController.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeImage, nil];
        _imagePickerController.allowsEditing = NO;
        _imagePickerController.delegate = self;
    }
    return _imagePickerController;
}

#pragma mark - public method
-(id)initWithViewController:(UIViewController *)controller {
    self = [super init];
    if (self) {
        self.parentViewController = controller;
        [self imagePickerController];
    }
    return self;
}

/**
 * Show the media browser 
 */
-(void)showMediaBrowser {
    [self.parentViewController presentViewController:self.imagePickerController animated:YES completion:^{}];
}

#pragma mark - image picker delegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *imagePicked = (UIImage *)[info objectForKey:UIImagePickerControllerOriginalImage];
    
    PickerViewController *pickerViewController = [[PickerViewController alloc] init];
    pickerViewController.editable = self.editable;
    pickerViewController.pickedImage = imagePicked;
    pickerViewController.pickerRef = self;
    [picker pushViewController:pickerViewController animated:YES];
}

@end
