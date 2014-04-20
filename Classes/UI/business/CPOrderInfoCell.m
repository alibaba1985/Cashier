//
//  CPOrderInfoCell.m
//  Cashier
//
//  Created by liwang on 14-4-20.
//  Copyright (c) 2014年 liwang. All rights reserved.
//

#import "CPOrderInfoCell.h"
#import "CPDataBaseMacros.h"
#import "CPCocoaSubViews.h"
#import "CPValueUtility.h"
#import "CPConstDefine.h"

#define kMargin 0
#define kLineWidth 0.3


@interface CPOrderInfoCell ()

@property(nonatomic, retain)NSDictionary *contentData;
@property(nonatomic, assign)UITableView *tableView;

@end

@implementation CPOrderInfoCell
@synthesize contentData;
@synthesize tableView;

- (void)dealloc
{
    self.contentData = nil;
    self.tableView = nil;
    
    [super dealloc];
}


- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
            content:(NSDictionary *)content
              table:(UITableView *)table
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        self.contentData = content;
        self.tableView = table;
        CGFloat contentWidth = CGRectGetWidth(self.tableView.frame) - 2*kMargin;
        CGFloat contentHeight = kOrderTableRowHeight;
        CGFloat contentPerWidth = contentWidth / 5;
        UIFont *font = [UIFont fontWithName:@"Heiti SC Medium" size:30];
        //
        
        
        
        NSString *nameString = [self.contentData objectForKey:kDBMenuName];
        NSString *priceString = [self.contentData objectForKey:kGoodsTotalPrice];
        NSString *numberString = [NSString stringWithFormat:@"X %@", [self.contentData objectForKey:kGoodsNumber]];
        CGRect nameFrame = CGRectMake(kMargin, 0, contentPerWidth*2, contentHeight);
        UILabel *name = [CPCocoaSubViews labelWithFrame:nameFrame
                                                   text:nameString
                                              alignment:NSTextAlignmentLeft
                                                  color:[UIColor blackColor]
                                                   font:font];
        [self.contentView addSubview:name];
        
        CGRect numberFrame = CGRectMake(kMargin+contentPerWidth*2, 0, contentPerWidth, contentHeight);
        UILabel *number = [CPCocoaSubViews labelWithFrame:numberFrame
                                                     text:numberString
                                                alignment:NSTextAlignmentCenter
                                                    color:[UIColor blackColor]
                                                     font:font];
        [self.contentView addSubview:number];
        
        CGRect priceFrame = CGRectMake(kMargin+contentPerWidth*3, 0, contentPerWidth*2, contentHeight);
        UILabel *price = [CPCocoaSubViews labelWithFrame:priceFrame
                                                    text:priceString
                                               alignment:NSTextAlignmentRight
                                                   color:[UIColor blackColor]
                                                    font:font];
        [self.contentView addSubview:price];
        
        
        
        
        
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



/*
- (void)willTransitionToState:(UITableViewCellStateMask)state
{
    [super willTransitionToState:state];
    if (state == UITableViewCellStateShowingDeleteConfirmationMask)
    {
        for (UIView *subview in self.subviews)
        {
            for (UIView *ssubview in subview.subviews)
            {
                NSLog(@"class-%@",NSStringFromClass([subview class]));
                if ([NSStringFromClass([ssubview class]) isEqualToString:@"UITableViewCellDeleteConfirmationControl"])
                {
                    CGRect frame = ssubview.frame;
                    frame.origin.x -= kMargin;
                    ssubview.frame = frame;
                }
            }
            
        }
    }
}
*/

@end
