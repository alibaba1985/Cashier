//
//  CPGoodsCategoryCell.m
//  Cashier
//
//  Created by liwang on 14-3-1.
//  Copyright (c) 2014年 liwang. All rights reserved.
//

#import "CPGoodsCategoryCell.h"
#import "CPCocoaSubViews.h"
#import "CPValueUtility.h"
#import "CPConstDefine.h"
#import "CPDataBaseMacros.h"

@implementation CPGoodsCategoryCell
@synthesize goodsCategory;
@synthesize cateDelegate;

- (void)dealloc
{
    self.goodsCategory = nil;
    self.cateDelegate = nil;
    
    [super dealloc];
}


- (id)initWithFrame:(CGRect)frame infos:(NSDictionary *)infos
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.goodsCategory = infos;
        NSString *text = [self.goodsCategory objectForKey:kDBText];
        NSString *title = nil;
        
        if (text.length == 4) {
            NSRange range = NSMakeRange(0, 2);
            NSString *preHex = [text substringWithRange:range];
            NSString *suffix = [text substringFromIndex:2];
            title = [NSString stringWithFormat:@"%@\n%@", preHex, suffix];
        }
        else
        {
            title = text;
        }
        
        _actionButton = [CPCocoaSubViews roundButtonWithFrame:self.bounds title:title normalImage:nil highlightImage:[UIImage imageNamed:@"greenBtn.png"] target:nil action:nil];
        [_actionButton addTarget:self action:@selector(touchDownAction:) forControlEvents:UIControlEventTouchDown];
        _actionButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        _actionButton.titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
        [self addSubview:_actionButton];
    }
    return self;
}

- (void)setStatusSelected
{
    [_actionButton setSelected:YES];
}

- (void)setStatusNoSelected
{
    [_actionButton setSelected:NO];
}

- (void)touchDownAction:(UIButton *)button
{
    [self setStatusSelected];
    if ([self.cateDelegate respondsToSelector:@selector(didSelectedCategoryCell:value:)]) {
        [self.cateDelegate didSelectedCategoryCell:self value:[self.goodsCategory objectForKey:kDBValue]];
    }
}

@end
