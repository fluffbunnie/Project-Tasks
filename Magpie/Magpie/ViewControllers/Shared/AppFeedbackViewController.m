//
//  AppFeedbackViewController.m
//  Magpie
//
//  Created by minh thao nguyen on 4/23/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import "AppFeedbackViewController.h"
#import "FloatPlaceholderTextView.h"
#import "FontColor.h"
#import "UIVerticalButton.h"
#import "ToastView.h"
#import "Device.h"

static CGFloat INPUT_TEXT_MIN_HEIGHT = 80;

static NSString * FEEDBACK_SENT_MSG = @"Feedback sent. Thank you.";

static NSString * NAVIGATION_BAR_BACK_ICON_NAME = @"NavigationBarBackIconRed";
static NSString * NAVIGATION_BAR_SEND_TITLE = @"Send";

static NSString * LOGO_IMAGE_NAME = @"MagpieIcon";
static NSString * FEEDBACK_TITLE = @"Thanks for contacting us!\nWe're all ears.";
static NSString * FEEDBACK_FEELING_INSTRUCTION = @"Before we start, how are you feeling?";
static NSString * FEEDBACK_PLACEHOLE_TEXT =@"Tell us what happened";

static NSString * FEEDBACK_EXCITED_TEXT = @"excited";
static NSString * FEEDBACK_HAPPY_TEXT = @"happy";
static NSString * FEEDBACK_CONFUSED_TEXT = @"confused";
static NSString * FEEDBACK_UPSET_TEXT = @"upset";
static NSString * FEEDBACK_FRUSTRATED_TEXT = @"frustrated";

static NSString * FEEDBACK_ICON_EXCITED_STATE_NORMAL = @"FeedbackIconExcitedStateNormal";
static NSString * FEEDBACK_ICON_EXCITED_STATE_HIGHLIGHT = @"FeedbackIconExcitedStateHighlight";
static NSString * FEEDBACK_ICON_HAPPY_STATE_NORMAL = @"FeedbackIconHappyStateNormal";
static NSString * FEEDBACK_ICON_HAPPY_STATE_HIGHLIGHT = @"FeedbackIconHappyStateHighlight";
static NSString * FEEDBACK_ICON_CONFUSED_STATE_NORMAL = @"FeedbackIconConfusedStateNormal";
static NSString * FEEDBACK_ICON_CONFUSED_STATE_HIGHLIGHT = @"FeedbackIconConfusedStateHighlight";
static NSString * FEEDBACK_ICON_UPSET_STATE_NORMAL = @"FeedbackIconUpsetStateNormal";
static NSString * FEEDBACK_ICON_UPSET_STATE_HIGHLIGHT = @"FeedbackIconUpsetStateHighlight";
static NSString * FEEDBACK_ICON_FRUSTRATED_STATE_NORMAL = @"FeedbackIconFrustratedStateNormal";
static NSString * FEEDBACK_ICON_FRUSTRATED_STATE_HIGHLIGHT = @"FeedbackIconFrustratedStateHighlight";

static NSString * FEEDBACK_BUTTON_STATE_NORMAL = @"FeedbackButtonSubmitStateNormal";
static NSString * FEEDBACK_BUTTON_STATE_HIGHLIGHT = @"FeedbackButtonSubmitStateHighlight";


@interface AppFeedbackViewController ()
@property (nonatomic, assign) CGFloat keyboardHeight;
@property (nonatomic, assign) CGFloat screenWidth;
@property (nonatomic, assign) CGFloat screenHeight;
@property (nonatomic, strong) UIBarButtonItem *backButton;
@property (nonatomic, strong) UIBarButtonItem *submitButton;

@property (nonatomic, strong) UIScrollView *containerView;

@property (nonatomic, strong) UIImageView *logoImage;
@property (nonatomic, strong) UILabel *feedbackTitle;
@property (nonatomic, strong) UILabel *feedbackFeelingInstruction;

//here is the container for all the feeling state
@property (nonatomic, strong) UIView *feelingButtonsContainer;
@property (nonatomic, strong) UIButton *excitedButton;
@property (nonatomic, strong) UIButton *happyButton;
@property (nonatomic, strong) UIButton *confusedButton;
@property (nonatomic, strong) UIButton *upsetButton;
@property (nonatomic, strong) UIButton *frustratedButton;

@property (nonatomic, strong) FloatPlaceholderTextView *inputTextArea;

@property (nonatomic, strong) NSString *feelingString;
@end

@implementation AppFeedbackViewController

#pragma mark - lazily initiation
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
 * Lazily init the Submit UIBarButtonItem
 * @return UIBarButtonItem
 */
