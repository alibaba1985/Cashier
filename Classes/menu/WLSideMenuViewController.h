//
//  WLSideMenuViewController.h
//  WLAnimationsTest
//
//  Created by liwang on 14-1-20.
//  Copyright (c) 2014年 liwang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface WLSideMenuViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>



- (id)initWithLeftMenuItems:(NSArray *)leftItems rightMenuItems:(NSArray *)rightItems;

- (void)showMenu;

- (void)hideMenu;

@end
