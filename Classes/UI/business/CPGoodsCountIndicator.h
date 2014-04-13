//
//  CPGoodsCountIndicator.h
//  Cashier
//
//  Created by liwang on 14-2-23.
//  Copyright (c) 2014年 liwang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CPGoodsCountIndicator : UIView
{
    CGPoint _moveCenter;
}

- (id)initWithCenter:(CGPoint)center count:(NSInteger)count;

- (void)moveToCenter:(CGPoint)center;


@end
