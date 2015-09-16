//
//  MyProfileDescriptionViewController.m
//  Magpie
//
//  Created by minh thao nguyen on 5/4/15.
//  Copyright (c) 2015 Magpie. All rights reserved.
//

#import "MyProfileDescriptionViewController.h"
#import "FloatPlaceholderTextView.h"
#import "FontColor.h"
#import "TTTAttributedLabel.h"
#import "MyProfileTableViewController.h"

static CGFloat INPUT_TEXT_MIN_HEIGHT = 100;
static NSString * NAVIGATION_BAR_BACK_ICON_NAME = @"NavigationBarBackIconRed";
static NSString * INSTRUCTION_TEXT = @"Don’t know what to say? We have some good suggestions to help get you started:\n•     What do you like about hosting?\n•     How would you define traveling?\n•     Are you London, New York or another city?";

static NSString * ABOUT_ME_PLACEHOLDER = @"Few things about me";

@interface MyProfileDescriptionViewController ()
@property (nonatomic, assign) CGFloat keyboardHeight;
@property (nonatomic, assign) CGFloat screenWidth;
@property (nonatomic, assign) CGFloat screenHeight;
@property (nonatomic, strong) UIBarButtonItem *backButton;

@property (nonatomic, strong) UIScrollView *containerView;
@property (nonatomic, strong) TTTAttributedLabel *instructionLabel;
@property (nonatomic, strong) FloatPlaceholderTextView *inputTextArea;
@end

@implementation MyProfileDescriptionViewController
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
 * Lazily init the scroll container view
 * @return UIScrollView
 */
-(UIScrollView *)containerView {
    if (_containerView == nil) {
        _containerView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.screenWidth, self.screenHeight)];
    }
    return _containerView;
}

/**
 * Lazily init the instruction label
 * @return UILabel
 */
-(TTTAttributedLabel *)instructionLabel {
    if (_instructionLabel == nil) {
        _instructionLabel = [[TTTAttributedLabel alloc] init];
        _instructionLabel.numberOfLines = 0;
        _instructionLabel.textAlignment = NSTextAlignmentJustified;
        _instructionLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:12.5];
        _instructionLabel.textColor = [FontColor descriptionColor];
        _instructionLabel.lineSpacing = 5;
        _instructionLabel.text = INSTRUCTION_TEXT;
        CGSize instructionFrameSize = [_instructionLabel sizeThatFits:CGSizeMake(self.screenWidth - 40, FLT_MAX)];
        _instructionLabel.frame = CGRectMake(25, 10, self.screenWidth - 50, instructionFrameSize.height);
    }
    return _instructionLabel;
}

/**
 * Lazily init the inputTextArea
 * @return init the inputTextArea
 */
-(FloatPlaceholderTextView *)inputTextArea{
    if (_inputTextArea == nil) {
        int y = CGRectGetMaxY(self.instructionLabel.frame) + 25;
        _inputTextArea = [[FloatPlaceholderTextView alloc] initWithPlaceHolder:ABOUT_ME_PLACEHOLDER andFrame:CGRectMake(18, y, self.screenWidth - 36, INPUT_TEXT_MIN_HEIGHT)];
        _inputTextArea.delegate = self;
        
        _inputTextArea.text = self.userDescription;
        CGSize newSize = [_inputTextArea sizeThatFits:CGSizeMake(self.screenWidth - 36, MAXFLOAT)];
        
        if (newSize.height > INPUT_TEXT_MIN_HEIGHT)
            _inputTextArea.frame = CGRectMake(18, y, self.screenWidth - 36, newSize.height);
    }
    return _inputTextArea;
}

#pragma mark - view delegate
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title =@"About me";
    self.view.backgroundColor = [UIColor whiteColor];
    self.screenWidth = [[UIScreen mainScreen] bounds].size.width;
    self.screenHeight = [[UIScreen mainScreen] bounds].size.height;
    
    [self.view addSubview:[self containerView]];
    [self.containerView addSubview:[self instructionLabel]];
    [self.containerView addSubview:[self inputTextArea]];
    
    self.containerView.contentSize = CGSizeMake(self.screenWidth, CGRectGetMaxY(self.inputTextArea.frame) + 20);
    self.navigationItem.leftBarButtonItem = [self backButton];
    
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
//    [self.inputTextArea becomeFirstResponder];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    // Listen for keyboard appearances and disappearances
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
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
}

#pragma mark - click action
/**
 * Handle the behavior when user click on the back button
 */
-(void)goBack {
    //we update the previous view if any changes were to happend
    if (![self.inputTextArea.text isEqualToString:self.userDescription]) {
        NSInteger currentViewControllerIndex = [self.navigationController.viewControllers indexOfObject:self];
        MyProfileTableViewController *myProfileTableViewController = [self.navigationController.viewControllers objectAtIndex:currentViewControllerIndex-1];
        [myProfileTableViewController setAboutMe:self.inputTextArea.text];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
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
    
    CGPoint bottomOffset = CGPointMake(0, MAX(-64, self.containerView.contentSize.height - (self.screenHeight - self.keyboardHeight)));
    
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
        
        CGPoint bottomOffset = CGPointMake(0, MAX(-64, self.containerView.contentSize.height - (self.screenHeight - self.keyboardHeight)));
        self.containerView.contentOffset = bottomOffset;
        
        [self.containerView setContentSize:CGSizeMake(self.screenWidth, CGRectGetMaxY(self.inputTextArea.frame) + self.keyboardHeight + 20)];
    }
}


@end
