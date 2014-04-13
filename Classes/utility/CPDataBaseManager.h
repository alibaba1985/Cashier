//
//  CPDataBaseManager.h
//  Cashier
//
//  Created by liwang on 14-2-12.
//  Copyright (c) 2014年 liwang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CPDataBaseManager : NSObject



+ (CPDataBaseManager *)shareInstance;

+ (void)releaseDB;

- (BOOL)createTableWithSQL:(NSString *)sql;

- (BOOL)deleteInfoByKey:(NSString *)key inTable:(NSString *)table;

- (BOOL)insertInfo:(NSString *)info forKey:(NSString *)key inTable:(NSString *)table;

- (BOOL)modifyInfo:(NSString *)info forKey:(NSString *)key inTable:(NSString *)table;

- (NSArray *)searchInfoByKey:(NSString *)key inTable:(NSString *)table;

//


- (NSArray *)querySubGoodsByKeyValue:(NSString *)value;


@end
