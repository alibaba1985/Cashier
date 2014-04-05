//
//  CPGoodsCategoryCell.h
//  Cashier
//
//  Created by liwang on 14-3-1.
//  Copyright (c) 2014年 liwang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CPGoodsCategoryCell;
@protocol CPGoodsCategoryDelegate <NSObject>

- (void)didSelectedCategoryCell:(CPGoodsCategoryCell *)cell value:(NSString *)value;

@end

@interface CPGoodsCategoryCell : UIView
{
    UIButton *_actionButton;
}

@property(nonatomic, retain)NSDictionary *goodsCategory;
@property(nonatomic, assign)id<CPGoodsCategoryDelegate> cateDelegate;


- (id)initWithFrame:(CGRect)frame infos:(NSDictionary *)infos;

- (void)setStatusSelected;

- (void)setStatusNoSelected;

- (void)touchDownAction:(UIButton *)button;






@end




