//
//  CPOrderMangerViewController.m
//  Cashier
//
//  Created by liwang on 14-2-23.
//  Copyright (c) 2014年 liwang. All rights reserved.
//

#import "CPOrderMangerViewController.h"

#define kMargin 50

#define kBottomHeight 100

#define kNavBarHeight 64

#define kTableRowHeight 64

#define kButtonWidth   200

#define kButtonHeight  54

#define kLineWidth 0.3

@interface CPOrderMangerViewController ()
{
    UITableView *_orderTable;
    UIButton *_payNowButton;
    UIButton *_payLaterButton;
    UIButton *_clearAllButton;
    
    UIView *_clearCellBgView;
    UILabel *_clearTitleLabel;
    NSInteger _maxRowNumbers;
    BOOL _didSelectedRow;
    BOOL _shouldClearAllRows;
}
@property(nonatomic, retain)NSIndexPath *curIndexPath;

- (CGFloat)tableHeight;

- (void)addActionButtons;

- (void)payLaterAction:(UIButton *)button;

- (void)payBowAction:(UIButton *)button;

- (void)showEditView;

- (void)hideEditView;

- (void)deleteAction:(UIButton *)button;

- (void)addAction:(UIButton *)button;

- (void)cutAction:(UIButton *)button;

- (void)addTapGesture;

- (CGFloat)getSigalPriceByIndex:(NSInteger)index;

- (CGFloat)getTotalPriceByIndex:(NSInteger)index;

- (void)clearButtonCancelReady;

@end

@implementation CPOrderMangerViewController
@synthesize delegate;
@synthesize orderList;
@synthesize curIndexPath;

- (void)dealloc
{
    self.orderList = nil;
    self.delegate = nil;
    self.curIndexPath = nil;
    
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



- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.title = @"已点商品";
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(cancelAction)];
    self.navigationItem.leftBarButtonItem = item;
    [item release];
    
    CGRect tableFrame = CGRectMake(5, 0, CGRectGetWidth(self.view.frame)-10, FScreenHeight - kNavBarHeight - kBottomHeight);
    _orderTable = [[UITableView alloc] initWithFrame:tableFrame style:UITableViewStylePlain];
    _orderTable.showsVerticalScrollIndicator = YES;
    _orderTable.backgroundColor = [UIColor clearColor];
    [_orderTable setExclusiveTouch:YES];
    _orderTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    _orderTable.dataSource = self;
    _orderTable.delegate = self;
    
    if ([CPValueUtility iOS7Device]) {
        _orderTable.separatorInset = UIEdgeInsetsZero;
    }
    
    [self.view addSubview:_orderTable];
    [_orderTable release];
    
    [self addActionButtons];
    [self addTapGesture];
    //self.navigationController.navigationBarHidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    
}






- (void)addTapGesture
{
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clearButtonCancelReady)];
    tapGesture.numberOfTapsRequired = 1;
    tapGesture.numberOfTouchesRequired = 1;
    tapGesture.delegate = self;
    [self.view addGestureRecognizer:tapGesture];
    [tapGesture release];
}


- (void)reloadOrdersViewWithOrders:(NSMutableArray *)array
{
    self.orderList = array;
    _orderTable.alpha = 1;
    [_orderTable reloadData];
}



