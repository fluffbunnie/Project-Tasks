//
//  ViewController.m
//  GuidedCommunication
//
//  Created by minh thao nguyen on 4/4/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import "ViewController.h"
#import "GuidedCommunicationTripDetailViewController.h"
#import "FontColor.h"

@interface ViewController ()
@property (nonatomic, strong) UIButton *tripDetailButton;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    float screenWidth = [[UIScreen mainScreen] bounds].size.width;
    self.tripDetailButton = [[UIButton alloc] initWithFrame:CGRectMake(30, 100, screenWidth - 60, 50)];
    [self.tripDetailButton setTitle:@"Trip Detail" forState:UIControlStateNormal];
    [self.tripDetailButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.tripDetailButton setBackgroundColor:[FontColor themeColor]];
    [self.tripDetailButton addTarget:self action:@selector(goToTripDetail) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.tripDetailButton];
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)goToTripDetail {
    GuidedCommunicationTripDetailViewController *tripDetailModalView = [[GuidedCommunicationTripDetailViewController alloc] init];
    //here, we set the trip detail information
    tripDetailModalView.guestType = GUEST_TYPE_UNDEFINE;
    [self.navigationController presentViewController:tripDetailModalView animated:YES completion:nil];
}

@end
