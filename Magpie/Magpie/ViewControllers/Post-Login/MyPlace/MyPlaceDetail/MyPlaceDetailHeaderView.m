//
//  MyPlaceDetailHeaderView.m
//  Magpie
//
//  Created by minh thao nguyen on 5/11/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import "MyPlaceDetailHeaderView.h"
#import "MyPlaceDetailHeaderNoPhotoButton.h"
#import "FontColor.h"
#import "ImageUrl.h"
#import <SDWebImage/UIImageView+WebCache.h>

static NSString * HEADER_MASK = @"PropertyImageMask";
static NSString * PROFILING_PHOTO_ICON = @"ProfilingPhotoIcon";
static NSString * PROFILING_PHOTO_ICON_WITH_BORDER = @"ProfilingPhotoIconWithBorder";

@interface MyPlaceDetailHeaderView()
@property (nonatomic, assign) CGFloat viewWidth;
@property (nonatomic, assign) CGFloat viewHeight;

@property (nonatomic, strong) MyPlaceDetailHeaderNoPhotoButton *noPhotoView;
@property (nonatomic, strong) UIView *photosContainerView;
@property (nonatomic, strong) UIScrollView *photosScrollView;
@property (nonatomic, strong) UIButton *addPhotoButton;

@property (nonatomic, strong) NSMutableArray *photos;
@property (nonatomic, strong) NSMutableArray *photoImages;
@end

@implementation MyPlaceDetailHeaderView
#pragma mark - initiation
/**
 * Lazily init the no photo view
 * @return UIButton
 */
-(MyPlaceDetailHeaderNoPhotoButton *)noPhotoView {
    if (_noPhotoView == nil) {
        _noPhotoView = [[MyPlaceDetailHeaderNoPhotoButton alloc] initWithFrame:CGRectMake(0, 0, self.viewWidth, self.viewHeight)];
        [_noPhotoView addTarget:self action:@selector(addNewPhoto) forControlEvents:UIControlEventTouchUpInside];
        _noPhotoView.hidden = YES;
    }
    return _noPhotoView;
}

/**
 * Lazily init the photos container view
 * @return UIView
 */
-(UIView *)photosContainerView {
    if (_photosContainerView == nil) {
        _photosContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.viewWidth, self.viewHeight)];
        _photosContainerView.backgroundColor = [FontColor tableSeparatorColor];
    }
    return _photosContainerView;
}

/**
 * Lazily init the photo scroll view
 * @return UIScrollView
 */
-(UIScrollView *)photosScrollView {
    if (_photosScrollView == nil) {
        _photosScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.viewWidth, self.viewHeight)];
        _photosScrollView.contentSize = CGSizeMake(self.viewWidth, self.viewHeight);
        _photosScrollView.scrollsToTop = NO;
        _photosScrollView.pagingEnabled = YES;
        _photosScrollView.clipsToBounds = YES;
        _photosScrollView.showsHorizontalScrollIndicator = NO;
        _photosScrollView.showsVerticalScrollIndicator = NO;
        _photosScrollView.delegate = self;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editPhoto)];
        [_photosScrollView addGestureRecognizer:tap];
    }
    return _photosScrollView;
}

/**
 * Lazily init the add photo button
 * @return UIButton
 */
-(UIButton *)addPhotoButton {
    if (_addPhotoButton == nil) {
        _addPhotoButton = [[UIButton alloc] initWithFrame:CGRectMake(self.viewWidth - 45, self.viewHeight - 45, 30, 25)];
        [_addPhotoButton setImage:[UIImage imageNamed:PROFILING_PHOTO_ICON_WITH_BORDER] forState:UIControlStateNormal];
        [_addPhotoButton addTarget:self action:@selector(addNewPhoto) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addPhotoButton;
}

#pragma mark - public methods
-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.viewWidth = frame.size.width;
        self.viewHeight = frame.size.height;
        self.backgroundColor = [UIColor whiteColor];
        self.clipsToBounds = YES;
        self.photos = [[NSMutableArray alloc] init];
        self.photoImages = [[NSMutableArray alloc] init];
        
        CALayer *maskLayer = [CALayer layer];
        maskLayer.contents = (id)[[UIImage imageNamed:HEADER_MASK] CGImage];
        maskLayer.frame = CGRectMake(0, 0, self.viewWidth, self.viewHeight);
        self.layer.mask = maskLayer;
        self.layer.masksToBounds = YES;

        [self addSubview:[self photosContainerView]];
        [self.photosContainerView addSubview:[self photosScrollView]];
        [self.photosContainerView addSubview:[self addPhotoButton]];
        [self addSubview:[self noPhotoView]];
    }
    return self;
}

