//
//  UPJsonService.m
//  UPPayPluginEx
//
//  Created by liwang on 13-7-1.
//
//

#import "UPJsonService.h"
#import "UPJsonParser.h"

static UPJsonService *_instance;
@implementation UPJsonService

+ (UPJsonService *)instance
{
    @synchronized(self)
    {
        if (_instance == nil) {
            _instance = [[UPJsonService alloc] init];
        }
    }
    
    return _instance;
}


+ (void)releaseInstance
{
    if (_instance != nil) {
        [_instance release];
        _instance = nil;
    }
}

- (id)parseJsonString:(NSString *)string
{
    if (!_jsonParser)
		_jsonParser = [UPJsonParser new];
    
    id repr = [_jsonParser objectWithString:string];
    if (repr)
        return repr;
    
    NSLog(@"-JSONValue failed. Error trace is: %@", [_jsonParser errorTrace]);
    return nil;
}



- (void)dealloc
{
    if (_jsonParser != nil) {
        [_jsonParser release];
        _jsonParser = nil;
    }
    
    [super dealloc];
}

@end
