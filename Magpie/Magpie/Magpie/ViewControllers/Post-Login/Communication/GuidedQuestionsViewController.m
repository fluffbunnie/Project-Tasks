//
//  GuidedQuestionsViewController.m
//  Magpie
//
//  Created by minh thao nguyen on 4/23/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import "GuidedQuestionsViewController.h"
#import "FontColor.h"
#import "TTTAttributedLabel.h"

static NSString * NAVIGATION_BAR_BACK_ICON_NAME = @"NavigationBarBackIconRed";
static NSString * TITLE = @"Suggested questions";

static NSString * HEADER_TEXT = @"First-timer? Just tap to ask.";
static NSString * FIRST_SECTION_HEADER_NAME = @"GENERAL";
static NSString * SECOND_SECTION_HEADER_NAME = @"GUEST";
static NSString * THIRD_SECTION_HEADER_NAME = @"HOST";
static NSString * FOURTH_SECTION_HEADER_NAME = @"PLACE";
static NSString * FIFTH_SECTION_HEADER_NAME = @"NEIGHBORHOOD";

@interface GuidedQuestionsViewController ()
@property (nonatomic, assign) CGFloat screenWidth;

@property (nonatomic, strong) NSMutableArray *questionsArray;
@property (nonatomic, strong) UIBarButtonItem *backButton;
@property (nonatomic, strong) UILabel *headerView;
@end

@implementation GuidedQuestionsViewController
#pragma mark - initiation
/**
 * Lazily init the question array
 * @return NSMutableArray
 */
-(NSMutableArray *)questionsArray {
    if (_questionsArray == nil) {
        _questionsArray = [[NSMutableArray alloc] init];
        
        NSArray *generalQuestions = [[NSArray alloc] initWithObjects:@"How long have you been living in the city?", @"Have you hosted or been hosted before? How was it?", @"What’s the best time to visit the city?", nil];
        
        NSArray *guestQuestions = [[NSArray alloc] initWithObjects:@"Are you interested in visitng my place as well?", @"Can I have a friend over?", @"How can I help you before I leave?", nil];
        
        NSArray *hostQuestions = [[NSArray alloc] initWithObjects:@"Why are you in town?", @"When would you arrive at my place?", @"How many people will be staying?", nil];
        
        NSArray *placeQuestions = [[NSArray alloc] initWithObjects:@"How far is your place from Downtown?", @"What’s the best way to get to your house from the airport?", @"Where can I park my car?", nil];
        
        NSArray *neighborhoodQuestions = [[NSArray alloc] initWithObjects:@"Is there a grocery store nearby?", @"What are fun things I can do in your area?", @"Is public transportation close by?", nil];
        
        [_questionsArray addObject:generalQuestions];
        [_questionsArray addObject:guestQuestions];
        [_questionsArray addObject:hostQuestions];
        [_questionsArray addObject:placeQuestions];
        [_questionsArray addObject:neighborhoodQuestions];
    }
    return _questionsArray;
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
 * Lazily init the header view
 * @return UILabel
 */
-(UILabel *)headerView {
    if (_headerView == nil) {
        _headerView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.screenWidth, 90)];
        _headerView.textAlignment = NSTextAlignmentCenter;
        _headerView.textColor = [FontColor descriptionColor];
        _headerView.text = @"First-timer? Just tap to ask.";
        _headerView.font = [UIFont fontWithName:@"AvenirNext-Regular" size:15];
    }
    return _headerView;
}

#pragma mark - public method
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [self backButton];
    self.title = TITLE;
    self.screenWidth = [[UIScreen mainScreen] bounds].size.width;
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.tableHeaderView = [self headerView];
    self.tableView.separatorColor = [FontColor tableSeparatorColor];
    self.tableView.separatorInset = UIEdgeInsetsZero;
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarHidden = NO;
    [self.navigationController setNavigationBarHidden:NO animated:false];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

#pragma mark - UIAction
-(void)goBack {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -table view
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self questionsArray].count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return ((NSArray *)[self questionsArray][section]).count;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.screenWidth, 40)];
    view.backgroundColor = [FontColor tableSeparatorColor];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, self.screenWidth - 40, 40)];
    titleLabel.font = [UIFont fontWithName:@"AvenirNext-DemiBold" size:11];
    titleLabel.textColor = [FontColor descriptionColor];
    switch (section) {
        case 0:
            titleLabel.text = FIRST_SECTION_HEADER_NAME;
            break;
        
        case 1:
            titleLabel.text = SECOND_SECTION_HEADER_NAME;
            break;
        
        case 2:
            titleLabel.text = THIRD_SECTION_HEADER_NAME;
            break;
            
        case 3:
            titleLabel.text = FOURTH_SECTION_HEADER_NAME;
            break;
            
        case 4:
            titleLabel.text = FIFTH_SECTION_HEADER_NAME;
            break;
            
        default:
            break;
    }
    
    [view addSubview:titleLabel];
    
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *question = [self questionsArray][indexPath.section][indexPath.row];
    CGFloat height = [self heightForQuestion:question];
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    
    TTTAttributedLabel *label = [[TTTAttributedLabel alloc] initWithFrame:CGRectMake(20, 0, self.screenWidth - 40, height)];
    label.font = [UIFont fontWithName:@"AvenirNext-Regular" size:15];
    label.textColor = [FontColor titleColor];
    label.lineSpacing = 5;
    label.numberOfLines = 0;
    label.text = question;
    [cell.contentView addSubview:label];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *question = [self questionsArray][indexPath.section][indexPath.row];
    return [self heightForQuestion:question];
}

-(CGFloat)heightForQuestion:(NSString *)question {
    TTTAttributedLabel *sampleLabel = [[TTTAttributedLabel alloc] init];
    sampleLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:15];
    sampleLabel.lineSpacing = 5;
    sampleLabel.numberOfLines = 0;
    sampleLabel.text = question;
    CGSize size = [sampleLabel sizeThatFits:CGSizeMake(self.screenWidth - 40, FLT_MAX)];
    return 30 + size.height;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *question = [self questionsArray][indexPath.section][indexPath.row];
    self.chatController.suggestedQuestions = question;
    [self.navigationController popViewControllerAnimated:YES];
    
}



@end
