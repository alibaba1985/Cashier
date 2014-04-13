//
//  WLMenuViewController.h
//  Cashier
//
//  Created by liwang on 14-1-24.
//  Copyright (c) 2014年 liwang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WLMenuViewController : UIViewController

@property(nonatomic, retain)NSArray *menuItems;

- (void)initWithItems:(NSArray *)items;

@end
