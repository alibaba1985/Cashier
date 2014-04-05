//
//  WLSideMenuItem.h
//  WLAnimationsTest
//
//  Created by liwang on 14-1-20.
//  Copyright (c) 2014年 liwang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WLSideMenuViewController.h"
#import <UIKit/UIKit.h>
typedef void (^WLShowMenuBlock)(WLSideMenuViewController * MenuC) ;

typedef NS_ENUM(NSInteger, WLMenuType) {
    WLMenuTypeDefault           = 0,    //子view默认从右边滑至全屏
    WLMenuTypePresentCenter     = 1,    //子view以present方式居中显示
    WLMenuTypePresentFullScreen = 2,    //子view以present方式全屏显示
};


@interface WLSideMenuItem : NSObject

@property(nonatomic, retain)UINavigationController *rootViewController;
@property(nonatomic, readonly)WLMenuType             menuType;
@property(nonatomic, readonly)UIImage                *indicatorImage;
@property(nonatomic, readonly)NSString               *title;
@property(nonatomic, readonly)NSArray                *subMenus;

- (id)initWithViewController:(UINavigationController *)viewController
                        type:(WLMenuType)type
                   indicator:(UIImage *)indicator
                       title:(NSString *)title
                    subMenus:(NSArray *)subMenus;



@end