-(UIBarButtonItem *)submitButton{
    if (_submitButton == nil) {
        UIButton * submitBt = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 44)];
        submitBt.titleLabel.font = [UIFont fontWithName:@"AvenirNext-Medium" size:14];
        [submitBt setTitle:NAVIGATION_BAR_SEND_TITLE forState:UIControlStateNormal];
        [submitBt setTitleColor:[FontColor themeColor] forState:UIControlStateNormal];
        [submitBt setTitleColor:[FontColor defaultBackgroundColor] forState:UIControlStateDisabled];
        [submitBt setTitleColor:[FontColor navigationButtonHighlightColor] forState:UIControlStateHighlighted];
        [submitBt sizeToFit];
        [submitBt addTarget:self action:@selector(submitAction) forControlEvents:UIControlEventTouchUpInside] ;
        
        _submitButton = [[UIBarButtonItem alloc] initWithCustomView:submitBt];
        _submitButton.enabled = NO;
    }
    return _submitButton;
}

/**
 * Lazily init the scroll container view
 * @return container view
 */
-(UIScrollView *)containerView {
    if (_containerView == nil) {
        _containerView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.screenWidth, self.screenHeight)];
    }
    return _containerView;
}

/**
 * Lazily init the logo image
 * @return logo image
 */
-(UIImageView *)logoImage {
    if (_logoImage == nil) {
        _logoImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 30, self.screenWidth, 80)];
        _logoImage.image = [UIImage imageNamed:LOGO_IMAGE_NAME];
        _logoImage.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _logoImage;
}


/**
 * Lazily init the feedbackTitle label
 * @return feedbackTitle label
 */
-(UILabel *)feedbackTitle{
    if (_feedbackTitle == nil) {
        CGFloat y = CGRectGetMaxY(self.logoImage.frame) + 25;
        _feedbackTitle = [[UILabel alloc]initWithFrame:CGRectMake(0, y, self.screenWidth, 50)];
        _feedbackTitle.lineBreakMode = NSLineBreakByWordWrapping;
        _feedbackTitle.numberOfLines = 0;
        _feedbackTitle.textAlignment = NSTextAlignmentCenter;
        _feedbackTitle.font = [UIFont fontWithName:@"AvenirNext-Medium" size:18];
        _feedbackTitle.textColor = [FontColor titleColor];
        _feedbackTitle.text = FEEDBACK_TITLE;
    }
    return _feedbackTitle;
}

/**
 * Lazily init the feedbackFeelingInstruction label
 * @return feedbackFeelingInstruction label
 */
-(UILabel *)feedbackFeelingInstruction{
    if (_feedbackFeelingInstruction == nil) {
        int y = CGRectGetMaxY(self.feedbackTitle.frame) + 35;
        _feedbackFeelingInstruction = [[UILabel alloc]initWithFrame:CGRectMake(0, y, self.screenWidth, 20)];
        _feedbackFeelingInstruction.numberOfLines = 1;
        _feedbackFeelingInstruction.textAlignment = NSTextAlignmentCenter;
        _feedbackFeelingInstruction.font =[UIFont fontWithName:@"AvenirNext-Regular" size:14];
        _feedbackFeelingInstruction.textColor = [FontColor propertyImageBackgroundColor];
        _feedbackFeelingInstruction.text = FEEDBACK_FEELING_INSTRUCTION;
    }
    return _feedbackFeelingInstruction;
}

/**
 * Lazily init the feelingButtonsContainer view
 * @return init the feelingButtonsContainer view
 */
-(UIView *)feelingButtonsContainer{
    if (_feelingButtonsContainer == nil) {
        int y = CGRectGetMaxY(self.feedbackFeelingInstruction.frame) + 25;
        _feelingButtonsContainer = [[UIView alloc] initWithFrame:CGRectMake(20, y, self.screenWidth - 40, 60)];
    }
    return _feelingButtonsContainer;
}


/**
 * Lazily init the excited Button
 * @return init the excited Button
 */
-(UIButton *)excitedButton{
    if (_excitedButton == nil) {
        _excitedButton = [self createFeelingButtonWithTitle:FEEDBACK_EXCITED_TEXT
                                               andImageName:FEEDBACK_ICON_EXCITED_STATE_NORMAL
                                         withHighlightState:FEEDBACK_ICON_EXCITED_STATE_HIGHLIGHT
                                                   andIndex:1];
    }
    return _excitedButton;
}

/**
 * Lazily init the happy Button
 * @return init the happy Button
 */
-(UIButton *)happyButton{
    if (_happyButton == nil) {
        _happyButton = [self createFeelingButtonWithTitle:FEEDBACK_HAPPY_TEXT
                                             andImageName:FEEDBACK_ICON_HAPPY_STATE_NORMAL
                                       withHighlightState:FEEDBACK_ICON_HAPPY_STATE_HIGHLIGHT
                                                 andIndex:2];
    }
    return _happyButton;
}

