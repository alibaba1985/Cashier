//
//  CPAnimations.m
//  Cashier
//
//  Created by liwang on 14-1-11.
//  Copyright (c) 2014年 liwang. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "CPViewAnimations.h"

@implementation CPViewAnimations

+ (void)addSubView:(UIView *)subView toView:(UIView *)view;
{
    subView.alpha = 0;
    [view insertSubview:subView atIndex:0];
    [UIView beginAnimations:@"curlup" context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.3];
    //[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:view cache:YES];
    [view addSubview:subView];
    subView.alpha = 1;
    [UIView commitAnimations];
}



+ (void)removeSubView:(UIView *)subView
{
    
    [UIView beginAnimations:@"curldown" context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:2.5];
    //UIView setAnimationDidStopSelector:@selector(<#selector#>)
    [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:subView.superview cache:YES];
    subView.alpha = 0;
    [subView removeFromSuperview];
    [UIView commitAnimations];
    
}


+ (void)animationForView:(UIView*)view
                   Alpha:(CGFloat)alpha
                duration:(CGFloat)duration
               endAction:(SEL)action
                  target:(id)target
{
    [UIView beginAnimations:@"alpha" context:nil];
    [UIView setAnimationDelegate:target];
    [UIView setAnimationDuration:duration];
    [UIView setAnimationDidStopSelector:action];
    view.alpha = alpha;
    [UIView commitAnimations];
}

+ (void)animationWithDuration:(CGFloat)duration
                    endAction:(SEL)action
                       target:(id)target
                      block:(UIAnimationBlock)block
{
    [UIView beginAnimations:@"block" context:nil];
    [UIView setAnimationDelegate:target];
    [UIView setAnimationDuration:duration];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDidStopSelector:action];
    block();
    [UIView commitAnimations];
}

+ (void)animationWithDuration:(CGFloat)duration
               animationBlock:(UIAnimationBlock)animation
                     endBlock:(UIAnimationBlock)completion
{
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{animation();}
        completion:^(BOOL finished) {
            completion();
    }];
}

+ (CABasicAnimation *)opacityAnimationFromValue:(CGFloat)fromValue toValue:(CGFloat)toValue
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.duration = kSystemAnimationDuration;
    animation.removedOnCompletion = YES;
    animation.timingFunction = [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseOut];
    animation.fillMode = kCAFillModeForwards;
    animation.fromValue = [NSNumber numberWithInt:fromValue];
    animation.toValue = [NSNumber numberWithInt:toValue];
    
    return animation;
}

@end
