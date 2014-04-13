//
//  UPJsonService.h
//  UPPayPluginEx
//
//  Created by liwang on 13-7-1.
//
//

#import <Foundation/Foundation.h>

@class UPJsonParser;
@interface UPJsonService : NSObject
{
    UPJsonParser *_jsonParser;
}


+ (UPJsonService *)instance;
+ (void)releaseInstance;

- (id)parseJsonString:(NSString *)string;

@end
