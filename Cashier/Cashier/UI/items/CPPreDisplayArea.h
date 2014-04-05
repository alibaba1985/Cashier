//
//  CPPreDisplayArea.h
//  Cashier
//
//  Created by liwang on 14-1-11.
//  Copyright (c) 2014年 liwang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CPPreDisplayArea : UIView
@property(nonatomic, retain)UIImageView *displayArea;


+ (CPPreDisplayArea *)currentArea;

+ (void)releaseArea;


- (void)showFromLeft;

- (void)showWhenEnterForeground;


@end
