//
//  CPResourceManager.m
//  Cashier
//
//  Created by liwang on 14-1-8.
//  Copyright (c) 2014年 liwang. All rights reserved.
//

#import "CPResourceManager.h"

#define kStringFile     @"CPStringLocalizer"
#define kImageFile      @"CPImageResource"
#define kFileType       @"plist"

static CPResourceManager *_resourceManager;
@interface CPResourceManager ()

- (NSDictionary *)readStringResourceFromFile;

- (NSDictionary *)readImageResourceFromFile;

@end
@implementation CPResourceManager
@synthesize stringResource;
@synthesize imageResource;

+ (CPResourceManager *)shareInstance
{
    @synchronized(self)
    {
        if (_resourceManager == nil) {
            _resourceManager = [[CPResourceManager alloc] init];
        }
    }
    
    return _resourceManager;
}

+ (void)releaseInstance
{
    if (_resourceManager != nil) {
        [_resourceManager release];
        _resourceManager = nil;
    }
}


- (id)init
{
    self = [super init];
    if (self) {
        self.stringResource = [self readStringResourceFromFile];
        self.imageResource = [self readImageResourceFromFile];
    }
    
    return self;
}


#pragma mark- Member Function

- (NSDictionary *)readStringResourceFromFile
{
    NSDictionary *resource = nil;
    NSString *file = [[NSBundle mainBundle] pathForResource:kStringFile ofType:kFileType];
    if (file != nil) {
        resource = [NSDictionary dictionaryWithContentsOfFile:file];
    }
    
    return resource;
}

- (NSDictionary *)readImageResourceFromFile
{
    NSDictionary *resource = nil;
    NSString *file = [[NSBundle mainBundle] pathForResource:kImageFile ofType:kFileType];
    if (file != nil) {
        resource = [NSDictionary dictionaryWithContentsOfFile:file];
    }
    
    return resource;
}



@end
