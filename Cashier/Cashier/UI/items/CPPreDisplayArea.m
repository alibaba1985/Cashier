//
//  CPPreDisplayArea.m
//  Cashier
//
//  Created by liwang on 14-1-11.
//  Copyright (c) 2014年 liwang. All rights reserved.
//

#import "CPPreDisplayArea.h"
#import "CPViewAnimations.h"
#import "CPConstDefine.h"

typedef NS_ENUM(NSInteger, CPDisplayType) {
    CPDisplayTypeNone = 0,
    CPDisplayFromLeft,               //从左边滑进
    CPDisplayHideFromRight,          //从右边隐藏
    CPDisplayWhenEnterForeground,    //程序启动显示
};


#define kDisappearAnimationDuration 0.5
#define kDisappearAnimationDelay    3
#define kslideDuration              0.3
#define kKeyWindow                  self.superview
#define kDisplaySize                CGSizeMake(FScreenWidth, FScreenHeight);

static CPPreDisplayArea *_displayArea = nil;
@interface CPPreDisplayArea ()
{
    CPDisplayType _displayType;
    UIPanGestureRecognizer *_panGesture;
}

- (void)handlePanGesture:(UIPanGestureRecognizer *)gesture;

- (void)addPanGestureRecognizer;

- (void)removePanGestureRecognizer;

- (void)disappearWithAnimation;

- (void)animationDidStop;

@end
@implementation CPPreDisplayArea
@synthesize displayArea;

- (void)dealloc
{
    self.displayArea = nil;
    
    [super dealloc];
}

+ (CPPreDisplayArea *)currentArea
{
    @synchronized(self)
    {
        if (_displayArea == nil) {
            CGRect displayFrame = CGRectMake(-FScreenWidth, 0, FScreenWidth, FScreenHeight);
            _displayArea = [[CPPreDisplayArea alloc] initWithFrame:displayFrame];
            //[kKeyWindow addSubview:_displayArea];
            [_displayArea release];
        }
    }
    return _displayArea;
}

+ (void)releaseArea
{
    if (_displayArea != nil) {
        [_displayArea release];
        _displayArea = nil;
    }
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        self.displayArea = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, FScreenWidth, FScreenHeight)] autorelease];
        self.displayArea.userInteractionEnabled = NO;
        self.displayArea.image = FGetImageNameByKey(kImage_Display);
        [self addSubview:self.displayArea];

    }
    return self;
}



- (void)showFromLeft
{
    _displayType = CPDisplayFromLeft;
    kKeyWindow.userInteractionEnabled = NO;
    CGRect frame = CGRectMake(0, 0, FScreenWidth, FScreenHeight);
    self.alpha = 0;
    __block CPPreDisplayArea *aSelf = self;
        [CPViewAnimations animationWithDuration:kslideDuration endAction:@selector(animationDidStop) target:self block:^{
        aSelf.frame = frame;
        aSelf.alpha = 1;
    }];
}


- (void)showWhenEnterForeground
{
    _displayType = CPDisplayWhenEnterForeground;
    kKeyWindow.userInteractionEnabled = NO;
    self.frame = CGRectMake(0, 0, FScreenWidth, FScreenHeight);
    self.alpha = 1;
    [self performSelector:@selector(disappearWithAnimation)
               withObject:nil
               afterDelay:kDisappearAnimationDelay];
    
}


#pragma mark- Private Method

- (void)handlePanGesture:(UIPanGestureRecognizer *)gesture
{
    
    CGPoint translatedPoint = [gesture translationInView:self];
    CGFloat xoffset = translatedPoint.x;
    UIGestureRecognizerState state = [gesture state];

    if (state == UIGestureRecognizerStateChanged) {
        if (xoffset<0) {
            self.displayArea.frame = CGRectMake(xoffset, 0, FScreenWidth, FScreenHeight);
        }
    }
    
    if (state == UIGestureRecognizerStateEnded || state == UIGestureRecognizerStateCancelled) {
        CGRect frame ;
        if (self.displayArea.frame.origin.x>(-FScreenWidth/4)) {
            //滑动距离过小，还原全屏显示
            frame = CGRectMake(0, 0, FScreenWidth, FScreenHeight);
        }
        else
        {
            //滑动距离大，隐藏
            _displayType = CPDisplayHideFromRight;
            frame = CGRectMake(-FScreenWidth, 0, FScreenWidth, FScreenHeight);
        }
        
        __block CPPreDisplayArea *aSelf = self;
        [CPViewAnimations animationWithDuration:kslideDuration endAction:@selector(animationDidStop) target:self block:^{
            aSelf.displayArea.frame = frame;
        }];
    }
}


- (void)addPanGestureRecognizer
{
    [self removePanGestureRecognizer];
    _panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    [_panGesture setMaximumNumberOfTouches:1];
    [_panGesture setMaximumNumberOfTouches:1];
    [self addGestureRecognizer:_panGesture];
    [_panGesture release];
}


- (void)removePanGestureRecognizer
{
    if (_panGesture != nil) {
        [self removeGestureRecognizer:_panGesture];
        _panGesture = nil;
    }
    
}

- (void)animationDidStop
{
    kKeyWindow.userInteractionEnabled = YES;
    switch (_displayType) {
        case CPDisplayFromLeft:
        {
            self.backgroundColor = [UIColor clearColor];
            [self addPanGestureRecognizer];
        }
            break;
        case CPDisplayHideFromRight:
        {
            self.backgroundColor = [UIColor whiteColor];
            self.displayArea.frame = CGRectMake(0, 0, FScreenWidth, FScreenHeight);
            self.frame = CGRectMake(-FScreenWidth, 0, FScreenWidth, FScreenHeight);
            [self removePanGestureRecognizer];
        }
            break;
        case CPDisplayWhenEnterForeground:
        {
            self.transform = CGAffineTransformMakeScale(1.0, 1.0);
            self.frame = CGRectMake(-FScreenWidth, 0, FScreenWidth, FScreenHeight);
            self.alpha = 1;
            [self removeFromSuperview];
        }
            break;
        default:
            break;
    }
    
    _displayType = CPDisplayTypeNone;
}


- (void)disappearWithAnimation
{
    __block CPPreDisplayArea* weakSelf = self;
    [CPViewAnimations animationWithDuration:kDisappearAnimationDuration endAction:@selector(animationDidStop) target:self block:^{
        weakSelf.alpha = 0;
        weakSelf.transform = CGAffineTransformMakeScale(2.0, 2.0);
    }];
}

@end
