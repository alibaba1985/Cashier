//
//  UIViewController+SubView.h
//  Cashier
//
//  Created by liwang on 14-4-13.
//  Copyright (c) 2014年 liwang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIViewController (MiddlePresentation)

- (void)addMiddlePresentationView:(UIView *)view;


- (void)removeMiddlePresentationView:(UIView *)view;

@end



@interface UIView (MiddlePresentation)

- (void)removeFromMiddle;

@end