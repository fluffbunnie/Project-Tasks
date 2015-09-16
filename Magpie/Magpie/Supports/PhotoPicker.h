//
//  PhotoPicker.h
//  Magpie
//
//  Created by minh thao nguyen on 5/5/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>

@protocol PhotoPickerDelegate <NSObject>
@optional
-(void)uploadImage:(UIImage *)image;
-(void)uploadImage:(UIImage *)image withDescription:(NSString *)description;
@end

@interface PhotoPicker : NSObject <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, weak) id<PhotoPickerDelegate> photoPickerDelegate;
@property (nonatomic, assign) BOOL editable;

-(id)initWithViewController:(UIViewController *)controller;
-(void)showMediaBrowser;
@end
