//
//  WLSideMenuViewController.m
//  WLAnimationsTest
//
//  Created by liwang on 14-1-20.
//  Copyright (c) 2014年 liwang. All rights reserved.
//
#include <math.h>
#import "WLSideMenuViewController.h"
#import "WLSideMenuItem.h"
#import "CPValueUtility.h"

#define kTableTopMargin  44
#define kTableCellHeight 44
#define kTableWidth      200

#define kAnimationDuration 0.25
//#define kScale ([self screenHeight] - 88) / [self screenHeight]

#define kShownCenterX (_originalCenter.x + [self screenWidth]*(1-kScale)*0.5 - kScaleMargin)

#define kScaleMargin 44
#define kScale 0.7
#define kMinScale 0.2
#define kAnchorScale ([self screenHeight] - 80) / [self screenHeight]
#define kMaxVelocity -500


@interface WLSideMenuViewController ()
{
    UITableView *_menuTable;
    WLSideMenuItem *_currentMenuItem;
    CGPoint _originalCenter;
    BOOL _allMenuItemsHaveAppeared;
    UITapGestureRecognizer *_tapGesture;
    UIPanGestureRecognizer *_panGesture;
    UISwipeGestureRecognizer *_swipeGesture;
    UIView *_maskView;
    CGFloat _currentScale;
    
    CGRect _currentPageFrame;
    UINavigationController *_menuNavigationController;
    
}

@property(nonatomic ,retain)NSArray *leftMenuItems;
@property(nonatomic ,retain)NSArray *rightMenuItems;

- (void)addMenuView;

- (void)enableTouches;

- (void)disabledTouches;

- (void)createMenuItemsWithItems:(NSArray *)items;

- (void)addMenuTable;

- (void)addDefaultPage;

- (void)addMaskViewForCurrentPage;

- (void)removeMaskViewFromCurrentPage;


- (void)addGesturesForCurrentPage;

- (void)removeGestureFromCurrentPage;

- (void)swipeGestureAction:(UISwipeGestureRecognizer *)gesture;

- (void)snapShotViewPanAction:(UIPanGestureRecognizer *)gesture;

- (void)snapShotViewTapAction:(UITapGestureRecognizer *)gesture;

- (void)addMenuButtonForItems;

- (void)showSnapShotViewAnimationDidStop;

- (void)hideSnapShotViewAnimationDidStop;

- (void)addMainViewController;

- (UIImage *)snapShotForMenuItem:(WLSideMenuItem *)item;

- (CGRect)evaluatedSnapShotFrameByXOffset:(CGFloat)xoffset;

- (void)animationWithScale:(CGFloat)scale
                     alpha:(CGFloat)alpha
                     point:(CGPoint)point
                 endAction:(SEL)action;
@end

@implementation WLSideMenuViewController
@synthesize leftMenuItems;
@synthesize rightMenuItems;


- (void)dealloc
{
    self.leftMenuItems = nil;
    self.rightMenuItems = nil;
    
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

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    [self addMenuTable];
    [self addMenuButtonForItems];
    [self addDefaultPage];   
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [UIApplication sharedApplication].keyWindow.rootViewController = self;
    // resolve navigationbar black
    if (!_allMenuItemsHaveAppeared) {
        _allMenuItemsHaveAppeared = YES;
        for (NSInteger i = self.leftMenuItems.count - 1; i >= 0; i--) {
            WLSideMenuItem *item = [self.leftMenuItems objectAtIndex:i];
            if (i != 0) {
                [item.rootViewController.view removeFromSuperview];
            }
        }
    }
    
}

- (id)initWithLeftMenuItems:(NSArray *)leftItems rightMenuItems:(NSArray *)rightItems
{
    self = [super init];
    if (self) {
        self.leftMenuItems = leftItems;
        self.rightMenuItems = rightItems;
        _allMenuItemsHaveAppeared = NO;
        
    }
    return self;
}

#pragma mark- Member Method

- (void)addMenuView
{
    //_menuNavigationController = [];
}


- (void)enableTouches
{
    _maskView.userInteractionEnabled = YES;
    _menuTable.userInteractionEnabled = YES;
    _currentMenuItem.rootViewController.view.userInteractionEnabled = YES;
}

- (void)disabledTouches
{
    _maskView.userInteractionEnabled = NO;
    _menuTable.userInteractionEnabled = NO;
    _currentMenuItem.rootViewController.view.userInteractionEnabled = NO;
}


- (CGRect)evaluatedSnapShotFrameByXOffset:(CGFloat)xoffset
{
    return CGRectZero;
}

- (void)addMenuButtonForItems
{
    for (NSInteger i = 0; i < self.leftMenuItems.count; i++) {
        WLSideMenuItem *item = [self.leftMenuItems objectAtIndex:i];
        UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStylePlain target:self action:@selector(showMenu)];
        item.rootViewController.topViewController.navigationItem.leftBarButtonItem = barItem;
        [barItem release];
    }
    
}

