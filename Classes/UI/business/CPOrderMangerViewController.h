//
//  CPOrderMangerViewController.h
//  Cashier
//
//  Created by liwang on 14-2-23.
//  Copyright (c) 2014年 liwang. All rights reserved.
//

#import "CPBaseViewController.h"
#import "CPOrderEditCell.h"


@protocol CPOrderManagerDelegate <NSObject>

- (void)orderTotalPriceDidChange:(CGFloat)change;

- (void)orderManagerWillDismiss;
@end



@interface CPOrderMangerViewController : CPBaseViewController<UITableViewDataSource, UITableViewDelegate,UIGestureRecognizerDelegate,CPOrderEditDelegate>
{
    
}

@property(nonatomic, assign)id<CPOrderManagerDelegate> delegate;
@property(nonatomic, retain)NSMutableArray *orderList;
@property(nonatomic, retain)NSString *curTotalAmount;

- (void)reloadOrdersViewWithOrders:(NSMutableArray *)array totalAmount:(NSString *)totalAmount;

- (void)cancelAction;

- (void)clearAllAction:(UIButton *)button;

@end
