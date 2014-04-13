//
//  TnPreviewPagingScrollView.m
//  ScrollViewPagingExample
//
//  Created by xlpeng on 11/9/12.
//  Copyright (c) 2012 Telenav. All rights reserved.
//

#import "TnPreviewPagingScrollView.h"

static CGFloat DefaultTiltDistance = 25;

@interface TnPreviewPagingScrollView()

@property(nonatomic, assign, readwrite)NSInteger activeIndex;

@end

@implementation TnPreviewPagingScrollView
@synthesize tiltDistance=_tiltDistance;
@synthesize activeIndex=_activeIndex;
@synthesize delegate=_delegate;
@synthesize scrollView = _scrollView;

- (void)createScrollView
{
    CGRect frame = self.bounds;
    _tiltDistance = DefaultTiltDistance;
    _views = [NSMutableArray array];
    _activeIndex = 0;
    _delegate = nil;
    CGRect scrollFrame = CGRectMake(0.0+_tiltDistance, 
                                    0.0, 
                                    frame.size.width-_tiltDistance*2, 
                                    frame.size.height);
    _scrollView = [[UIScrollView alloc] initWithFrame:scrollFrame];
    [self addSubview:_scrollView];
    _scrollView.clipsToBounds = NO;
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self createScrollView];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self createScrollView];
    }
    return self;
}

- (void)dealloc
{
    _delegate = nil;
    _scrollView.delegate = nil;
    [_views removeAllObjects];
}

- (void)adjustSubPagingView
{
    CGFloat contentOffset = 0.0f;
    for (UIView *view in _views) {
        CGRect frame = CGRectMake(contentOffset, 0.0f, _scrollView.bounds.size.width, _scrollView.bounds.size.height);
        
        view.frame = frame;
        [_scrollView addSubview:view];
        
        contentOffset += view.bounds.size.width;
        [view setNeedsLayout];
    }
    _scrollView.contentSize = CGSizeMake(contentOffset, _scrollView.bounds.size.height);
    _scrollView.delegate = self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    CGRect scrollFrame = CGRectMake(0.0+_tiltDistance,
                                    0.0,
                                    self.bounds.size.width-_tiltDistance*2,
                                    self.bounds.size.height);
    _scrollView.frame = scrollFrame;
    [self adjustSubPagingView];
    [self setActiveIndex:self.activeIndex animated:NO];
}

- (void)setTiltDistance:(CGFloat)distance
{
    _tiltDistance = distance;
    CGRect frame = self.bounds;
    CGRect scrollFrame = CGRectMake(0.0+_tiltDistance, 
                                    0.0, 
                                    frame.size.width-_tiltDistance*2, 
                                    frame.size.height);
    _scrollView.frame = scrollFrame;
}

-(void)setupPagingViewWithViews:(NSArray *)uiViews
{
    for (UIView *view in _views) {
        [view removeFromSuperview];
    }
    [_views removeAllObjects];
    [_views addObjectsFromArray:uiViews];
    [self adjustSubPagingView];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

#pragma mark -
#pragma mark UIView methods

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView* superHitView = [super hitTest:point withEvent:event];
    if([superHitView isKindOfClass:[UIButton class]]) {
        // let button to handle event.
        return superHitView;
    }
    
	if ([self pointInside:point withEvent:event]) {
		return _scrollView;
	}
	return nil;
}

- (void)updateActiveIndex
{
    CGFloat pageWidth = _scrollView.bounds.size.width;
    CGFloat x = _scrollView.contentOffset.x;
    NSInteger page = (int)floor((x - pageWidth / 2.0f) / pageWidth) + 1;
    
    if (page != _activeIndex) {
        [self setActiveIndex:page];
        if (_delegate && [_delegate respondsToSelector:@selector(didActivatePage:inView:)]) {
            [_delegate didActivatePage:_activeIndex inView:self];
        }

    }
 //   DLog(@"activeIndex = %d", _activeIndex);
}

-(void)setActiveIndex:(NSInteger)activeIndex animated:(BOOL)animated {
    CGFloat pageWidth = _scrollView.bounds.size.width;
    CGPoint offset = CGPointMake(pageWidth*activeIndex, 0.0);
    [_scrollView setContentOffset:offset animated:animated];
}

#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self updateActiveIndex];
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    // if decelerate is true then scrollViewDidEndDecelerating will be called
    if (!decelerate) {
        [self updateActiveIndex];
    }
}

// called when scroll view grinds to a halt
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView      
{
    [self updateActiveIndex];
}

// called when setContentOffset/scrollRectVisible:animated: finishes. not called if not animating
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView 
{
    [self updateActiveIndex];
}

@end