- (void)addMaskViewForCurrentPage
{
    if (_maskView == nil) {
        CGRect frame = CGRectMake(0, 0, [self screenWidth], [self screenHeight]);
        _maskView = [[UIView alloc] initWithFrame:frame];
        _maskView.backgroundColor = [UIColor clearColor];
        [_currentMenuItem.rootViewController.view addSubview:_maskView];
        [_maskView release];
    }
}

- (void)removeMaskViewFromCurrentPage
{
    if (_maskView != nil) {
        [_maskView removeFromSuperview];
        _maskView = nil;
    }
}


- (void)addDefaultPage
{
    _currentPageFrame = CGRectMake(0, 0, [self screenWidth], [self screenHeight]);
    for (NSInteger i = self.leftMenuItems.count - 1; i >= 0; i--) {
        WLSideMenuItem *item = [self.leftMenuItems objectAtIndex:i];
        if (i == 0) {
            _currentMenuItem = item;
            _originalCenter = CGPointMake([self screenWidth]/2, [self screenHeight]/2);
        }
        [self.view addSubview:item.rootViewController.view];
    }
}




- (void)createMenuItemsWithItems:(NSArray *)items
{
    
}

- (void)addMenuTable
{
    NSInteger count = self.leftMenuItems.count;
    CGFloat width = [self screenWidth] - kScale*[self screenWidth]/2;
    _menuTable = [[UITableView alloc] initWithFrame:CGRectMake(0, kTableTopMargin, width, kTableCellHeight*count)];
    _menuTable.dataSource = self;
    _menuTable.delegate = self;
    _menuTable.backgroundColor = [UIColor clearColor];
    _menuTable.scrollEnabled = NO;
    _menuTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_menuTable];
    [_menuTable release];
    _menuTable.alpha = 0;
}

- (void)addMainViewController
{
    
}


- (CGFloat)screenWidth
{
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    CGFloat width = [UIScreen mainScreen].bounds.size.height;
    if (orientation == UIInterfaceOrientationPortrait ||
        orientation == UIInterfaceOrientationPortraitUpsideDown) {
        width = [UIScreen mainScreen].bounds.size.width;
    }
    
    return width;
}

- (CGFloat)screenHeight
{
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    CGFloat height = [UIScreen mainScreen].bounds.size.width;
    if (orientation == UIInterfaceOrientationPortrait ||
        orientation == UIInterfaceOrientationPortraitUpsideDown) {
        height = [UIScreen mainScreen].bounds.size.height;
    }
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) {
        height -= 20;
    }
    
    return height;
}

- (void)swipeGestureAction:(UISwipeGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateEnded) {
        if (gesture.direction == UISwipeGestureRecognizerDirectionLeft) {
            [self hideMenu];
        }
    }
    
}

- (void)snapShotViewPanAction:(UIPanGestureRecognizer *)gesture
{
    CGPoint translatedPoint = [gesture translationInView:self.view];
    CGFloat translatedX = translatedPoint.x;
    UIGestureRecognizerState state = gesture.state;
    
    CGPoint nowCenter = CGPointMake(kShownCenterX, _originalCenter.y);
    nowCenter.x = nowCenter.x + translatedX;
    BOOL shouldChangeSnapShot = ( nowCenter.x >= _originalCenter.x);
    
    if (state == UIGestureRecognizerStateChanged && shouldChangeSnapShot) {
        
        CGFloat shownCenterX = kShownCenterX;
        CGFloat offset = shownCenterX - _originalCenter.x;
        CGFloat alpha = (nowCenter.x < shownCenterX) ? (1 + translatedX / offset) : 1;
        _menuTable.alpha = alpha;
        _menuTable.userInteractionEnabled = NO;
        
        CGFloat maxOffset = [self screenWidth]*kScale + kScaleMargin;
        _currentScale = (nowCenter.x < shownCenterX) ? kScale + (fabs(translatedX)/offset)*(1-kScale) : MAX((kScale - translatedX / maxOffset * kScale), kMinScale);
        _currentMenuItem.rootViewController.view.transform = CGAffineTransformMakeScale(_currentScale, _currentScale);
        
        CGFloat aCenter = kShownCenterX + (kScale - _currentScale) / 2 * [self screenWidth];
        nowCenter.x = (nowCenter.x < shownCenterX) ? nowCenter.x : aCenter;
        _currentMenuItem.rootViewController.view.center = nowCenter;

    }
    
    if (state == UIGestureRecognizerStateEnded || state == UIGestureRecognizerStateCancelled) {
        //hide or show menu here
        CGPoint velocity = [gesture velocityInView:self.view];
        NSLog(@"%@", NSStringFromCGPoint(velocity));
        
        if (_currentScale >= kAnchorScale || velocity.x < kMaxVelocity) {
            [self hideMenu];
        }
        else{
            [self showMenu];
        }
    }
    
}


