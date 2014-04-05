//
//  CPGoodsDetailCell.m
//  Cashier
//
//  Created by liwang on 14-2-16.
//  Copyright (c) 2014年 liwang. All rights reserved.
//

#import "CPGoodsDetailCell.h"
#import "CPCocoaSubViews.h"
#import "CPValueUtility.h"
#import "CPConstDefine.h"
#import "CPGoodsCountIndicator.h"

@interface CPGoodsDetailCell ()
{
    NSString *_goodsName;
    NSString *_goodsPrice;
    
    UIView *_bgView;
}

- (void)touchDownAction:(UIButton *)button;

- (void)touchInAction:(UIButton *)button;

- (void)touchOutAction:(UIButton *)button;

- (void)touchUpInsideAction:(UIButton *)button;


@end

@implementation CPGoodsDetailCell
@synthesize goodsName = _goodsName;
@synthesize goodsPrice = _goodsPrice;
@synthesize delegate;

#define kValue  0.7
#define kMargin 10
#define kFontSize 30

- (void)dealloc
{
    
    self.delegate = nil;
    FRelease(_goodsName);
    FRelease(_goodsPrice);
    
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame name:(NSString *)name price:(NSString *)price
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.backgroundColor = [UIColor clearColor];
        //self.clipsToBounds = YES;
        _goodsName = [[NSString alloc] initWithString:name];
        _goodsPrice = [[NSString alloc] initWithString:price];
        //
        UIFont *font = [UIFont fontWithName:@"Heiti SC Medium" size:kFontSize];
        //UIFont *font = [UIFont systemFontOfSize:kFontSize];
        CGRect nameFrame = CGRectMake(0, 0, frame.size.width*kValue, frame.size.height-4);
        _goodsNameLabel = [CPCocoaSubViews labelWithFrame:nameFrame text:_goodsName alignment:NSTextAlignmentLeft color:[UIColor blackColor] font:font];
        
        CGRect priceFrame = CGRectMake(frame.size.width*kValue + kMargin, 0, frame.size.width*(1-kValue)-kMargin, frame.size.height);
        _goodsPriceLabel = [CPCocoaSubViews labelWithFrame:priceFrame text:_goodsPrice alignment:NSTextAlignmentRight color:[UIColor blackColor] font:font];
        
        _lineLayer = [CPCocoaSubViews lineLayerWithStartPoint:CGPointMake(0, frame.size.height) endPoint:CGPointMake(frame.size.width, frame.size.height) width:frame.size.width color:[CPValueUtility colorWithR:0xD3 g:0xD3 b:0xD3 alpha:1]];
        _lineLayer.lineWidth = 2;
        
        _bgView = [[UIView alloc] initWithFrame:self.bounds];
        _bgView.backgroundColor = [UIColor whiteColor];
        _bgView.clipsToBounds = YES;
        
        [_bgView addSubview:_goodsNameLabel];
        [_bgView addSubview:_goodsPriceLabel];
        [_bgView.layer addSublayer:_lineLayer];
        _bgView.userInteractionEnabled = NO;
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setFrame:self.bounds];
        [button addSubview:_bgView];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [button setTitleColor:[CPValueUtility colorWithR:0x00 g:0x80 b:0x00 alpha:1.0] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [button setBackgroundColor:[CPValueUtility colorWithR:0xD3 g:0xD3 b:0xD3 alpha:0.3]];
        [button addTarget:self  action:@selector(touchUpInsideAction:) forControlEvents:UIControlEventTouchUpInside];
        [button addTarget:self  action:@selector(touchInAction:) forControlEvents:UIControlEventTouchDragInside];
        [button addTarget:self  action:@selector(touchOutAction:) forControlEvents:UIControlEventTouchDragOutside];
        [button addTarget:self  action:@selector(touchDownAction:) forControlEvents:UIControlEventTouchDown];
        
        
        
        
        
        button.layer.cornerRadius = 3;
        button.layer.masksToBounds = YES;
        
        button.exclusiveTouch = YES;
        [self addSubview:button];
    }
    return self;
}

- (void)touchDownAction:(UIButton *)button
{
    _bgView.backgroundColor = [UIColor grayColor];
    CGPoint originPoint = CGPointMake(CGRectGetMaxX(button.frame), CGRectGetMinY(button.frame));
    CGPoint fromCenter = [button convertPoint:originPoint toView:self.superview.superview.superview];
    CPGoodsCountIndicator *indicator = [[CPGoodsCountIndicator alloc] initWithCenter:fromCenter count:1];
    UIView *ssuperview = [self.superview.superview.superview viewWithTag:10000];
    CGPoint center = ssuperview.center;;
    [self.superview.superview.superview addSubview:indicator];
    [indicator release];
    [indicator moveToCenter:center];
}

- (void)touchInAction:(UIButton *)button
{
    _bgView.backgroundColor = [UIColor grayColor];
}

- (void)touchOutAction:(UIButton *)button
{
    _bgView.backgroundColor = [UIColor whiteColor];
}

- (void)touchUpInsideAction:(UIButton *)button
{
    _bgView.backgroundColor = [UIColor whiteColor];
    
    [self.delegate didSelectedDetailCell:self.tag];
    
    
}

@end