/**
 * Lazily init the confused Button
 * @return init the confused Button
 */
-(UIButton *)confusedButton{
    if (_confusedButton == nil) {
        _confusedButton = [self createFeelingButtonWithTitle:FEEDBACK_CONFUSED_TEXT
                                                andImageName:FEEDBACK_ICON_CONFUSED_STATE_NORMAL
                                          withHighlightState:FEEDBACK_ICON_CONFUSED_STATE_HIGHLIGHT
                                                    andIndex:3];
    }
    return _confusedButton;
}

/**
 * Lazily init the upset Button
 * @return init the upset Button
 */
-(UIButton *)upsetButton{
    if (_upsetButton == nil) {
        _upsetButton = [self createFeelingButtonWithTitle:FEEDBACK_UPSET_TEXT
                                             andImageName:FEEDBACK_ICON_UPSET_STATE_NORMAL
                                       withHighlightState:FEEDBACK_ICON_UPSET_STATE_HIGHLIGHT
                                                 andIndex:4];
    }
    return _upsetButton;
}

/**
 * Lazily init the frustrated Button
 * @return init the frustrated Button
 */
-(UIButton *)frustratedButton{
    if (_frustratedButton == nil) {
        _frustratedButton = [self createFeelingButtonWithTitle:FEEDBACK_FRUSTRATED_TEXT
                                                  andImageName:FEEDBACK_ICON_FRUSTRATED_STATE_NORMAL
                                            withHighlightState:FEEDBACK_ICON_FRUSTRATED_STATE_HIGHLIGHT
                                                      andIndex:5];
    }
    return _frustratedButton;
}


/**
 * Lazily init the inputTextArea
 * @return init the inputTextArea
 */
-(FloatPlaceholderTextView *)inputTextArea{
    if (_inputTextArea == nil) {
        int y = CGRectGetMaxY(self.feelingButtonsContainer.frame) + 40;
        _inputTextArea = [[FloatPlaceholderTextView alloc] initWithPlaceHolder:FEEDBACK_PLACEHOLE_TEXT andFrame:CGRectMake(20, y, self.screenWidth - 40, INPUT_TEXT_MIN_HEIGHT)];
        _inputTextArea.delegate = self;
    }
    return _inputTextArea;
}

/**
 * Helper class to create the feeling button with a given title
 * @param title
 * @param imagename
 * @param highlight image name
 * @param index
 */
