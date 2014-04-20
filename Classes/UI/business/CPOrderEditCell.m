//
//  CPOrderEditCell.m
//  Cashier
//
//  Created by liwang on 14-4-20.
//  Copyright (c) 2014年 liwang. All rights reserved.
//

#import "CPOrderEditCell.h"
#import "CPCocoaSubViews.h"
#import "CPValueUtility.h"
#import "CPConstDefine.h"

#define kMargin 0
#define kLineWidth 0.3

@interface CPOrderEditCell ()

- (void)deleteAction:(id)sender;
- (void)addAction:(id)sender;
- (void)cutAction:(id)sender;

@end


@implementation CPOrderEditCell
@synthesize tableView;
@synthesize editDelegate;

- (void)dealloc
{
    self.tableView = nil;
    self.editDelegate = nil;
    
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
              table:(UITableView *)table
           delegate:(id<CPOrderEditDelegate>)delegate
              atRow:(NSInteger)row
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.tableView = table;
        self.editDelegate = delegate;
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(tableView.frame), kOrderTableRowHeight)];
        bgView.backgroundColor = [CPValueUtility colorWithR:0xD3 g:0xD3 b:0xD3 alpha:0.3];
        [self.contentView addSubview:bgView];
        [bgView release];
        
        
        UIImage *deleteImage = [UIImage imageNamed:@"delete.png"];
        UIImage *addImage = [UIImage imageNamed:@"add.png"];
        UIImage *cutImage = [UIImage imageNamed:@"cut.png"];
        
        CGSize size = CGSizeMake(deleteImage.size.width / 14, deleteImage.size.height / 14);
        CGPoint center = CGPointMake(CGRectGetWidth(tableView.frame)/2, kOrderTableRowHeight/2);
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
        [self.contentView addSubview:delete];
        
        UIButton *cut = [CPCocoaSubViews buttonWithFrame:cutFrame
                                                   title:nil
                                             normalImage:cutImage
                                          highlightImage:nil
                                                  target:self
                                                  action:@selector(cutAction:)];
        cut.tag = row;
        cut.center = center;
        [self.contentView addSubview:cut];
        
        UIButton *add = [CPCocoaSubViews buttonWithFrame:addFrame
                                                   title:nil
                                             normalImage:addImage
                                          highlightImage:nil
                                                  target:self
                                                  action:@selector(addAction:)];
        add.tag = row;
        add.center = CGPointMake(center.x + 200, center.y);
        [self.contentView addSubview:add];

    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



- (void)deleteAction:(id)sender
{
    if ([self.editDelegate respondsToSelector:@selector(orderEditActionType:)]) {
        [self.editDelegate orderEditActionType:CPOrderActionDelete];
    }
    
}
- (void)addAction:(id)sender
{
    if ([self.editDelegate respondsToSelector:@selector(orderEditActionType:)]) {
        [self.editDelegate orderEditActionType:CPOrderActionAdd];
    }
}
- (void)cutAction:(id)sender
{
    if ([self.editDelegate respondsToSelector:@selector(orderEditActionType:)]) {
        [self.editDelegate orderEditActionType:CPOrderActionCut];
    }
}

@end
