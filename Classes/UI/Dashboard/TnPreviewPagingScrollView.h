//
//  TnPreviewPagingScrollView.h
//  ScrollViewPagingExample
//
//  Created by xlpeng on 11/9/12.
//  Copyright (c) 2012 Telenav. All rights reserved.
//

#import <UIKit/UIKit.h>


@class TnPreviewPagingScrollView;

@protocol TnPreviewPagingScrollViewDelegate <NSObject>

@optional
-(void)didActivatePage:(NSInteger)index inView:(TnPreviewPagingScrollView*)view;

@end

@interface TnPreviewPagingScrollView : UIView <UIScrollViewDelegate> {
    UIScrollView*   _scrollView;
    NSMutableArray* _views;
    CGFloat         _tiltDistance;
    NSInteger       _activeIndex;
    id<TnPreviewPagingScrollViewDelegate> __weak _delegate;
}

@property(nonatomic, assign)CGFloat tiltDistance;
@property(nonatomic, assign, readonly)NSInteger activeIndex;
@property(nonatomic, strong, readonly)UIScrollView* scrollView;
@property(nonatomic, weak)id<TnPreviewPagingScrollViewDelegate> delegate;

-(void)setupPagingViewWithViews:(NSArray*)uiViews;
-(void)setActiveIndex:(NSInteger)activeIndex animated:(BOOL)animated;

@end
