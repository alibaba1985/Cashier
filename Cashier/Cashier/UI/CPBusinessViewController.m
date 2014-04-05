//
//  CPBusinessViewController.m
//  Cashier
//
//  Created by liwang on 14-1-21.
//  Copyright (c) 2014年 liwang. All rights reserved.
//

#import "CPBusinessViewController.h"
#import "CPGoodsCollection.h"
#import "CPGoodsCountIndicator.h"
#import "CPViewAnimations.h"
#import "CPConstDefine.h"

#import "CPGoodsCategoryCell.h"
#import "CPDataBaseManager.h"

#define kClassScrollHeight  80

#define kCommMargin 35

#define kCarWidth    200
#define kCarHeight   75
#define kOrderMargin 130
#define kOrderDuration 0.25

#define kNullPrice    @"0.00"

@interface CPBusinessViewController ()
{
    UIScrollView *_classScroll;
    UIScrollView *_contentScroll;
    CPGoodsCollection *_goodsCollection;
    UIButton *_shoppingCar;
    CGRect _orderOriginalFrame;
    CGRect _orderFullFrame;
    NSMutableArray *_curOrdersList;
    NSString *_curTotalPrice;
    UIViewController *_orderBaseVC;
    
    BOOL _orderWillDismiss;
}

@property(nonatomic, retain)UINavigationController *orderNavigationController;
@property(nonatomic, retain)UIView *orderMaskView;
@property(nonatomic, retain)NSString *totalPrice;
@property(nonatomic, retain)CPOrderMangerViewController *orderManageVC;

- (void)showOrderManageView;

- (void)hideOrderManageView;

- (void)initOrderManageView;

@end

@implementation CPBusinessViewController
@synthesize orderNavigationController;
@synthesize orderMaskView;
@synthesize totalPrice;
@synthesize orderManageVC;

- (void)dealloc
{
    self.orderNavigationController = nil;
    self.orderManageVC = nil;
    self.orderMaskView = nil;
    self.totalPrice = nil;
    FRelease(_curOrdersList);
    FRelease(_curTotalPrice);
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)shoppingCarTouchOutAction:(UIButton *)button
{
    button.backgroundColor = [CPValueUtility colorWithR:0x00 g:0x80 b:0x00 alpha:1.0];
    button.backgroundColor = [CPValueUtility colorWithR:0xD3 g:0xD3 b:0xD3 alpha:0.3];
}

- (void)shoppingCarTouchInAction:(UIButton *)button
{
    button.backgroundColor = [CPValueUtility colorWithR:0xD3 g:0xD3 b:0xD3 alpha:0.3];
}

- (void)shoppingCarTouchDownAction:(UIButton *)button
{
    button.backgroundColor = [CPValueUtility colorWithR:0xD3 g:0xD3 b:0xD3 alpha:0.3];
}