- (void)snapShotViewTapAction:(UITapGestureRecognizer *)gesture
{
    [self hideMenu];
}

- (void)removeGestureFromCurrentPage
{
    if (_tapGesture != nil && _panGesture != nil) {
        
        [_maskView removeGestureRecognizer:_tapGesture];
        _tapGesture = nil;
        
        
        [_maskView removeGestureRecognizer:_panGesture];
        _panGesture = nil;
    }
}



- (void)addGesturesForCurrentPage
{
    if (_panGesture == nil && _tapGesture == nil && _swipeGesture == nil) {
        
        // add tapGesture
        _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(snapShotViewTapAction:)];
        _tapGesture.numberOfTapsRequired = 1;
        _tapGesture.numberOfTouchesRequired = 1;
        [_maskView addGestureRecognizer:_tapGesture];
        [_tapGesture release];
        
        // add panGesture
        _panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(snapShotViewPanAction:)];
        [_maskView addGestureRecognizer:_panGesture];
        [_panGesture release];
    }
}


- (UIImage *)snapShotForMenuItem:(WLSideMenuItem *)item
{
    CGRect rect = [item.rootViewController.view bounds];
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [item.rootViewController.view.layer renderInContext:context];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}


- (UIImage *)scaleImage:(UIImage *)image toScale:(CGFloat)scaleSize
{
    CGSize size = image.size;
    UIGraphicsBeginImageContext(CGSizeMake(size.width*scaleSize,size.height*scaleSize));
    [image drawInRect:CGRectMake(0, 0,image.size.width * scaleSize, image.size.height *scaleSize)];
    UIImage *scaledImage =UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}


- (void)showSnapShotViewAnimationDidStop
{
    [self enableTouches];
}

- (void)hideSnapShotViewAnimationDidStop
{
    _currentMenuItem.rootViewController.view.frame = _currentPageFrame;
    [self enableTouches];
    [self removeGestureFromCurrentPage];
    [self removeMaskViewFromCurrentPage];
    NSLog(@"final:%@", NSStringFromCGRect(_currentMenuItem.rootViewController.view.frame));
}

#pragma mark - Public Method

- (void)animationWithScale:(CGFloat)scale
                     alpha:(CGFloat)alpha
                     point:(CGPoint)point
                 endAction:(SEL)action
{
    [UIView beginAnimations:@"Menu" context:nil];
    [UIView setAnimationDuration:kAnimationDuration];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:action];
    _currentMenuItem.rootViewController.view.transform = CGAffineTransformMakeScale(scale, scale);
    _currentMenuItem.rootViewController.view.center = point;
    _menuTable.alpha = alpha;
    [UIView commitAnimations];
}


- (void)showMenu
{
    _currentScale = kScale;
    [self addMaskViewForCurrentPage];
    [self addGesturesForCurrentPage];
    [self disabledTouches];
    [self animationWithScale:_currentScale
                       alpha:1
                       point:CGPointMake(kShownCenterX, _originalCenter.y)
                   endAction:@selector(showSnapShotViewAnimationDidStop)];
}

- (void)hideMenu
{
    _currentScale = [CPValueUtility iPadDevice] ? 1.0 : 1.0;

    [self disabledTouches];
    [self animationWithScale:_currentScale
                       alpha:0
                       point:_originalCenter
                   endAction:@selector(hideSnapShotViewAnimationDidStop)];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.leftMenuItems.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kTableCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = [indexPath row];
    NSString *identifier = [NSString stringWithFormat:@"cell%ld", (long)row];
    UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
    if (cell != nil) {
        if (row ==0) {
            [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        }
        WLSideMenuItem *item = [self.leftMenuItems objectAtIndex:row];
        cell.textLabel.text = item.title;
    }

    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // disable table
    tableView.userInteractionEnabled = NO;
    NSInteger row = [indexPath row];
    WLSideMenuItem *item = [self.leftMenuItems objectAtIndex:row];
    if (_currentMenuItem != item) {
        // add new page first
        item.rootViewController.view.transform = CGAffineTransformMakeScale(kScale, kScale);
        item.rootViewController.view.center = CGPointMake([self screenWidth], _originalCenter.y);
        [self.view addSubview:item.rootViewController.view];
        // remove old page second
        [self removeGestureFromCurrentPage];
        [self removeMaskViewFromCurrentPage];
        [_currentMenuItem.rootViewController.view removeFromSuperview];
        // set current page
        _currentMenuItem = item;
    }
    // hide menu
    [self hideMenu];
    
    
}



@end
