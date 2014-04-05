//
//  WLSideMeneItem.m
//  WLAnimationsTest
//
//  Created by liwang on 14-1-20.
//  Copyright (c) 2014年 liwang. All rights reserved.
//

#import "WLSideMenuItem.h"


#define WLRelease(X) if (X != nil) {[X release];X = nil;}

@interface WLSideMenuItem ()
{
    UIViewController *_rootViewController;
    WLMenuType             _menuType;
    UIImage                *_indicatorImage;
    NSString               *_title;
    NSArray                *_subMenus;
}



@end


@implementation WLSideMenuItem
@synthesize rootViewController;
@synthesize menuType = _menuType;
@synthesize indicatorImage = _indicatorImage;
@synthesize title = _title;
@synthesize subMenus = _subMenus;

- (void)dealloc
{
    self.rootViewController = nil;
    WLRelease(_indicatorImage);
    WLRelease(_title);
    WLRelease(_subMenus);
    [super dealloc];
}

- (id)initWithViewController:(UINavigationController *)viewController
                        type:(WLMenuType)type
                   indicator:(UIImage *)indicator
                       title:(NSString *)title
                    subMenus:(NSArray *)subMenus;
{
    self = [super init];
    if (self) {
        self.rootViewController = viewController;
        _menuType = type;
        _indicatorImage = [indicator copy];
        _title = [title copy];
        _subMenus = [subMenus copy];
    }
    
    return self;
}




@end
