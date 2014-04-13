//
//  CPGoodsCollection.h
//  Cashier
//
//  Created by liwang on 14-2-16.
//  Copyright (c) 2014年 liwang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CPGoodsDetailCell.h"

@protocol CPGoodsCollectionDelegate <NSObject>

- (void)didSelectedCellWithDetail:(NSDictionary *)detail;

@end

@interface CPGoodsCollection : UIScrollView<CPGoodsDetailDelegate>
{
    UIButton *_currentTypeBtn;
    UIView *_goodsBackgroundView;
}

@property(nonatomic, retain)NSArray *goodsList;
@property(nonatomic, assign)id<CPGoodsCollectionDelegate> goodsDelegate;

- (id)initWithFrame:(CGRect)frame goods:(NSArray *)goods;

- (void)selectedAction:(UIButton *)button;

- (void)reloadGoods:(NSArray *)goods;


@end
