//
//  CPToast.h
//  Cashier
//
//  Created by liwang on 14-1-23.
//  Copyright (c) 2014年 liwang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, CPToastPosition) {
    CPToastPositionTop = 1,
    CPToastPositionCenter = 2,
};

@interface CPToast : UIView


- (id)initLoadingOnView:(UIView *)view title:(NSString *)title;
- (void)dismiss;

- (id)initOnView:(UIView *)view
        position:(CPToastPosition)position
           title:(NSString *)title;

- (void)show;



@end
