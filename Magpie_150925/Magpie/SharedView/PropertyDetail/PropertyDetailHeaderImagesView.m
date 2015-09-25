//
//  PropertyDetailHeaderImagesView.m
//  Magpie
//
//  Created by minh thao nguyen on 2/16/15.
//  Copyright (c) 2015 Easyswap Inc. All rights reserved.
//

#import "PropertyDetailHeaderImagesView.h"
#import "FontColor.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "ImageUrl.h"
#import "ParsingText.h"
#import "UIScrollWebImageView.h"

@interface PropertyDetailHeaderImagesView()
@property (nonatomic, strong) NSString *propertyCoverUrl;
@property (nonatomic, strong) NSMutableArray *propertyImageViewsArray;
@property (nonatomic, strong) NSArray *photos;
@property (nonatomic, strong) NSMutableArray *propertyLabels;
@property (nonatomic, strong) UILabel *currentPageLabel;
@property (nonatomic, strong) UILabel *descriptionLabel;
@end

@implementation PropertyDetailHeaderImagesView
#pragma mark - initiation
/**
 * Init the current page label
 * @return current page label;
 */
-(UILabel *)currentPageLabel {
    if (_currentPageLabel == nil) {
        _currentPageLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width - 50, 30, 50, 25)];
        _currentPageLabel.backgroundColor = [UIColor colorWithWhite:0 alpha:0.85];
        _currentPageLabel.textAlignment = NSTextAlignmentCenter;
        _currentPageLabel.textColor = [UIColor whiteColor];
        _currentPageLabel.font = [UIFont fontWithName:@"AvenirNext-Medium" size:12];
        _currentPageLabel.hidden = YES;
    }
    return _currentPageLabel;
}

/**
 * Lazily init the description label
 * @return label
 */
-(UILabel *)descriptionLabel {
    if (_descriptionLabel == nil) {
        _descriptionLabel = [[UILabel alloc] init];
        _descriptionLabel.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
        _descriptionLabel.textColor = [UIColor whiteColor];
        _descriptionLabel.textAlignment = NSTextAlignmentCenter;
        _descriptionLabel.font = [UIFont fontWithName:@"AvenirNext-Medium" size:14];
        _descriptionLabel.numberOfLines = 3;
        _descriptionLabel.hidden = YES;
        _descriptionLabel.alpha = 0;
    }
    return _descriptionLabel;
}


#pragma mark - public methods
-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.contentSize = CGSizeMake(self.frame.size.width, self.frame.size.height);
        self.delegate = self;
        self.backgroundColor = [FontColor tableSeparatorColor];
        self.scrollsToTop = NO;
        self.pagingEnabled = YES;
        self.userInteractionEnabled = YES;
        self.clipsToBounds = YES;
        self.scrollEnabled = YES;
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        
        
        self.propertyImageViewsArray = [[NSMutableArray alloc] init];
        self.propertyLabels = [[NSMutableArray alloc] init];
        
        [self addSubview:[self currentPageLabel]];
        [self addSubview:[self descriptionLabel]];
        
        UITapGestureRecognizer *imageTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headerTap)];
        [imageTap setNumberOfTapsRequired:1];
        [self addGestureRecognizer:imageTap];
    }
    return self;
}

-(void)dealloc {
    self.delegate = nil;
}

/**
 * Reset the frame of the scroll view. When reset, also reset all the contained image view
 * @param frame
 */
-(void)setViewFrame:(CGRect)frame {
    self.frame = frame;
    self.contentSize = CGSizeMake(self.contentSize.width, frame.size.height);
    for (UIScrollWebImageView *image in self.propertyImageViewsArray) {
        [image setViewFrame:CGRectMake(image.frame.origin.x, 0, image.frame.size.width, frame.size.height)];
    }
    
    self.currentPageLabel.frame = CGRectMake(self.currentPageLabel.frame.origin.x, 30 - frame.origin.y, 50, 25);
}

/**
 * Set the property photos. Called from the parent class
 * @param photos
 */
-(void)setPropertyPhotos:(NSArray *)photos {
    if (self.propertyImageViewsArray.count <= 1) {
        self.photos = photos;
        self.backgroundColor = [UIColor whiteColor];
        
        for (UIScrollWebImageView *image in self.propertyImageViewsArray) {
            [image removeView];
        }
        
        [self.propertyImageViewsArray removeAllObjects];
        [self.propertyLabels removeAllObjects];
        
        self.contentSize = CGSizeMake(self.frame.size.width * photos.count, self.frame.size.height);
        [self setContentOffset:CGPointMake(0, 0) animated:NO];
        
        int index = 0;
        
        for (int i = 0; i < photos.count; i++) {
            PFObject *photoObj = [photos objectAtIndex:i];
            UIScrollWebImageView *photoView = [self getImageViewAtIndex:i andUrl:photoObj[@"photoUrl"]];
            [self.propertyImageViewsArray addObject:photoView];
            [self addSubview:photoView];
            
            NSString *photoDescription = [ParsingText getTrimmedPhotoDescriptionFromDescription:photoObj[@"photoDescription"]];
            NSString *labelDescription = (photoDescription.length > 0) ? [NSString stringWithFormat:@"%d/%d %@", i + 1, (int)photos.count, photoDescription] : [NSString stringWithFormat:@"%d/%d", i + 1, (int)photos.count];
            [self.propertyLabels addObject:labelDescription];
            
            if ([photoObj[@"photoUrl"] isEqualToString:self.propertyCoverUrl]) {
                [self setContentOffset:CGPointMake(self.frame.size.width * i, 0) animated:NO];
                index = i;
            }
        }
        
        if (self.currentPageLabel == nil) [self addSubview:[self currentPageLabel]];
        else [self bringSubviewToFront:self.currentPageLabel];
        self.currentPageLabel.text = [NSString stringWithFormat:@"%d/%d", index + 1, (int)photos.count];
        
        if (self.descriptionLabel == nil) [self addSubview:[self descriptionLabel]];
        else [self bringSubviewToFront:self.descriptionLabel];
        [self formatLabelViewForPhotoAtIndex:0];
    }
}

