//
//  CPBusinessViewController.h
//  Cashier
//
//  Created by liwang on 14-1-21.
//  Copyright (c) 2014年 liwang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CPBaseViewController.h"
#import "CPGoodsCategoryCell.h"
#import "CPGoodsCollection.h"
#import "CPOrderMangerViewController.h"

#define kSize 0.4



@interface CPBusinessViewController : CPBaseViewController<CPGoodsCategoryDelegate,CPGoodsCollectionDelegate,CPOrderManagerDelegate>
{
    CPGoodsCategoryCell *_currentCateCell;
}
- (void)selectedAction:(UIButton *)button;

- (void)showOrderListAction:(UIButton *)button;

- (void)orderViewWillHidden;

@end
