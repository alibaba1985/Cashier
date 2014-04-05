//
//  CPGoodsCountIndicator.m
//  Cashier
//
//  Created by liwang on 14-2-23.
//  Copyright (c) 2014年 liwang. All rights reserved.
//

#import "CPGoodsCountIndicator.h"
#import "CPCocoaSubViews.h"
#import "CPValueUtility.h"
#import "CPViewAnimations.h"


#define kFontSize 35
#define kOriginalScale 1
#define kSmallScale 0.5

#define kAnimationDuration 1

#define kCenterOffset  40

@implementation CPGoodsCountIndicator

- (id)initWithCenter:(CGPoint)center count:(NSInteger)count
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        // Initialization code
        UIFont *font = [UIFont boldSystemFontOfSize:kFontSize];
        NSString *title = [[NSString alloc] initWithFormat:@"已点:%ld", (long)count];
        CGSize size = [title sizeWithFont:font];
        self.frame = CGRectMake(0, 0, size.width, size.height);
        self.center = center;
        UILabel *label = [CPCocoaSubViews labelWithFrame:self.bounds text:title alignment:NSTextAlignmentCenter color:[CPValueUtility colorWithR:0x00 g:0x80 b:0x00 alpha:1.0] font:font];
        [self addSubview:label];
        self.userInteractionEnabled = NO;
        self.transform = CGAffineTransformMakeScale(kSmallScale, kSmallScale);
    }
    return self;
}


- (void)secondAnimationDidStop
{
    [self removeFromSuperview];
}




- (void)secondAnimation
{
    __block CPGoodsCountIndicator *weakSelf = self;
    [CPViewAnimations animationWithDuration:(CGFloat)kAnimationDuration*0.5 endAction:@selector(secondAnimationDidStop) target:self block:^{
        weakSelf.center = _moveCenter;
        weakSelf.transform = CGAffineTransformMakeScale(kSmallScale, kSmallScale);
    }];
}
- (void)firstAnimationDidStop
{
    [self performSelector:@selector(secondAnimation) withObject:nil afterDelay:(CGFloat)kAnimationDuration*0.5];
}


- (void)moveToCenter:(CGPoint)center
{
    _moveCenter = center;
    CGPoint aCenter = CGPointMake(self.center.x, self.center.y - kCenterOffset-kFontSize);
    __block CPGoodsCountIndicator *weakSelf = self;
    [CPViewAnimations animationWithDuration:(CGFloat)kAnimationDuration*0.3 endAction:@selector(firstAnimationDidStop) target:self block:^{
        weakSelf.center = aCenter;
        weakSelf.transform = CGAffineTransformMakeScale(kOriginalScale, kOriginalScale);
    }];
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
