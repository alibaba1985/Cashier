//
//  CPGoodsDetailCell.h
//  Cashier
//
//  Created by liwang on 14-2-16.
//  Copyright (c) 2014年 liwang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CPGoodsDetailDelegate <NSObject>

- (void)didSelectedDetailCell:(NSInteger)tag;

@end

@interface CPGoodsDetailCell : UIView
{
    CAShapeLayer *_lineLayer;
    UILabel      *_goodsNameLabel;
    UILabel      *_goodsPriceLabel;
}

@property(nonatomic, readonly)NSString *goodsName;
@property(nonatomic, readonly)NSString *goodsPrice;
@property(nonatomic, assign)id<CPGoodsDetailDelegate> delegate;

- (id)initWithFrame:(CGRect)frame name:(NSString *)name price:(NSString *)price;

@end