/**
 * Set the photos to be display
 * @param photo
 */
-(void)setPropertyPhotos:(NSArray *)photos {
    for (UIView *subview in [[self photosScrollView] subviews]) {
        [subview removeFromSuperview];
        self.photosScrollView.contentSize = CGSizeMake(self.viewWidth, self.viewHeight);
    }
    
    self.photos = (photos.count > 0) ? [NSMutableArray arrayWithArray:photos] : [[NSMutableArray alloc] init];
    self.photoImages = [[NSMutableArray alloc] init];
    self.photosScrollView.contentOffset = CGPointMake(0, 0);
    self.photosScrollView.contentSize = CGSizeMake(MAX(1, self.photos.count) * self.viewWidth, self.viewHeight);
    
    self.noPhotoView.hidden = (self.photos.count != 0);
    self.currentPhotoObj = (self.photos.count > 0) ? self.photos[0] : nil;
    
    for (int i = 0; i < self.photos.count; i++) {
        [self addImageWithPhotoObj:self.photos[i] atIndex:i];
    }
}

/**
 * Append a new photo at the end of the photo scroll view
 * @param PFObject
 */
-(void)appendPhoto:(PFObject *)photoObj {
    self.noPhotoView.hidden = YES;
    [self.photos addObject:photoObj];
    self.photosScrollView.contentSize = CGSizeMake(self.photos.count * self.viewWidth, self.viewHeight);
    [self addImageWithPhotoObj:photoObj atIndex:(int)self.photos.count - 1];
}

/**
 * Add a photo object to the scroll view at the given index
 * @param PFObject
 * @param int
 */
-(void)addImageWithPhotoObj:(PFObject *)photoObj atIndex:(int)index {
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.viewWidth * index, 0, self.viewWidth, self.viewHeight)];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    NSString *url = [ImageUrl housePhotoImageUrlFromUrl:photoObj[@"photoUrl"]];
    [imageView setImageWithURL:[NSURL URLWithString:url]];
    
    [self.photosScrollView addSubview:imageView];
    [self.photoImages addObject:imageView];
}

/**
 * Remove the current photo
 */
-(void)removeCurrentPhoto {
    int currentPage = [self getCurrentPage];
    [self.photos removeObject:self.currentPhotoObj];
    [((UIImageView *)self.photoImages[currentPage]) removeFromSuperview];
    for (int i = currentPage + 1; i < self.photos.count; i++) {
        UIImageView *image = self.photoImages[i];
        CGRect imageFrame = CGRectMake(image.frame.origin.x - self.viewWidth, 0, self.viewWidth, self.viewHeight);
        image.frame = imageFrame;
    }
    [self.photoImages removeObjectAtIndex:currentPage];
    self.photosScrollView.contentSize = CGSizeMake(self.photosScrollView.contentSize.width - self.viewWidth, self.photosScrollView.contentSize.height);
    
    if (self.photoImages.count == 0) self.noPhotoView.hidden = NO;
    else {
        if (currentPage >= self.photoImages.count) {
            //we moved back a screen
            self.photosScrollView.contentOffset = CGPointMake(self.photosScrollView.contentOffset.x - self.viewWidth, 0);
        }
    }
}

#pragma mark - UI action
/**
 * Add a new photo to the list of photos
 */
-(void)addNewPhoto {
    [self.headerDelegate addNewPhoto];
}

/**
 * Edit the current viewing photo
 */
-(void)editPhoto {
    if (self.currentPhotoObj) [self.headerDelegate editCurrentPhoto];
}

#pragma mark - scrollview delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    self.photosScrollView.contentOffset = CGPointMake(self.photosScrollView.contentOffset.x, 0);
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.currentPhotoObj = self.photos[[self getCurrentPage]];
}

-(int)getCurrentPage {
    return MIN(MAX(0, self.photosScrollView.contentOffset.x/self.viewWidth), self.photos.count - 1);
}

@end
