//
//  CPADPresentationViewController.m
//  Cashier
//
//  Created by liwang on 14-1-8.
//  Copyright (c) 2014年 liwang. All rights reserved.
//

#import "CPADPresentationViewController.h"
#import "CPRegisterViewController.h"
#import "CPLoginViewController.h"
#import "CPViewAnimations.h"
#import "CPDataBaseManager.h"


#define kButtonWidth     200
#define kButtonHeight    44
#define kButtonMargin    40
#define kMaxPageNum      5

#define kPageControllerHeight 30
#define kPageNumbers     5

@interface CPADPresentationViewController ()
{
    UIScrollView *_scrollView;
    UIPageControl *_pageController;
    NSInteger _currentPage;
    
    UIButton *_registerButton;
    UIButton *_loginButton;
    
    BOOL _animationDidStop;
    BOOL _userDidEndDragging;
    BOOL _preDisplayDidShow;
}

- (void)addPageController;

- (void)addScrollViewToView;

- (void)addResgisterButtonToView;

- (void)addLoginButtonToView;

- (void)loginAction:(UIButton *)button;

- (void)registerAction:(UIButton *)button;


@end

@implementation CPADPresentationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.navigationController.navigationBar.hidden = YES;
    _preDisplayDidShow = NO;
    [self addScrollViewToView];
    [self addPageController];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (!_preDisplayDidShow) {
        _preDisplayDidShow = YES;
        CGRect displayFrame = CGRectMake(-FScreenWidth, 0, FScreenWidth, FScreenHeight);
        CPPreDisplayArea *displayArea = [[CPPreDisplayArea alloc] initWithFrame:displayFrame];
        [self.view addSubview:displayArea];
        [displayArea showWhenEnterForeground];
        [displayArea release];
    }
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = YES;
}

#pragma mark- Member Function

- (void)pageChangedAction:(UIPageControl *)control
{
    _currentPage = control.currentPage;
}

- (void)addPageController
{
    _pageController = [[UIPageControl alloc] initWithFrame:CGRectMake(0, FScreenHeight-kButtonHeight*2, self.view.frame.size.width, kPageControllerHeight)];
    _pageController.numberOfPages = kPageNumbers;
    _pageController.currentPage = 0;
    _pageController.UserInteractionEnabled = NO;
    [_pageController addTarget:self action:@selector(pageChangedAction:) forControlEvents:UIControlEventValueChanged];
    
    if ([[UIDevice currentDevice].systemVersion integerValue] > 6) {
        [[UIPageControl appearance] setCurrentPageIndicatorTintColor:[UIColor redColor]];
        [[UIPageControl appearance] setPageIndicatorTintColor:[UIColor grayColor]];
    }
    
    [self.view addSubview:_pageController];
    [_pageController release];
}

- (void)addScrollViewToView
{
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, FScreenWidth, FScreenHeight)];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.pagingEnabled = YES;
    _scrollView.clipsToBounds = YES;
    _scrollView.bounces = NO;
    _scrollView.delegate = self;
    _scrollView.contentInset = UIEdgeInsetsZero;
    [self.view addSubview:_scrollView];
    [_scrollView release];
    
    NSArray *images = @[FGetImageNameByKey(kPreDisplay_1), FGetImageNameByKey(kPreDisplay_2)
                        , FGetImageNameByKey(kPreDisplay_3), FGetImageNameByKey(kPreDisplay_4)
                        , FGetImageNameByKey(kPreDisplay_5)];
    for (NSInteger i = 0; i<5; i++) {
        UIImageView *view = [[UIImageView alloc] initWithImage:[images objectAtIndex:i]];
        view.frame = CGRectMake(i*FScreenWidth, 0, FScreenWidth, FScreenHeight);
        [_scrollView addSubview:view];
        [view release];
    }
    
    [self addResgisterButtonToView];
    [self addLoginButtonToView];
    
    
    _scrollView.contentSize = CGSizeMake(FScreenWidth*5, FScreenHeight);
    
}


