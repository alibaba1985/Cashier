//
//  CPDataBaseManager.m
//  Cashier
//
//  Created by liwang on 14-2-12.
//  Copyright (c) 2014年 liwang. All rights reserved.
//

#import "CPDataBaseManager.h"
#import <sqlite3.h>

#define kDBName  @"beaver.sqlite"
#define kTableName @"Category"

#define kInsertSQL(X,Y)

@interface CPDataBaseManager ()
{
    sqlite3 *_sqliteEntry;
}


- (NSString *)dbPath;



@end



static CPDataBaseManager *_dbInstance = nil;
@implementation CPDataBaseManager

+ (CPDataBaseManager *)shareInstance
{
    @synchronized(self)
    {
        if (_dbInstance == nil) {
            _dbInstance = [[CPDataBaseManager alloc] init];
        }
    }
    
    return _dbInstance;
}

+ (void)releaseDB
{
    if (_dbInstance !=nil) {
        [_dbInstance release];
        _dbInstance = nil;
    }
}

- (void)dealloc
{
    if (_sqliteEntry != nil) {
        sqlite3_close(_sqliteEntry);
        _sqliteEntry = nil;
    }
    [super dealloc];
}


- (id)init
{
    self = [super init];
    if (self) {
        NSString *dbPath = [[NSBundle mainBundle] pathForResource:@"beaver" ofType:@"sqlite"];
        if (sqlite3_open([dbPath UTF8String], &_sqliteEntry) != SQLITE_OK) {
            NSLog(@"datebase error!");
            _sqliteEntry = nil;
        }
        else
        {
            
        }
    }
    
    return self;
}

- (NSString *)dbPath
{
    NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documents = [pathArray objectAtIndex:0];
    NSString *dbPath = [documents stringByAppendingPathComponent:kDBName];
    
    return dbPath;
}

#pragma mark - DataBase

- (BOOL)createTableWithSQL:(NSString *)sql
{
    BOOL ret = YES;
    char *err;
    NSString *createSQL = @"CREATE TABLE [ConfigManage] (\
    [ID] integer NOT NULL PRIMARY KEY AUTOINCREMENT,\
    [ConfigName] text(20),\
    [ItemValue] text(10),\
    [ItemText] text(20),\
    [Remark] text(20),\
    [CreateUser] text(30),\
    [CreateTime] datetime,\
    [UpdateUser] text(30),\
    [UpdateTime] datetime)";
    
    if (sqlite3_exec(_sqliteEntry,[createSQL UTF8String],NULL,NULL,&err) != SQLITE_OK) {
        ret = NO;
    }
    
    return ret;
}

- (BOOL)deleteInfoByKey:(NSString *)key inTable:(NSString *)table
{
    return YES;
}

- (BOOL)insertInfo:(NSString *)info forKey:(NSString *)key inTable:(NSString *)table
{
    BOOL ret = YES;
    NSString *insertSQL1 = @"INSERT INTO [ConfigManage] ([ConfigName],[ItemValue],[ItemText],[Remark],[CreateUser],[CreateTime],[UpdateUser],[UpdateTime]) VALUES ('MenuType','1','咖啡',NULL,NULL,NULL,NULL,NULL);INSERT INTO [ConfigManage] ([ConfigName],[ItemValue],[ItemText],[Remark],[CreateUser],[CreateTime],[UpdateUser],[UpdateTime]) VALUES ('MenuType','2','茶',NULL,NULL,NULL,NULL,NULL);";
    
    NSString *insertSQL2 = @"INSERT INTO [ConfigManage] ([ConfigName],[ItemValue],[ItemText],[Remark],[CreateUser],[CreateTime],[UpdateUser],[UpdateTime]) VALUES ('MenuType','3','点心',NULL,NULL,NULL,NULL,NULL);";
    
    NSString *insertSQL3 = @"INSERT INTO [ConfigManage] ([ConfigName],[ItemValue],[ItemText],[Remark],[CreateUser],[CreateTime],[UpdateUser],[UpdateTime]) VALUES ('MenuType','4','生日蛋糕',NULL,NULL,NULL,NULL,NULL);";
    
    char *err = NULL;
    if (sqlite3_exec(_sqliteEntry,[insertSQL1 UTF8String],NULL,NULL,&err) != SQLITE_OK) {
        
        ret = NO;
        
    }
    
    if (sqlite3_exec(_sqliteEntry,[insertSQL2 UTF8String],NULL,NULL,&err) != SQLITE_OK) {
        
        ret = NO;
        
    }
    
    if (sqlite3_exec(_sqliteEntry,[insertSQL3 UTF8String],NULL,NULL,&err) != SQLITE_OK) {
        
        ret = NO;
        
    }
    
    return ret;
}