-(UIButton *)createFeelingButtonWithTitle:(NSString *)title andImageName:(NSString *)imageName withHighlightState:(NSString *)imageHighlightName andIndex:(int)index{
    
    double buttonWidth = 55;
    double padingLeft = (self.feelingButtonsContainer.frame.size.width - 5*(buttonWidth))/2 - 20;
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake((index -1) * buttonWidth + padingLeft , 0, 90, 60)];
    button.titleLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:12];
    [button setTitleColor:[FontColor defaultBackgroundColor] forState:UIControlStateNormal];
    [button setTitleColor:[FontColor themeColor] forState:UIControlStateHighlighted];
    [button setTitleColor:[FontColor themeColor] forState:UIControlStateDisabled];
    [button setTitle:title forState:UIControlStateNormal];
    
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:imageHighlightName] forState:UIControlStateHighlighted];
    [button setImage:[UIImage imageNamed:imageHighlightName] forState:UIControlStateDisabled];
    [button centerVertically];
    
    [button addTarget:self action:@selector(feelingButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}


#pragma mark - UITextView Delegate
/**
 * When the text view begin editing, we re-layout the subviews
 * @param textView
 */
-(void)textViewDidBeginEditing:(UITextView *)textView{
    [self.inputTextArea layoutSubviews];
}

/**
 * When the text view ended the editing, we also re-layout the subviews
 * @param textView
 */
-(void)textViewDidEndEditing:(UITextView *)textView {
    [self.inputTextArea layoutSubviews];
}

/**
 * When the text view change, we calculate the height of the new view
 * @param textview
 */
- (void)textViewDidChange:(UITextView *)textView {
    CGSize newSize = [textView sizeThatFits:CGSizeMake(textView.frame.size.width, MAXFLOAT)];
    
    if (newSize.height > textView.frame.size.height) {
        CGRect newFrame = textView.frame;
        newFrame.size.height = newSize.height;
        self.inputTextArea.frame = newFrame;
        
        CGPoint bottomOffset = CGPointMake(0, self.containerView.contentSize.height - (self.screenHeight - self.keyboardHeight));
        
        self.containerView.contentOffset = bottomOffset;
        [self.containerView setContentSize:CGSizeMake(self.screenWidth, CGRectGetMaxY(self.inputTextArea.frame) + self.keyboardHeight + 20)];
    }
    
    [self enableOrDisableSubmitButton];
}

/**
 * Enable or disable the submit button based on whether the user has
 * enter the feedback description
 */
-(void)enableOrDisableSubmitButton {
    self.submitButton.enabled = ([self.inputTextArea getText].length > 0 || self.feelingString.length > 0);
}

#pragma mark - Action
/**
 * Handle the behavior when the user click on any of the feeling buttons
 * @param Button
 */
-(void)feelingButtonAction:(id)sender {
    UIButton *bt = (UIButton *)sender;
    
    //we first reset the state of all the buttons
    self.excitedButton.enabled = YES;
    self.happyButton.enabled = YES;
    self.confusedButton.enabled = YES;
    self.upsetButton.enabled = YES;
    self.frustratedButton.enabled = YES;
    
    //then we set the state of the touched button to disable
    bt.enabled = NO;
    self.feelingString = bt.titleLabel.text;
    
    [self enableOrDisableSubmitButton];
}

/**
 * Handle the behavior when user click on the back button
 */
-(void)goBack {
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 * Handle the behavior when user click send button
 */
-(void)submitAction{
    self.submitButton.enabled = NO;
    [self.inputTextArea resignFirstResponder];
    
    PFObject *feedback = [PFObject objectWithClassName:@"Feedback"];
    if (self.userObj) feedback[@"user"] = self.userObj;
    if (self.feelingString) feedback[@"feeling"] = self.feelingString;
    if ([self.inputTextArea getText]) feedback[@"content"] = [self.inputTextArea getText];
    
    feedback[@"appVersion"] = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    feedback[@"device"] = [Device getDeviceName];
    feedback[@"iosVersion"] = [[UIDevice currentDevice] systemVersion];
    
    [feedback saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [ToastView showToastInParentView:[[[[UIApplication sharedApplication] keyWindow] subviews] lastObject] withText:FEEDBACK_SENT_MSG withDuaration:2];
    }];
}

#pragma mark - keyboard detect
/**
 * On keyboard showing, move the view up
 * @param notif
 */
- (void)keyboardWillShow:(NSNotification *) notif{
    CGRect keyboardBounds;
    [[notif.userInfo valueForKey:UIKeyboardFrameBeginUserInfoKey] getValue:&keyboardBounds];
    self.keyboardHeight = keyboardBounds.size.height;
    
    CGPoint bottomOffset = CGPointMake(0, self.containerView.contentSize.height - (self.screenHeight - self.keyboardHeight));
    
    [UIView animateWithDuration:0.3f animations:^{
        self.containerView.contentOffset = bottomOffset;
    }];
    
    [self.containerView setContentSize:CGSizeMake(self.screenWidth, CGRectGetMaxY(self.inputTextArea.frame) + self.keyboardHeight + 20)];
}

/**
 * On keyboard hiding, move the view down
 * @param notif
 */
- (void)keyboardWillHide:(NSNotification *)notif{
    CGPoint bottomOffset = CGPointMake(0, MAX(-64, self.containerView.contentSize.height - self.screenHeight));
    [UIView animateWithDuration:0.3f animations:^{
        self.containerView.contentOffset = bottomOffset;
    }];
    
    [self.containerView setContentSize:CGSizeMake(self.screenWidth, CGRectGetMaxY(self.inputTextArea.frame) + 20)];
}

/**
 * Dismiss the keyboard, to do this, basically resign the first responder
 */
-(void)dismissKeyboard {
    [self.inputTextArea resignFirstResponder];
}

#pragma mark - view delegate
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title =@"Feedback";
    self.view.backgroundColor = [UIColor whiteColor];
    self.screenWidth = [[UIScreen mainScreen] bounds].size.width;
    self.screenHeight = [[UIScreen mainScreen] bounds].size.height;
    
    [self.view addSubview:[self containerView]];
    [self.containerView addSubview:[self logoImage]];
    [self.containerView addSubview:[self feedbackTitle]];
    [self.containerView addSubview:[self feedbackFeelingInstruction]];
    
    [self.containerView addSubview:[self feelingButtonsContainer]];
    [self.feelingButtonsContainer addSubview:[self excitedButton]];
    [self.feelingButtonsContainer addSubview:[self happyButton]];
    [self.feelingButtonsContainer addSubview:[self confusedButton]];
    [self.feelingButtonsContainer addSubview:[self upsetButton]];
    [self.feelingButtonsContainer addSubview:[self frustratedButton]];
    
    [self.containerView addSubview:[self inputTextArea]];
    
    self.containerView.contentSize = CGSizeMake(self.screenWidth, CGRectGetMaxY(self.inputTextArea.frame) + 20);
    self.navigationItem.leftBarButtonItem = [self backButton];
    self.navigationItem.rightBarButtonItem = [self submitButton];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarHidden = NO;
    [self.navigationController setNavigationBarHidden:NO animated:false];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

@end