- (void)addResgisterButtonToView
{
    int page = 4;
#ifdef DEBUG
    page = 0;
#endif
    
    CGFloat x = (FScreenWidth*page + (FScreenWidth - kButtonWidth*2)/3);
    CGRect frame = CGRectMake(x, FScreenHeight-kButtonHeight*2, kButtonWidth, kButtonHeight);
    _registerButton = [CPCocoaSubViews buttonWithFrame:frame
                                                  title:FGetStringByKey(kBtn_Register)
                                            normalImage:[UIImage imageNamed:@"greenBtn.png"]
                                         highlightImage:[UIImage imageNamed:@"grayBtn.png"]
                                                 target:self
                                                 action:@selector(registerAction:)];
    _registerButton.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [_scrollView addSubview:_registerButton];
}



- (void)addLoginButtonToView
{
    int page = 4;
#ifdef DEBUG
    page = 0;
#endif
    
    CGFloat x = (FScreenWidth*page + (FScreenWidth - kButtonWidth*2)/3*2 + kButtonWidth);
    CGRect frame = CGRectMake(x, FScreenHeight-kButtonHeight*2, kButtonWidth, kButtonHeight);
    _loginButton = [CPCocoaSubViews buttonWithFrame:frame
                                                  title:FGetStringByKey(kBtn_Login)
                                            normalImage:[UIImage imageNamed:@"greenBtn.png"]
                                         highlightImage:[UIImage imageNamed:@"grayBtn.png"]
                                                 target:self
                                                 action:@selector(loginAction:)];
    
    _loginButton.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [_scrollView addSubview:_loginButton];
}

- (void)loginAction:(UIButton *)button
{
    CPLoginViewController *l = [[CPLoginViewController alloc] init];
    UINavigationController *n = [[[UINavigationController alloc] initWithRootViewController:l] autorelease];
    n.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:n animated:YES completion:nil];
}


- (void)registerAction:(UIButton *)button
{
    CPRegisterViewController *r = [[[CPRegisterViewController alloc] init] autorelease];
    UINavigationController *n = [[[UINavigationController alloc] initWithRootViewController:r] autorelease];
    n.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:n animated:YES completion:nil];
    
}


#pragma mark- ScrollViewDelegate

- (void)firstAnimationDidStop
{
    CGRect frame = CGRectMake(FScreenWidth*4 + (FScreenWidth - kButtonWidth)/2, FScreenHeight-kButtonHeight*2.5, kButtonWidth, kButtonHeight);
    [CPViewAnimations animationWithDuration:kSystemAnimationDuration endAction:nil target:self block:^{
        _loginButton.frame = frame;
    }];
}

- (void)secondAnimationDidStop
{
    CGRect rFrame = CGRectMake(FScreenWidth*4 + (FScreenWidth - kButtonWidth)/2, FScreenHeight, kButtonWidth, kButtonHeight);
    [CPViewAnimations animationWithDuration:kSystemAnimationDuration*2 endAction:nil target:self block:^{
        _registerButton.frame =rFrame;
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    _currentPage = scrollView.contentOffset.x / FScreenWidth;
    _pageController.currentPage = _currentPage;
    
    return;
    if (_currentPage == kMaxPageNum-1) {
        CGRect frame = CGRectMake(FScreenWidth*4 + (FScreenWidth - kButtonWidth)/2, FScreenHeight-kButtonHeight*4, kButtonWidth, kButtonHeight);
        [CPViewAnimations animationWithDuration:kSystemAnimationDuration endAction:@selector(firstAnimationDidStop) target:self block:^{
            _registerButton.frame = frame;
        }];
    }
    else{
        
        CGRect lFrame = CGRectMake(FScreenWidth*4 + (FScreenWidth - kButtonWidth)/2, FScreenHeight+kButtonHeight*1.5, kButtonWidth, kButtonHeight);
        
        [CPViewAnimations animationWithDuration:kSystemAnimationDuration endAction:@selector(secondAnimationDidStop) target:self block:^{
            _loginButton.frame = lFrame;
        }];
        
    }
}


@end
