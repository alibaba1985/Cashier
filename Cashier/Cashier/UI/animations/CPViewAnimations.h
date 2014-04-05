//
//  CPAnimations.h
//  Cashier
//
//  Created by liwang on 14-1-11.
//  Copyright (c) 2014年 liwang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


#define kSystemAnimationDuration 0.25


typedef void (^UIAnimationBlock)();


@interface CPViewAnimations : NSObject

+ (void)addSubView:(UIView *)subView toView:(UIView *)view;

+ (void)removeSubView:(UIView *)subView;

+ (void)animationForView:(UIView*)view
                   Alpha:(CGFloat)alpha
                duration:(CGFloat)duration
               endAction:(SEL)action
                  target:(id)target;

+ (void)animationWithDuration:(CGFloat)duration
                    endAction:(SEL)action
                       target:(id)target
                      block:(UIAnimationBlock)block;


+ (void)animationWithDuration:(CGFloat)duration
                    animationBlock:(UIAnimationBlock)animation
                        endBlock:(UIAnimationBlock)completion;

+ (CABasicAnimation *)opacityAnimationFromValue:(CGFloat)fromValue toValue:(CGFloat)toValue;

@end
