//
//  CPOrderMangerViewController.h
//  Cashier
//
//  Created by liwang on 14-2-23.
//  Copyright (c) 2014年 liwang. All rights reserved.
//

#import "CPBaseViewController.h"


@protocol CPOrderManagerDelegate <NSObject>

- (void)orderTotalPriceDidChange:(CGFloat)change;

- (void)orderManagerWillDismiss;
@end



@interface CPOrderMangerViewController : CPBaseViewController<UITableViewDataSource, UITableViewDelegate,UIGestureRecognizerDelegate>
{
    
}

@property(nonatomic, assign)id<CPOrderManagerDelegate> delegate;
@property(nonatomic, retain)NSMutableArray *orderList;

- (void)reloadOrdersViewWithOrders:(NSMutableArray *)array;

- (void)cancelAction;

- (void)clearAllAction:(UIButton *)button;

@end