/**
 * Set the cover photo
 * @param photo
 */
-(void)setCoverPhoto:(NSString *)url {
    self.propertyCoverUrl = url;
    self.contentSize = CGSizeMake(self.frame.size.width, self.frame.size.height);
    for (UIScrollWebImageView *image in self.propertyImageViewsArray) {
        [image removeFromSuperview];
    }
    
    [self.propertyImageViewsArray removeAllObjects];
    [self.propertyLabels removeAllObjects];
    
    self.currentPageLabel.hidden = NO;
    self.descriptionLabel.hidden = NO;
    
    UIScrollWebImageView *image = [self getImageViewAtIndex:0 andUrl:url];
    [self.propertyImageViewsArray addObject:image];
    [self addSubview:image];
    
    [self.propertyLabels addObject:@"loading"];
    self.currentPageLabel.text = @"loading";
    [self formatLabelViewForPhotoAtIndex:0];
    
    [self bringSubviewToFront:self.currentPageLabel];
    [self bringSubviewToFront:self.descriptionLabel];
    [self setContentOffset:CGPointMake(0, 0) animated:NO];
}

/**
 * Show the property description
 */
-(void)showPropertyDescription:(BOOL)shouldShow {
    self.currentPageLabel.alpha = !shouldShow;
    self.descriptionLabel.alpha = shouldShow;
    for (UIScrollWebImageView *image in self.propertyImageViewsArray) {
        [image enableZooming:shouldShow];
    }
}

#pragma mark - private support method
/**
 * get the image view by given its starting index and the url
 * @param index
 * @param url
 * @return image
 */
-(UIScrollWebImageView *)getImageViewAtIndex:(int)index andUrl:(NSString *)url {
    UIScrollWebImageView *image = [[UIScrollWebImageView alloc] initWithFrame:CGRectMake(index * self.frame.size.width, 0, self.frame.size.width, self.frame.size.height)];
    image.didLoadFullImage = (index == 0);
    
    if (url.length > 0) {
        if ([url isEqualToString:self.propertyCoverUrl]) {
            [image setImageUrl:[ImageUrl propertyImageUrlFromUrl:url]];
            image.didLoadFullImage = YES;
        } else [image setImageUrl:[ImageUrl lowQualityPropertyImageUrlFromUrl:url]];
    } else [image setImage:[UIImage imageNamed:@"NoPropertyImage"]];
    
    return image;
}

/**
 * format label for the photo at given index
 * @param index
 */
-(void)formatLabelViewForPhotoAtIndex:(int)index {
    float screenHeight = [[UIScreen mainScreen] bounds].size.height;
    
    if (index < self.propertyLabels.count && index >= 0) {
        self.descriptionLabel.text = [self.propertyLabels objectAtIndex:index];
        float textViewHeight = [self.descriptionLabel sizeThatFits:CGSizeMake(self.frame.size.width, FLT_MAX)].height;
        self.descriptionLabel.frame = CGRectMake(self.descriptionLabel.frame.origin.x, screenHeight - textViewHeight - 10, self.frame.size.width, textViewHeight + 10);
    }
}

/**
 * Selector for when the image was tapped
 * @param gesture recognizer
 */
-(void)headerTap {
    [self.headerDelegate propertyHeaderClicked];
}

#pragma mark - scrollview delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    self.contentOffset = CGPointMake(scrollView.contentOffset.x, 0);
    self.currentPageLabel.frame = CGRectMake(self.frame.size.width - 50 + scrollView.contentOffset.x, 30, 50, 25);
    self.descriptionLabel.frame = CGRectMake(scrollView.contentOffset.x, self.descriptionLabel.frame.origin.y, self.descriptionLabel.frame.size.width, self.descriptionLabel.frame.size.height);
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    int currentPage = [self getCurrentPage];
    if (currentPage > 0 && currentPage <= self.propertyImageViewsArray.count) {
        self.currentPageLabel.text = [NSString stringWithFormat:@"%d/%d", currentPage, (int)self.propertyImageViewsArray.count];
        [self formatLabelViewForPhotoAtIndex:currentPage - 1];
        
        UIScrollWebImageView *currentImageView = self.propertyImageViewsArray[currentPage - 1];
        if (!currentImageView.didLoadFullImage) {
            currentImageView.didLoadFullImage = YES;
            PFObject *photoObj = [self.photos objectAtIndex:currentPage - 1];
            [currentImageView setImageUrl:[ImageUrl propertyImageUrlFromUrl:photoObj[@"photoUrl"]]];
        }
    }
}

-(int)getCurrentPage {
    return self.contentOffset.x/self.frame.size.width + 1;
}

@end