- (void)addActionButtons
{
    CGFloat width = CGRectGetWidth(self.view.frame);
    CGFloat height = FScreenHeight - kNavBarHeight - kBottomHeight;
    CGFloat margin = (width - kButtonWidth*2) / 3;
    CGFloat x = margin;
    CGFloat y = (kBottomHeight - kButtonHeight) / 2 ;
    CGRect payLaterFrame = CGRectMake(x, y, kButtonWidth, kButtonHeight);
    
    UIView *bottom = [[UIView alloc] initWithFrame:CGRectMake(0, height, width, kBottomHeight)];
    bottom.backgroundColor = [UIColor clearColor];
    CAShapeLayer *layer = [CPCocoaSubViews lineLayerWithStartPoint:CGPointMake(0, 0)
                                                          endPoint:CGPointMake(width, 0)
                                                             width:kLineWidth
                                                             color:[UIColor grayColor]];
    [bottom.layer addSublayer:layer];
    [self.view addSubview:bottom];
    [bottom release];
    
    _payLaterButton = [CPCocoaSubViews buttonWithFrame:payLaterFrame
                                                 title:@"稍后支付"
                                           normalImage:[UIImage imageNamed:@"grayBtn.png"]
                                        highlightImage:[UIImage imageNamed:@"greenBtn.png"] target:self
                                                action:@selector(payLaterAction:)];
    [_payLaterButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_payLaterButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [bottom addSubview:_payLaterButton];
    
    x += margin + kButtonWidth;
    CGRect payNowFrame = CGRectMake(x, y, kButtonWidth, kButtonHeight);
    
    _payNowButton = [CPCocoaSubViews buttonWithFrame:payNowFrame
                                               title:@"立即支付"
                                         normalImage:[UIImage imageNamed:@"greenBtn.png"]
                                      highlightImage:[UIImage imageNamed:@"grayBtn.png"]
                                              target:self
                                              action:@selector(payBowAction:)];
    [_payNowButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_payNowButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [bottom addSubview:_payNowButton];
}

- (void)showEditView
{
    [_orderTable beginUpdates];
    NSArray *array = [NSArray arrayWithObjects:self.curIndexPath, nil];
    [_orderTable insertRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationTop];
    [_orderTable endUpdates];
}

- (void)hideEditView
{
    
    [_orderTable beginUpdates];
    NSArray *array = [NSArray arrayWithObjects:self.curIndexPath, nil];
    self.curIndexPath = nil;
    [_orderTable deleteRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationTop];
    [_orderTable endUpdates];
}


- (CGFloat)getSigalPriceByIndex:(NSInteger)index
{
    return 0;
}

- (CGFloat)getTotalPriceByIndex:(NSInteger)index
{
    return 0;
}


- (void)clearButtonCancelReady
{
    _shouldClearAllRows = NO;
    // 首先判断clearButton是否已经显示
    NSInteger rowNumbers = [_orderTable numberOfRowsInSection:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:rowNumbers-1 inSection:0];
    if ([_orderTable.indexPathsForVisibleRows containsObject:indexPath]) {
        _clearAllButton.selected = NO;
        [_clearAllButton setBackgroundColor:[UIColor clearColor]];
        [_clearAllButton setTitle:@"清除订单" forState:UIControlStateNormal];
        [_clearAllButton setTitleColor:[CPValueUtility colorWithR:0x00 g:0x80 b:0x00 alpha:1.0] forState:UIControlStateNormal];
    }
}


#pragma mark - Button Actions

- (void)payLaterAction:(UIButton *)button
{
    
}

- (void)payBowAction:(UIButton *)button
{
    
}

- (void)deleteAction:(UIButton *)button
{
    NSInteger row = self.curIndexPath.row-1;
    NSMutableDictionary *dic = [self.orderList objectAtIndex:row];
    CGFloat totalPrice = [[dic objectForKey:kGoodsTotalPrice] floatValue];
    
    [self.orderList removeObjectAtIndex:row];
    self.curIndexPath = nil;
    
    [_orderTable reloadData];
    [self.delegate orderTotalPriceDidChange:-totalPrice];
    
    if (self.orderList.count == 0) {
        [self.delegate orderManagerWillDismiss];
    }
}

- (void)addAction:(UIButton *)button
{
    NSInteger row = self.curIndexPath.row-1;
    NSMutableDictionary *dic = [self.orderList objectAtIndex:row];
    NSInteger num = [[dic objectForKey:kGoodsNumber] integerValue] + 1;
    
    NSString *newNum = [NSString stringWithFormat:@"%ld", (long)num];
    [dic setObject:newNum forKey:kGoodsNumber];
    
    CGFloat signalPrice = [[dic objectForKey:kDBSalePrice] floatValue];
    NSString *lTotalPrice = [NSString stringWithFormat:@"%.2f", signalPrice*num];
    [dic setObject:lTotalPrice forKey:kGoodsTotalPrice];
    
    [_orderTable reloadData];
    [self.delegate orderTotalPriceDidChange:signalPrice];
}

- (void)cutAction:(UIButton *)button
{
    
    NSInteger row = self.curIndexPath.row-1;
    NSMutableDictionary *dic = [self.orderList objectAtIndex:row];
    CGFloat signalPrice = [[dic objectForKey:kDBSalePrice] floatValue];
    NSInteger num = [[dic objectForKey:kGoodsNumber] integerValue] - 1;
    
    if (num == 0) {
        [self deleteAction:button];
    }
    else
    {
        NSString *newNum = [NSString stringWithFormat:@"%ld", (long)num];
        [dic setObject:newNum forKey:kGoodsNumber];
        NSString *lTotalPrice = [NSString stringWithFormat:@"%.2f", signalPrice*num];
        [dic setObject:lTotalPrice forKey:kGoodsTotalPrice];
        [_orderTable reloadData];
        [self.delegate orderTotalPriceDidChange:-signalPrice];
    }
    
}


- (void)cancelAction
{
    if (self.curIndexPath != nil) {
        [self hideEditView];
    }
    [self.delegate orderManagerWillDismiss];
}

- (void)clearAllAction:(UIButton *)button
{
    if (button.selected) {
        [button setBackgroundColor:[UIColor clearColor]];
        [button setTitle:@"清除订单" forState:UIControlStateNormal];
        [button setTitleColor:[CPValueUtility colorWithR:0x00 g:0x80 b:0x00 alpha:1.0] forState:UIControlStateNormal];
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(clearAllAnimationDidStop)];
        _orderTable.alpha = 0;
        
        [UIView commitAnimations];
        
    }
    else
    {
        [button setBackgroundColor:[UIColor redColor]];
        [button setTitle:@"确认清除" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    button.selected = !button.selected;
}

#pragma mark - Table view data source

- (CGFloat)tableHeight
{
    CGFloat maxHeight = FScreenHeight - kNavBarHeight - kBottomHeight;
    NSInteger rows = (self.curIndexPath != nil) ? self.orderList.count + 2 : self.orderList.count+1;
    CGFloat height = rows * kTableRowHeight;
    height = (height >= maxHeight) ? maxHeight : height;
    if (height >= maxHeight) {
        _orderTable.scrollEnabled = YES;
        height = maxHeight;
    }
    else
    {
        _orderTable.scrollEnabled = NO;
    }
    return height;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    _maxRowNumbers = 0;
    if (self.orderList.count != 0) {
        _maxRowNumbers = (self.curIndexPath != nil) ? self.orderList.count + 2 : self.orderList.count + 1;
    }
    return _maxRowNumbers;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kTableRowHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = [indexPath row];
    NSString *identifier = [NSString stringWithFormat:@"cell%ld", (long)row];
    UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
    if (cell != nil) {
        UIFont *font = [UIFont fontWithName:@"Heiti SC Medium" size:30];
        CGFloat baseWidth = (CGRectGetWidth(tableView.frame)-kMargin*2)/5;
        CGFloat cellHeight = kTableRowHeight;
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        CAShapeLayer *topLine = [CPCocoaSubViews lineLayerWithStartPoint:CGPointMake(kMargin, 0)
                                endPoint:CGPointMake(CGRectGetWidth(tableView.frame)-kMargin, 0)
                                width:kLineWidth
                                color:[CPValueUtility colorWithR:0xD3 g:0xD3 b:0xD3 alpha:0.2]];
        [cell.contentView.layer addSublayer:topLine];
        
        CAShapeLayer *bottomLine = [CPCocoaSubViews
                        lineLayerWithStartPoint:CGPointMake(kMargin, kTableRowHeight)
                        endPoint:CGPointMake(CGRectGetWidth(tableView.frame)-kMargin, kTableRowHeight)
                        width:kLineWidth
                        color:[UIColor lightGrayColor]];
        [cell.contentView.layer addSublayer:bottomLine];
        
        if (self.curIndexPath != nil && self.curIndexPath.row == row) {
            
            UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(kMargin, 0, (CGRectGetWidth(tableView.frame)-kMargin*2), kTableRowHeight)];
            bgView.backgroundColor = [CPValueUtility colorWithR:0xD3 g:0xD3 b:0xD3 alpha:0.3];
            [cell.contentView addSubview:bgView];
            [bgView release];
            
            
            UIImage *deleteImage = [UIImage imageNamed:@"delete.png"];
            UIImage *addImage = [UIImage imageNamed:@"add.png"];
            UIImage *cutImage = [UIImage imageNamed:@"cut.png"];
            
            CGSize size = CGSizeMake(deleteImage.size.width / 14, deleteImage.size.height / 14);
            CGPoint center = CGPointMake(CGRectGetWidth(tableView.frame)/2, kTableRowHeight/2);
            CGRect deleteFrame = CGRectMake(0, 0, size.width, size.height);
            CGRect cutFrame = CGRectMake(0, 0, size.width, size.height);
            CGRect addFrame = CGRectMake(0, 0, size.width, size.height);
            
            UIButton *delete = [CPCocoaSubViews buttonWithFrame:deleteFrame
                                                          title:nil
                                                    normalImage:deleteImage
                                                 highlightImage:nil
                                                         target:self
                                                         action:@selector(deleteAction:)];
            delete.tag = row;
            delete.center = CGPointMake(center.x - 200, center.y);
            [cell.contentView addSubview:delete];
            
            UIButton *cut = [CPCocoaSubViews buttonWithFrame:cutFrame
                                                       title:nil
                                                 normalImage:cutImage
                                              highlightImage:nil
                                                      target:self
                                                      action:@selector(cutAction:)];
            cut.tag = row;
            cut.center = center;
            [cell.contentView addSubview:cut];
            
            UIButton *add = [CPCocoaSubViews buttonWithFrame:addFrame
                                                          title:nil
                                                    normalImage:addImage
                                                 highlightImage:nil
                                                         target:self
                                                         action:@selector(addAction:)];
            add.tag = row;
            add.center = CGPointMake(center.x + 200, center.y);
            [cell.contentView addSubview:add];
            
           
            
        }
        else if (row == _maxRowNumbers-1 && _maxRowNumbers >= 1)
        {
            CGFloat x = (CGRectGetWidth(tableView.frame) - kButtonWidth)/2;
            CGFloat y = (kTableRowHeight-kButtonHeight)/2;
            CGRect frame = CGRectMake(x, y, kButtonWidth, kButtonHeight);
            _clearCellBgView = [[UIView alloc] initWithFrame:frame];
            _clearCellBgView.backgroundColor = [UIColor clearColor];
            _clearCellBgView.layer.cornerRadius = 3;
            _clearCellBgView.tag = 1000;
            
            
            [cell.contentView addSubview:_clearCellBgView];
            [_clearCellBgView release];
            
            _clearAllButton = [CPCocoaSubViews buttonWithFrame:frame title:@"清除订单" normalImage:nil highlightImage:nil target:self action:@selector(clearAllAction:)];
            [_clearAllButton setTitleColor:[CPValueUtility colorWithR:0x00 g:0x80 b:0x00 alpha:1.0] forState:UIControlStateNormal];
            
            
            [cell.contentView addSubview:_clearAllButton];
            
        }
        else
        {
            NSInteger index = row;
            if (self.curIndexPath!=nil) {
                if (self.curIndexPath.row < self.orderList.count)
                {
                    if (row < self.curIndexPath.row) {
                        index = row;
                    }
                    else if (row > self.curIndexPath.row)
                    {
                        index = row-1;
                    }
                }
            }

            NSDictionary *data = [self.orderList objectAtIndex:index];
            NSString *nameString = [data objectForKey:kDBMenuName];
            NSString *priceString = [data objectForKey:kGoodsTotalPrice];
            NSString *numberString = [NSString stringWithFormat:@"X %@", [data objectForKey:kGoodsNumber]];
            
            
            
            CGRect nameFrame = CGRectMake(kMargin, 0, baseWidth*2, cellHeight);
            UILabel *name = [CPCocoaSubViews labelWithFrame:nameFrame
                                                       text:nameString
                                                  alignment:NSTextAlignmentLeft
                                                      color:[UIColor blackColor]
                                                       font:font];
            [cell.contentView addSubview:name];
            
            CGRect numberFrame = CGRectMake(baseWidth*2+kMargin, 0, baseWidth, cellHeight);
            UILabel *number = [CPCocoaSubViews labelWithFrame:numberFrame
                                                         text:numberString
                                                    alignment:NSTextAlignmentCenter
                                                        color:[UIColor blackColor]
                                                         font:font];
            [cell.contentView addSubview:number];
            
            CGRect priceFrame = CGRectMake(baseWidth*3+kMargin, 0, baseWidth*2, cellHeight);
            UILabel *price = [CPCocoaSubViews labelWithFrame:priceFrame
                                                        text:priceString
                                                   alignment:NSTextAlignmentRight
                                                       color:[UIColor blackColor]
                                                        font:font];
            [cell.contentView addSubview:price];
        }
        
    }
    
    return cell;
}

#pragma mark - Table view delegate


- (void)clearAllAnimationDidStop
{
    [self.orderList removeAllObjects];
    self.curIndexPath = nil;
    [_orderTable reloadData];
    
    [self.delegate orderTotalPriceDidChange:INFINITY];
    [self.delegate orderManagerWillDismiss];
    _shouldClearAllRows = NO;
}


- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    BOOL ret = YES;
    
    if (indexPath.row == self.curIndexPath.row) {
        ret = NO;
    }
    
    return ret;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        NSInteger index = indexPath.row;
        
        if (self.curIndexPath != nil) {
            if (self.curIndexPath.row < self.orderList.count)
            {
                if (indexPath.row < self.curIndexPath.row - 1) {
                    index = indexPath.row;
                    NSIndexPath *newPath = [NSIndexPath indexPathForRow:self.curIndexPath.row-1 inSection:self.curIndexPath.section];
                    self.curIndexPath = newPath;
                    
                }
                else if (indexPath.row == self.curIndexPath.row - 1)
                {
                    self.curIndexPath = nil;
                }
                
                else if (indexPath.row > self.curIndexPath.row)
                {
                    index = indexPath.row-1;
                    
                }
                
            }
            
        }
        
        NSMutableDictionary *dic = [self.orderList objectAtIndex:index];
        CGFloat totalPrice = [[dic objectForKey:kGoodsTotalPrice] floatValue];
    
        [self.orderList removeObjectAtIndex:index];
        [_orderTable reloadData];
        [self.delegate orderTotalPriceDidChange:-totalPrice];
        
        if (self.orderList.count == 0) {
            self.curIndexPath = nil;
            [self.delegate orderManagerWillDismiss];
        }
        
    }
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self clearButtonCancelReady];
    
    if (indexPath.row == _maxRowNumbers - 1) {
        return;
    }
    
    // 当前还未显示编辑行
    if (self.curIndexPath == nil) {
        NSIndexPath *nextIndexPath = [NSIndexPath indexPathForRow:indexPath.row+1 inSection:indexPath.section];
        self.curIndexPath = nextIndexPath;
        [self showEditView];
    }
    else// 当前已显示编辑行
    {
        // 1.当前选中编辑行的上一行
        BOOL priorRow = (indexPath.row == (self.curIndexPath.row - 1));
        if (priorRow) {
            [self hideEditView];
        }
        // 2.当前选中其他行
        else if (indexPath.row != self.curIndexPath.row && !priorRow)
        {
            NSInteger nowEditRow = self.curIndexPath.row;
            [self hideEditView];
            NSIndexPath *nextIndexPath = [NSIndexPath indexPathForRow:indexPath.row+1 inSection:indexPath.section];
            self.curIndexPath = (indexPath.row < nowEditRow) ? nextIndexPath : indexPath;
            [self showEditView];
            
        }
        
    [tableView scrollToRowAtIndexPath:self.curIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        
    }

}

#pragma mark - Animation Delegate

- (void)animationDidStart:(CAAnimation *)anim
{
    _orderTable.userInteractionEnabled = NO;
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    _orderTable.userInteractionEnabled = YES;
}


#pragma mark- gesture delegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    BOOL ret = YES;
    
    if([touch.view isKindOfClass:[UITableViewCell class]]) {
        ret = NO;
    }
    // UITableViewCellContentView => UITableViewCell
    if([touch.view.superview isKindOfClass:[UITableViewCell class]]) {
        ret = NO;
    }
    // UITableViewCellContentView => UITableViewCellScrollView => UITableViewCell
    if([touch.view.superview.superview isKindOfClass:[UITableViewCell class]]) {
        ret = NO;
    }
    
    if (touch.view.tag == 1000) {
        ret = NO;
    }
    
    return ret;
}

@end