- (void)touchDownAction:(UIButton *)button
{
    
    
     /*

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
      */
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    _curOrdersList = [[NSMutableArray alloc] init];
    _curTotalPrice = [[NSString alloc] initWithString:@"0.00"];
    UIView *title = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    title.backgroundColor = [UIColor clearColor];
    title.clipsToBounds = YES;
    
    UILabel *label = [CPCocoaSubViews labelWithFrame:title.bounds text:@"营业" alignment:NSTextAlignmentCenter color:[UIColor blackColor] font:[UIFont systemFontOfSize:20]];
    [title addSubview:label];
    [self.navigationItem setTitleView:title];
    [title release];
    
    self.view.backgroundColor = [UIColor yellowColor];
    CGRect classFrame = CGRectMake(0, 0, FScreenWidth, kClassScrollHeight);
    _classScroll = [[UIScrollView alloc] initWithFrame:classFrame];
    _classScroll.contentInset = UIEdgeInsetsZero;
    _classScroll.clipsToBounds = YES;
    _classScroll.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_classScroll];
    
    
    CGFloat x = 20;
    NSArray *defaultGoods = nil;
    NSArray *array = [[CPDataBaseManager shareInstance] searchInfoByKey:nil inTable:nil];
    if (array != nil) {
        
        for (NSInteger i = 0; i < array.count; i++) {
            CGRect frame = CGRectMake(x, 10, 60, 60);
            NSDictionary *info = [array objectAtIndex:i];
            CPGoodsCategoryCell *cell = [[CPGoodsCategoryCell alloc] initWithFrame:frame infos:info];
            [_classScroll addSubview:cell];
            cell.cateDelegate = self;
            
            x += 70;
            
            if (i == 0) {
                _currentCateCell = cell;
                [_currentCateCell setStatusSelected];
                NSString *value = [_currentCateCell.goodsCategory objectForKey:kDBValue];
                defaultGoods = [[CPDataBaseManager shareInstance] querySubGoodsByKeyValue:value];
            }
        }
    }
    
    CGRect collectionFrame = CGRectMake(0, CGRectGetMaxY(_classScroll.frame), FScreenWidth, FScreenHeight - 64 - kClassScrollHeight);
    _goodsCollection = [[CPGoodsCollection alloc] initWithFrame:collectionFrame goods:defaultGoods];
    _goodsCollection.goodsDelegate = self;
    [self.view addSubview:_goodsCollection];
    [_goodsCollection release];
    
    
    CGRect carFrame = CGRectMake(FScreenWidth - kCarWidth - kCommMargin, CGRectGetMaxY(_goodsCollection.frame)+ kCommMargin, kCarWidth, kCarHeight);
    _shoppingCar = [CPCocoaSubViews buttonWithFrame:carFrame title:@"￥0.00" normalImage:[UIImage imageNamed:@"greenBtn.png"] highlightImage:[UIImage imageNamed:@"grayBtn.png"] target:self action:@selector(showOrderListAction:)];
    //[_shoppingCar addTarget:self action:@selector(shoppingCarTouchDownAction:) forControlEvents:UIControlEventTouchDown];
    //[_shoppingCar addTarget:self action:@selector(shoppingCarTouchOutAction:) forControlEvents:UIControlEventTouchDragOutside];
    //[_shoppingCar addTarget:self action:@selector(shoppingCarTouchInAction:) forControlEvents:UIControlEventTouchDragInside];
    _shoppingCar.titleLabel.font = [UIFont boldSystemFontOfSize:24];
    
    [self.view addSubview:_shoppingCar];
    
    
    //
    [self initOrderManageView];
    
}

- (void)didSelectedCategoryCell:(CPGoodsCategoryCell *)cell value:(NSString *)value
{
    if (cell == _currentCateCell) {
        return;
    }
    
    [_currentCateCell setStatusNoSelected];
    _currentCateCell = cell;
    
    NSArray *subArray = [[CPDataBaseManager shareInstance] querySubGoodsByKeyValue:value];
    [_goodsCollection reloadGoods:subArray];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)showOrderListAction:(UIButton *)button
{
    
 
    [self showOrderManageView];
    
    
    
}

- (void)orderViewWillHidden
{
    __block UIViewController *c = [self.orderNavigationController.viewControllers objectAtIndex:0];
    __block CPBusinessViewController *blockSelf = self;
    
    [CPViewAnimations animationWithDuration:kOrderDuration endAction:@selector(hideOrderManageView) target:self block:^{
        blockSelf.orderNavigationController.view.transform = CGAffineTransformMakeScale(0.5, 0.5);
        //blockSelf.orderNavigationController.view.alpha = 0;
        blockSelf.orderNavigationController.navigationBar.alpha = 0;
        blockSelf.orderMaskView.alpha = 0;
        c.view.alpha = 0;
    }];
}


- (void)selectedAction:(UIButton *)button
{
    

}


#pragma mark- collection Delegate


