//
//  CPResourceManager.h
//  Cashier
//
//  Created by liwang on 14-1-8.
//  Copyright (c) 2014年 liwang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CPResourceManager : NSObject
@property(nonatomic, retain)NSDictionary *stringResource;
@property(nonatomic, retain)NSDictionary *imageResource;

+ (CPResourceManager *)shareInstance;

+ (void)releaseInstance;





@end
