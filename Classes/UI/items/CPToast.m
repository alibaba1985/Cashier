//
//  CPToast.m
//  Cashier
//
//  Created by liwang on 14-1-23.
//  Copyright (c) 2014年 liwang. All rights reserved.
//

#import "CPToast.h"
#import "CPViewAnimations.h"
#import "CPValueUtility.h"

#define kTopMargin 25
#define kMaxHeught 300
#define kWidth     300
#define kLoadingHeight 160
#define kFontSize  20
#define kDelay     3
#define kBGAlpha   0.6
#define kBGCornerRadius 3;
#define kGoldenPoint 0.42
#define kIndicatorSize 40

@interface CPToast ()
{
    UIView *_contentView;
    UIView *_bacgroundView;
    UIView *_toastView;
    UILabel *_titleLabel;
    CGPoint _center;
    CPToastPosition _position;
    BOOL _loading;
}
@property(nonatomic, assign)CGPoint realCenter;
@property(nonatomic, assign)UIView *realSuperView;

- (void)didShowToastOnTop;

- (void)didShowToastOnCenter;

- (void)didDidmissToast;

- (void)hide;

@end

@implementation CPToast
@synthesize realCenter;
@synthesize realSuperView;

- (void)dealloc
{
    self.realCenter = CGPointZero;
    self.realSuperView = nil;
    
    [super dealloc];
}

- (id)initLoadingOnView:(UIView *)view title:(NSString *)title
{
    CGRect frame = CGRectZero;
    frame.size = CGSizeMake([CPValueUtility screenWidth], [CPValueUtility screenHeight]);
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.alpha = 0;
        self.realSuperView = view;
        _loading = YES;
        // add bg
        
        
        _bacgroundView = [[UIView alloc] initWithFrame:self.realSuperView.bounds];
        _bacgroundView.backgroundColor = [UIColor blackColor];
        _bacgroundView.alpha = kBGAlpha;
        [self addSubview:_bacgroundView];
        [_bacgroundView release];
        // add content
        CGRect contentFrame = CGRectMake(0, 0, kWidth, kLoadingHeight);
        _contentView = [[UIView alloc] initWithFrame:contentFrame];
        _contentView.backgroundColor = [UIColor whiteColor];
        _contentView.layer.cornerRadius = kBGCornerRadius;
        _contentView.center = CGPointMake([CPValueUtility screenWidth]/2, [CPValueUtility screenHeight]*kGoldenPoint);
        [self addSubview:_contentView];
        [_contentView release];
        
        CGRect titleFrame = CGRectMake(kTopMargin, kTopMargin, kWidth-2*kTopMargin, kTopMargin*2);
        _titleLabel = [[UILabel alloc] initWithFrame:titleFrame];
        _titleLabel.text = title;
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.lineBreakMode = UILineBreakModeCharacterWrap;
        _titleLabel.font = [UIFont systemFontOfSize:kFontSize];
        _titleLabel.numberOfLines = 0;
        _titleLabel.backgroundColor = [UIColor clearColor];
        [_contentView addSubview:_titleLabel];
        [_titleLabel release];

        UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [indicator setFrame:CGRectMake(0, 0, kIndicatorSize, kIndicatorSize)];
        indicator.center = CGPointMake(_contentView.frame.size.width/2, _contentView.frame.size.height-kIndicatorSize*3/2);
        [indicator startAnimating];
        [_contentView addSubview:indicator];
        [indicator release];
        
    }
    
    return self;
}