- (void)didSelectedCellWithDetail:(NSDictionary *)detail
{
    BOOL hasCommon = NO;
    NSMutableDictionary *cell = [NSMutableDictionary dictionaryWithDictionary:detail];
    [cell setObject:@"1" forKey:kGoodsNumber];
    [cell setObject:[detail objectForKey:kDBSalePrice] forKey:kGoodsTotalPrice];
    for (NSMutableDictionary *dic in _curOrdersList) {
        if ([[dic objectForKey:kDBMenuName] isEqualToString:[cell objectForKey:kDBMenuName]]) {
            NSInteger num = [[dic objectForKey:kGoodsNumber] integerValue];
            num ++;
            NSString *newNum = [NSString stringWithFormat:@"%ld", (long)num];
            [dic setObject:newNum forKey:kGoodsNumber];
            
            CGFloat signalPrice = [[dic objectForKey:kDBSalePrice] floatValue];
            NSString *lTotalPrice = [NSString stringWithFormat:@"%.2f", signalPrice*num];
            [dic setObject:lTotalPrice forKey:kGoodsTotalPrice];
            hasCommon = YES;
            break;
        }
    }
    
    if (!hasCommon) {
        [_curOrdersList addObject:cell];
    }
    
    CGFloat curTotalPrice = [self.totalPrice floatValue];
    CGFloat price = [[detail objectForKey:kDBSalePrice] floatValue];
    curTotalPrice += price;
    
    self.totalPrice = [NSString stringWithFormat:@"%.2f", curTotalPrice];
    NSString *title = [NSString stringWithFormat:@"￥%@", self.totalPrice];
    [_shoppingCar setTitle:title forState:UIControlStateNormal];
}

#pragma mark - Order

- (void)showOrderManageView
{
    _orderWillDismiss = NO;
    [self.navigationController.view addSubview:self.orderNavigationController.view];
    [self.navigationController.view insertSubview:self.orderMaskView belowSubview:self.orderNavigationController.view];
    [self.orderNavigationController.view.layer addAnimation:[self scaleAnimation] forKey:@"transform.scale"];
    //[self.orderNavigationController.view.layer addAnimation:[self opacityAnimationFromValue:0 toValue:1] forKey:@"opacity"];
    //[self.orderMaskView.layer addAnimation:[self opacityAnimationFromValue:0 toValue:0.6] forKey:nil];
    
    self.orderMaskView.alpha = 0;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.15];
    self.orderMaskView.alpha = 0.3;
    
    [UIView commitAnimations];
    
    [self.orderManageVC reloadOrdersViewWithOrders:_curOrdersList];
    return;
    
    
    __block UIViewController *c = [self.orderNavigationController.viewControllers objectAtIndex:0];
    __block CPBusinessViewController *blockSelf = self;
    [CPViewAnimations animationWithDuration:kOrderDuration endAction:nil target:nil block:^{
        blockSelf.orderNavigationController.view.transform = CGAffineTransformMakeScale(1, 1);
        blockSelf.orderNavigationController.navigationBar.alpha = 1;
        blockSelf.orderNavigationController.view.alpha = 1;
        c.view.alpha = 1;
        blockSelf.orderMaskView.alpha = 0.3;
    }];
    
}

- (void)hideOrderManageView
{
    [self.orderMaskView removeFromSuperview];
    [self.orderNavigationController.view removeFromSuperview];
}

- (CAKeyframeAnimation *)scaleAnimation
{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    animation.duration = 0.15;
    animation.delegate = self;
    animation.removedOnCompletion = YES;
    animation.fillMode = kCAFillModeForwards;
    animation.timingFunction = [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseOut];
    
    NSMutableArray *values = [NSMutableArray array];
//    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.35, 0.35, 1.0)]];
//    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.4, 0.4, 1.0)]];
//    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.45, 0.45, 1.0)]];
//    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.5, 0.5, 1.0)]];
//    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.5, 0.5, 1.0)]];
//    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.55, 0.55, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.6, 0.6, 1.0)]];
//    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.65, 0.65, 1.0)]];
//    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.7, 0.7, 1.0)]];
//    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.75, 0.75, 1.0)]];
//    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.8, 0.8, 1.0)]];
//    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.85, 0.85, 1.0)]];
//    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 1.0)]];
//    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.95, 0.95, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    
    
    
    return animation;
}