- (BOOL)modifyInfo:(NSString *)info forKey:(NSString *)key inTable:(NSString *)table
{
    return YES;
}

- (BOOL)insertDictionary:(NSMutableDictionary *)dictionary charObject:(char *)object forKey:(NSString *)key
{
    BOOL ret = NO;
    if (object != NULL ) {
        NSString *aObject = [[[NSString alloc]initWithUTF8String:object] autorelease];
        [dictionary setObject:aObject forKey:key];
        ret = YES;
    }

    return ret;
}

- (NSArray *)searchInfoByKey:(NSString *)key inTable:(NSString *)table
{
    
    NSString *searchSQL = @"SELECT * FROM ConfigManage WHERE ConfigName = 'MenuType' ORDER BY ItemValue ASC";
    
    sqlite3_stmt * statement;
    NSMutableArray *dataArray = nil;
    
    if (sqlite3_prepare_v2(_sqliteEntry, [searchSQL UTF8String], -1, &statement, nil) == SQLITE_OK) {
        dataArray = [NSMutableArray array];
        
        while (sqlite3_step(statement) == SQLITE_ROW) {
            
            NSMutableDictionary *rowDictionary = [NSMutableDictionary dictionary];
            
            [self insertDictionary:rowDictionary charObject:(char*)sqlite3_column_text(statement, 1) forKey:@"ConfigName"];
            
            [self insertDictionary:rowDictionary charObject:(char*)sqlite3_column_text(statement, 2) forKey:@"ItemValue"];
            
            [self insertDictionary:rowDictionary charObject:(char*)sqlite3_column_text(statement, 3) forKey:@"ItemText"];
            
            [self insertDictionary:rowDictionary charObject:(char*)sqlite3_column_text(statement, 4) forKey:@"Remark"];
            
            [self insertDictionary:rowDictionary charObject:(char*)sqlite3_column_text(statement, 5) forKey:@"CreateUser"];
            
            [self insertDictionary:rowDictionary charObject:(char*)sqlite3_column_text(statement, 6) forKey:@"CreateTime"];
            
            [self insertDictionary:rowDictionary charObject:(char*)sqlite3_column_text(statement, 7) forKey:@"UpdateUser"];
            
            [self insertDictionary:rowDictionary charObject:(char*)sqlite3_column_text(statement, 8) forKey:@"UpdateTime"];
            
            [dataArray addObject:rowDictionary];
            
        }
    }
    
    
    
    return dataArray;
}


- (NSArray *)querySubGoodsByKeyValue:(NSString *)value
{
    if (value == nil) {
        return nil;
    }
    
    NSString *searchSQL = [NSString stringWithFormat:@"SELECT * FROM MenuManage WHERE MenuType = '%@'", value];
    
    NSMutableArray *dataArray = nil;
    sqlite3_stmt * statement;
    
    if (sqlite3_prepare_v2(_sqliteEntry, [searchSQL UTF8String], -1, &statement, nil) == SQLITE_OK) {
        dataArray = [NSMutableArray array];
        
        while (sqlite3_step(statement) == SQLITE_ROW) {
            
            NSMutableDictionary *rowDictionary = [NSMutableDictionary dictionary];
            
            [self insertDictionary:rowDictionary charObject:(char*)sqlite3_column_text(statement, 1) forKey:@"MenuNo"];
            
            [self insertDictionary:rowDictionary charObject:(char*)sqlite3_column_text(statement, 2) forKey:@"MenuName"];
            
            [self insertDictionary:rowDictionary charObject:(char*)sqlite3_column_text(statement, 3) forKey:@"MenuType"];
            
            [self insertDictionary:rowDictionary charObject:(char*)sqlite3_column_text(statement, 4) forKey:@"ImagePath"];
            
            [self insertDictionary:rowDictionary charObject:(char*)sqlite3_column_text(statement, 5) forKey:@"SalePrice"];
            
            [self insertDictionary:rowDictionary charObject:(char*)sqlite3_column_text(statement, 6) forKey:@"SaleUnit"];
            
            [self insertDictionary:rowDictionary charObject:(char*)sqlite3_column_text(statement, 7) forKey:@"CreateUser"];
            
            [self insertDictionary:rowDictionary charObject:(char*)sqlite3_column_text(statement, 8) forKey:@"CreateTime"];
            
            [self insertDictionary:rowDictionary charObject:(char*)sqlite3_column_text(statement, 7) forKey:@"UpdateUser"];
            
            [self insertDictionary:rowDictionary charObject:(char*)sqlite3_column_text(statement, 8) forKey:@"UpdateTime"];
            
            [dataArray addObject:rowDictionary];
            
        }
    }
    
    
    
    return dataArray;
}


@end