- (id)initOnView:(UIView *)view
        position:(CPToastPosition)position
           title:(NSString *)title
{
    CGRect contentFrame = CGRectZero;
    UIFont *font = [UIFont systemFontOfSize:kFontSize];
    CGSize size = [title sizeWithFont:font forWidth:(kWidth-2*kTopMargin) lineBreakMode:NSLineBreakByCharWrapping];
    contentFrame.size = CGSizeMake(kWidth, kTopMargin*2 + size.height);
    CGRect frame = CGRectZero;
    frame.size = CGSizeMake([CPValueUtility screenWidth], [CPValueUtility screenHeight]);
    self = [super initWithFrame:contentFrame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        self.realSuperView = view;
        _position = position;
        
        // add content
        _contentView = [[UIView alloc] initWithFrame:contentFrame];
        _contentView.backgroundColor = [UIColor whiteColor];
        _contentView.layer.cornerRadius = kBGCornerRadius;
        [self addSubview:_contentView];
        [_contentView release];
        
        CGRect titleFrame = CGRectMake(kTopMargin, kTopMargin, kWidth-2*kTopMargin, size.height);
        _titleLabel = [[UILabel alloc] initWithFrame:titleFrame];
        _titleLabel.text = title;
        _titleLabel.font = [UIFont systemFontOfSize:kFontSize];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.lineBreakMode = UILineBreakModeCharacterWrap;
        _titleLabel.numberOfLines = 0;
        _titleLabel.backgroundColor = [UIColor clearColor];
        [_contentView addSubview:_titleLabel];
        [_titleLabel release];
        
        
        // position
        switch (_position) {
            case CPToastPositionCenter:
            {
                _contentView.center = CGPointMake(CGRectGetMidX(frame), CGRectGetMaxY(frame)*kGoldenPoint);
                _bacgroundView = [[UIView alloc] initWithFrame:self.realSuperView.bounds];
                _bacgroundView.backgroundColor = [UIColor blackColor];
                _bacgroundView.alpha = kBGAlpha;
                [self insertSubview:_bacgroundView belowSubview:_contentView];
                [_bacgroundView release];
                [self setFrame:self.realSuperView.bounds];
                
            }
                break;
            case CPToastPositionTop:
            {
                self.realCenter = CGPointMake(CGRectGetMidX(frame), CGRectGetMidY(contentFrame));
                _center = CGPointMake(CGRectGetMidX(frame), -contentFrame.size.height/2);
                self.center = _center;
            }
                break;
            default:
                break;
        }
        self.alpha = 0;
    }
    return self;
}



- (void)didShowToastOnCenter
{
    [self performSelector:@selector(hide) withObject:nil afterDelay:kDelay];
}

- (void)didShowToastOnTop
{
    [self performSelector:@selector(hide) withObject:nil afterDelay:kDelay];
}

- (void)didDidmissToast
{
    [self removeFromSuperview];
}

- (void)show
{
    [self.realSuperView addSubview:self];
    [self.realSuperView bringSubviewToFront:self];
    __block CPToast *weakSelf = self;
    
    if (_position == CPToastPositionCenter) {
        [CPViewAnimations animationWithDuration:kSystemAnimationDuration endAction:@selector(didShowToastOnCenter) target:self block:^{
            weakSelf.alpha = 1;
        }];
    }
    else if (_position == CPToastPositionTop){
        [CPViewAnimations animationWithDuration:kSystemAnimationDuration endAction:@selector(didShowToastOnTop) target:self block:^{
            weakSelf.center = weakSelf.realCenter;
            weakSelf.alpha = 1;
        }];
    }
    else if (_loading)
    {
        [CPViewAnimations animationWithDuration:kSystemAnimationDuration endAction:nil target:nil block:^{
            weakSelf.alpha = 1;
        }];

    }
    
}

- (void)dismiss
{
    __block CPToast *weakSelf = self;
    
    if (_position == CPToastPositionCenter || _loading) {
        [self removeFromSuperview];
    }
    else if (_position == CPToastPositionTop){
        [CPViewAnimations animationWithDuration:kSystemAnimationDuration endAction:@selector(didDidmissToast) target:self block:^{
            weakSelf.center = _center;
            weakSelf.alpha = 0;
        }];
    }
}


- (void)hide
{
    __block CPToast *weakSelf = self;
    
    if (_position == CPToastPositionCenter) {
        [self removeFromSuperview];
    }
    else if (_position == CPToastPositionTop){
        [CPViewAnimations animationWithDuration:kSystemAnimationDuration endAction:@selector(didDidmissToast) target:self block:^{
            weakSelf.center = _center;
            weakSelf.alpha = 0;
        }];
    }
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
