//
//  UIViewController+SubView.m
//  Cashier
//
//  Created by liwang on 14-4-13.
//  Copyright (c) 2014年 liwang. All rights reserved.
//

#import "UIViewController+SubView.h"
#import "CPCocoaSubViews.h"
#import "CPViewAnimations.h"
#import "CPConstDefine.h"


#define kMiddlePresentAnimationDuration 0.15

#define kMaskViewTag 6666
#define kMiddlePresentationView 8888


@implementation UIViewController (MiddlePresentation)




- (void)showMiddlePresentationView:(UIView *)view
{
    UIView *mask = [CPCocoaSubViews maskViewWithFrame:self.navigationController.view.bounds];
    mask.tag = kMaskViewTag;
    mask.alpha = 0;
    [self.navigationController.view addSubview:mask];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:kFastSystemAnimationDuration];
    mask.alpha = 0.5;
    [UIView commitAnimations];
    
    CGFloat offset = fabs(FScreenHeight - FScreenWidth);
    CGFloat width = FScreenWidth - offset;
    CGFloat ox = offset/2;
    view.frame = CGRectMake(ox, 0, width, FScreenHeight);
    view.tag = kMiddlePresentationView;
    //[view.layer addAnimation:[CPViewAnimations opacityAnimationFromValue:0 toValue:1 durtion:kFastSystemAnimationDuration] forKey:@"opacity"];
    [view.layer addAnimation:[CPViewAnimations scaleAnimationFromValue:0.5 toValue:1.0 duration:kFastSystemAnimationDuration] forKey:@"transform.scale"];
    
    [self.navigationController.view addSubview:view];
}


- (void)middleAnimationStopAction
{
    UIView *mask = [self.navigationController.view viewWithTag:kMaskViewTag];
    UIView *middle = [self.navigationController.view viewWithTag:kMiddlePresentationView];
    [mask removeFromSuperview];
    [middle removeFromSuperview];
}

- (void)hideMiddlePresentationView:(UIView *)view
{
    [view.layer addAnimation:[CPViewAnimations scaleAnimationFromValue:1.0 toValue:0.5 duration:kFastSystemAnimationDuration] forKey:@"transform.scale"];
    //[view.layer addAnimation:[CPViewAnimations opacityAnimationFromValue:0.5 toValue:0 durtion:kFastSystemAnimationDuration] forKey:@"opacity"];
    UIView *mask = [self.navigationController.view viewWithTag:kMaskViewTag];
    if (mask != nil) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:kFastSystemAnimationDuration];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(middleAnimationStopAction)];
        mask.alpha = 0;
        [UIView commitAnimations];
        
    }
}

@end



@implementation UIView (MiddlePresentation)



- (void)removeFromMiddle
{
    UIView *mask = [self.superview viewWithTag:kMaskViewTag];
    if (mask != nil) {
        
    }
}

@end