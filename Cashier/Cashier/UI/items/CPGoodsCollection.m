//
//  CPGoodsCollection.m
//  Cashier
//
//  Created by liwang on 14-2-16.
//  Copyright (c) 2014年 liwang. All rights reserved.
//

#import "CPGoodsCollection.h"
#import "CPGoodsDetailCell.h"
#import "CPConstDefine.h"
#import "CPCocoaSubViews.h"
#import "CPOrderMangerViewController.h"
#include <stdlib.h>


#define kGoodsFontSize  22
#define kMarin 50
#define kCellHeight 44
#define kCellWidth (FScreenWidth-2*kCloMargin - 2*kCommMargin)/3
#define kLetterSize 35

#define kCommMargin 20
#define kRowMargin  28
#define kCloMargin  50

#define kCarWidth    180
#define kCarHeight   60

@implementation CPGoodsCollection
@synthesize goodsList;
@synthesize goodsDelegate;

- (void)dealloc
{
    self.goodsDelegate = nil;
    self.goodsList = nil;
    [super dealloc];
}

- (void)selectedAction:(UIButton *)button
{
    
}




- (void)touchDownAction:(UIButton *)button
{
    if (_currentTypeBtn == button) {
        return;
    }
    [button setSelected:YES];
    button.backgroundColor = [CPValueUtility colorWithR:0x00 g:0x80 b:0x00 alpha:1.0];
    button.layer.borderWidth = 0;
    
    [_currentTypeBtn setSelected:NO];
    _currentTypeBtn.backgroundColor = [UIColor whiteColor];
    _currentTypeBtn.layer.borderWidth = 1;
    
    _currentTypeBtn = button;
}

- (id)initWithFrame:(CGRect)frame goods:(NSArray *)goods
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.goodsList = goods;
        self.clipsToBounds = YES;
        NSArray *letters = @[@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O"];
        
        UIView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(kMarin, 0 , CGRectGetWidth(frame), kLetterSize)];
        scrollView.backgroundColor = [UIColor clearColor];
        NSInteger index = 0;
        
        for (NSInteger i = 0; i< 15; i++) {
            NSInteger x = (i==0) ? ((60-kLetterSize)/2 + kCommMargin) : kCommMargin + (60-kLetterSize)/2 + index*(kLetterSize+10);
            
            UIButton *btn = [CPCocoaSubViews roundButtonWithFrame:CGRectMake(x, 0, kLetterSize, kLetterSize) title:[letters objectAtIndex:i] normalImage:nil highlightImage:nil target:nil action:@selector(selectedAction:)];
            [btn addTarget:self action:@selector(touchDownAction:) forControlEvents:UIControlEventTouchDown];
            
            if (i==0) {
                [btn setSelected:YES];
                btn.backgroundColor = [CPValueUtility colorWithR:0x00 g:0x80 b:0x00 alpha:1.0];
                btn.layer.borderWidth = 0;
                _currentTypeBtn = btn;
            }
            
            [self addSubview:btn];
            
            index++;
        }
        
        CAShapeLayer *layer = [CPCocoaSubViews lineLayerWithStartPoint:CGPointMake(0, 45) endPoint:CGPointMake(FScreenWidth, 45) width:1 color:[CPValueUtility colorWithR:0xD3 g:0xD3 b:0xD3 alpha:1]];
        layer.lineWidth = 0.5;
        [self.layer addSublayer:layer];
        
        
        
        
        
        [self reloadGoods:goods];
        
    }
    return self;
}


- (void)reloadGoods:(NSArray *)goods
{
    NSInteger clo = 0;
    NSInteger row = 0;
    
    if (_goodsBackgroundView != nil) {
        [_goodsBackgroundView removeFromSuperview];
        _goodsBackgroundView = nil;
    }
    
    _goodsBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, kMarin+20, self.bounds.size.width, kMarin)];
    _goodsBackgroundView.backgroundColor = [UIColor clearColor];
    [self addSubview:_goodsBackgroundView];
    [_goodsBackgroundView release];
    
    for (NSInteger i = 0; i<goods.count; i++) {
        CGFloat x = (clo==0) ? kCommMargin : (kCommMargin+(kCloMargin+kCellWidth)*clo);
        CGRect cellFrame = CGRectMake(x, (kRowMargin+kCellHeight)*row, kCellWidth , kCellHeight);
        NSDictionary *nameDic = [goods objectAtIndex:i];
        NSString *name = [nameDic objectForKey:kDBMenuName];
        NSString *price = [nameDic objectForKey:kDBSalePrice];
        CPGoodsDetailCell *cell = [[CPGoodsDetailCell alloc] initWithFrame:cellFrame name:name price:price];
        cell.delegate = self;
        cell.tag = i;
        [_goodsBackgroundView addSubview:cell];
        
        if (row ==5) {
            CGRect oldFrame = self.frame;
            oldFrame.size.height = CGRectGetMaxY(cell.frame) + kMarin + 20;
            self.frame = oldFrame;
            
            oldFrame = _goodsBackgroundView.frame;
            oldFrame.size.height = CGRectGetMaxY(cell.frame);
            _goodsBackgroundView.frame = oldFrame;
            
            clo++;
            row=0;
        }
        else
        {
            row++;
        }
    }
}


- (void)didSelectedDetailCell:(NSInteger)tag
{
    [self.goodsDelegate didSelectedCellWithDetail:[self.goodsList objectAtIndex:tag]];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
