//
//  CPBaseViewController.m
//  Cashier
//
//  Created by liwang on 14-1-8.
//  Copyright (c) 2014年 liwang. All rights reserved.
//

#import "CPBaseViewController.h"

#define kToastWidth 300
#define ktoastMaxHeight 500
#define kToastTopMargin 20

#define kLoadingIndicatorSize 30


@interface CPBaseViewController ()
{
    BOOL _keyboardDidShow;
    CPToast *_toast;
    UIBarButtonItem * _leftItem;
    UIBarButtonItem * _rightItem;
}


@property(nonatomic, retain)UIAlertView *alert;

- (void)navigationBarAppearence;

- (void)addTapGesture;

- (void)tapGestureAction:(id)sender;


- (void)keyBoardWillChangeFrame:(NSNotification *)notification;

- (void)keyBoardWillHide:(NSNotification *)notification;

@end




@implementation CPBaseViewController

@synthesize alert;
@synthesize netEntry;


- (void)dealloc
{
    FRelease(_textFieldArray);
    self.alert = nil;
    self.netEntry = nil;
    
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    _originalFrame = self.view.frame;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyBoardWillChangeFrame:)
                                                 name:UIKeyboardWillChangeFrameNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyBoardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //UIView设置阴影
    [self.view.layer setShadowOffset:CGSizeMake(5, 3)];
    [self.view.layer setShadowRadius:5];
    [self.view.layer setShadowOpacity:0.6];
    [self.view.layer setShadowColor:[UIColor blackColor].CGColor];
    
    [self addNavigationBar];
    
    if ([CPValueUtility iOS7Device]) {
        [self setNeedsStatusBarAppearanceUpdate];
        [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    }
	// Do any additional setup after loading the view.
    
    [self navigationBarAppearence];
    _textFieldArray = [[NSMutableArray alloc] init];
    
    _mainBoardFrame = CGRectMake(0, 0, FScreenWidth, FScreenHeight-44);
    _mainBoardView = [[UIScrollView alloc] initWithFrame:_mainBoardFrame];
    _mainBoardView.backgroundColor = [UIColor whiteColor];
    _mainBoardView.showsHorizontalScrollIndicator = NO;
    _mainBoardView.showsVerticalScrollIndicator = NO;
    _mainBoardView.clipsToBounds = YES;
    _mainBoardView.scrollEnabled = NO;
    _mainBoardView.contentSize = CGSizeMake(FScreenWidth, FScreenHeight-44);
    [self.view addSubview:_mainBoardView];
    [_mainBoardView release];
    
    
    //[self addTapGesture];
    if ([CPValueUtility iOS7Device]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Rotation

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    BOOL shouldRotateOrientation = YES;
    if ([CPValueUtility iPadDevice]) {
        shouldRotateOrientation = (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight);
    }
    else
    {
        shouldRotateOrientation = (interfaceOrientation == UIInterfaceOrientationPortrait);
    }

    return shouldRotateOrientation;
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    UIInterfaceOrientationMask orientationMask = [CPValueUtility iPadDevice] ? UIInterfaceOrientationMaskLandscape :
    UIInterfaceOrientationMaskPortrait;
    
    return orientationMask;
}

*/

#pragma mark - Status Bar

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (BOOL)prefersStatusBarHidden
{
    return NO;
}


#pragma mark - Public Method

- (BOOL)checkEmptyAndIllegalForTextField:(UITextField *)textField
{
    if (textField.text.length == 0) {
        [self showToastMessage:FStringEmptyWith(FRemoveString(textField.placeholder, kInputPrefix)) position:CPToastPositionTop];
        return NO;
    }
    
    return YES;
    if (!FCheckRegex(textField.text, @""))
    {
        [self showToastMessage:FStringErrorWith(textField.placeholder) position:CPToastPositionTop];
        return NO;
    }
    
    return YES;
}


- (void)showToastMessage:(NSString *)message position:(CPToastPosition)position
{
    [self dismissLoading];
    CPToast *toast = [[CPToast alloc] initOnView:self.navigationController.view position:position title:message];
    [toast show];
    [toast release];
}

- (void)showAlertMessage:(NSString *)message
                   okBtn:(NSString *)okTitle
               cancelBtn:(NSString *)cancelTitle
{
    [self dismissLoading];
    self.alert = [[[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:okTitle otherButtonTitles:cancelTitle, nil] autorelease];
    [self.alert show];
}

- (void)showLoadingWithTitle:(NSString *)title
{
    _toast = [[CPToast alloc] initLoadingOnView:self.navigationController.view title:title];
    [_toast show];
    [_toast release];
}


- (void)dismissLoading
{
    if (_toast != nil) {
        [_toast dismiss];
        _toast = nil;
    }
}


#pragma mark- Member Method


- (void)addTapGesture
{
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureAction:)];
    tapGesture.numberOfTapsRequired = 1;
    tapGesture.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:tapGesture];
    [tapGesture release];
}

- (void)tapGestureAction:(id)sender
{
    [_currentResponserTextField resignFirstResponder];
    _currentResponserTextField = nil;
}

- (void)navigationBarAppearence
{
    //UIImage *image = FGetImageNameByKey(kBar_Background);
    if ([CPValueUtility iOS7Device]) {
        
        //[[UINavigationBar appearance] setBarTintColor:[UIColor purpleColor]];
        //[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }
}


#pragma mark- UITextFieldDelegate




- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    _currentResponserTextField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    _currentResponserTextField = nil;
}


#pragma mark- Keyboard

- (void)keyBoardWillChangeFrame:(NSNotification *)notification
{
    NSValue *keyboardRectValue = [notification userInfo][UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [keyboardRectValue CGRectValue];
    CGFloat height = MIN(keyboardRect.size.width, keyboardRect.size.height);
    NSValue *animationDurationValue = [notification userInfo][UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    CGRect newFrame = CGRectMake(0, 0, _mainBoardFrame.size.width, _mainBoardFrame.size.height- height-44);
    
    [CPViewAnimations animationWithDuration:animationDuration endAction:nil target:nil block:^{
        _mainBoardView.frame = newFrame;
        [_mainBoardView scrollRectToVisible:_currentResponserTextField.frame animated:YES];
        NSLog(@"change frame");
    }];
    
}

- (void)keyBoardWillHide:(NSNotification *)notification
{
    _mainBoardView.frame = _mainBoardFrame;
}

#pragma mark - Alert Delegate


- (void)didPresentAlertView:(UIAlertView *)alertView
{
    if (alert.title == nil) {

    }
}

- (void)addNavigationBar
{
    _leftItem = [[[UIBarButtonItem alloc] initWithTitle:@"上一步" style:UIBarButtonItemStylePlain target:self action:@selector(leftBarAction:)] autorelease];
    _leftItem.tintColor = [UIColor grayColor];
    self.navigationItem.leftBarButtonItem = _leftItem;
    
    _rightItem = [[[UIBarButtonItem alloc] initWithTitle:@"下一步" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarAction:)] autorelease];
    _rightItem.tintColor = [UIColor greenColor];
    self.navigationItem.rightBarButtonItem = _rightItem;
}

- (IBAction)leftBarAction:(id)sender
{
    
}

- (IBAction)rightBarAction:(id)sender
{
    
}

@end