- (CAKeyframeAnimation *)scaleDisappearAnimation
{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    animation.duration = 0.15;
    animation.delegate = self;
    animation.removedOnCompletion = YES;
    animation.fillMode = kCAFillModeForwards;
    animation.timingFunction = [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseOut];
    
    NSMutableArray *values = [NSMutableArray array];
    
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
//    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.95, 0.95, 1.0)]];
//    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 1.0)]];
//    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.85, 0.85, 1.0)]];
//    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.8, 0.8, 1.0)]];
//    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.75, 0.75, 1.0)]];
//    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.7, 0.7, 1.0)]];
//    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.65, 0.65, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.6, 0.6, 1.0)]];
//    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.55, 0.55, 1.0)]];
//    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.5, 0.5, 1.0)]];
//    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.5, 0.5, 1.0)]];
//    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.45, 0.45, 1.0)]];
//    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.4, 0.4, 1.0)]];
//    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.35, 0.35, 1.0)]];
    
    animation.values = values;
    
    return animation;
}


- (CABasicAnimation *)opacityAnimationFromValue:(CGFloat)fromValue toValue:(CGFloat)toValue
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.delegate = self;
    animation.duration = 0.1;
    animation.removedOnCompletion = YES;
    //animation.timingFunction = [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseOut];
    //animation.fillMode = kCAFillModeForwards;
    animation.fromValue = [NSNumber numberWithInt:fromValue];
    animation.toValue = [NSNumber numberWithInt:toValue];

    
    return animation;
}

- (void)initOrderManageView
{
    //
    self.orderMaskView = [CPCocoaSubViews maskViewWithFrame:self.navigationController.view.bounds];
    
    self.orderMaskView.alpha = 0.3;
    
    //
    CGFloat width = FScreenWidth - kOrderMargin*2;
    CGFloat ox = (FScreenWidth - width)/2;
    _orderFullFrame = CGRectMake(ox, 0, width, FScreenHeight);
    
    self.orderManageVC = [[[CPOrderMangerViewController alloc] init] autorelease];
    self.orderManageVC.delegate = self;
    self.orderNavigationController = [[[UINavigationController alloc] initWithRootViewController:self.orderManageVC] autorelease];
    self.orderNavigationController.view.frame = _orderFullFrame;
    self.orderNavigationController.view.backgroundColor = [UIColor whiteColor];
    
}


#pragma mark - OrderDelegate

- (void)orderTotalPriceDidChange:(CGFloat)change
{
    if (change == INFINITY) {
        self.totalPrice = kNullPrice;
    }
    else
    {
        CGFloat curTotalPrice = [self.totalPrice floatValue];
        curTotalPrice += change;
        self.totalPrice = [NSString stringWithFormat:@"%.2f", curTotalPrice];
    }
    
    NSString *title = [NSString stringWithFormat:@"￥%@", self.totalPrice];
    [_shoppingCar setTitle:title forState:UIControlStateNormal];
}

- (void)orderManagerWillDismiss
{
    _orderWillDismiss = YES;
    [self.orderNavigationController.view.layer addAnimation:[self scaleDisappearAnimation] forKey:nil];
    //[self.orderNavigationController.view.layer addAnimation:[self opacityAnimationFromValue:1 toValue:0] forKey:nil];
    //[self.orderMaskView.layer addAnimation:[self opacityAnimationFromValue:0.6 toValue:0] forKey:nil];
    
}


- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (_orderWillDismiss) {
        [self.orderMaskView removeFromSuperview];
        [self.orderNavigationController.view removeFromSuperview];
    }
    else
    {
        
    }
    
}

@end
