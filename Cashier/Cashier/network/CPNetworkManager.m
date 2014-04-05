//
//  CPNetworkManager.m
//  Cashier
//
//  Created by liwang on 14-1-15.
//  Copyright (c) 2014年 liwang. All rights reserved.
//

#import "CPNetworkManager.h"



@interface CPNetworkManager ()
{
    NSMutableData *_receivedData;
}

@property(nonatomic, copy)CPNKErrorBlock errorHandler;
@property(nonatomic, copy)CPNKSuccessBlock successHandler;


@end


@implementation CPNetworkManager
@synthesize errorHandler;
@synthesize successHandler;

- (void)dealloc
{
    self.errorHandler = nil;
    self.successHandler = nil;
    
    [super dealloc];
}


- (void)post:(NSString*)url
        body:(NSString*)body
      header:(NSDictionary*)header
successHandler:(CPNKSuccessBlock) successBlock
errorHandler:(CPNKErrorBlock) errorBlock
{
    self.errorHandler = errorBlock;
    self.successHandler = successBlock;
    NSURL *lUrl = [NSURL URLWithString:url];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:lUrl];
    [request setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPMethod:@"POST"];
    NSURLConnection *connect = [[[NSURLConnection alloc] initWithRequest:request delegate:self] autorelease];
    [connect start];
}



#pragma mark- NetDelegate


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse*)response
{
    NSHTTPURLResponse* rsp = (NSHTTPURLResponse*)response;
    
    if ([rsp statusCode] == 200)
    {
        
        
        if (_receivedData != nil)
        {
            [_receivedData release];
            _receivedData = nil;
        }
        _receivedData = [[NSMutableData alloc] init];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_receivedData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSString *string = nil;
    if (_receivedData != nil) {
        string = [[[NSString alloc] initWithData:_receivedData encoding:NSUTF8StringEncoding] autorelease];
        NSLog(@"responseData=%@", string);
        self.successHandler(string);
    }
    
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"netError!");
    self.errorHandler(@"netError!");
}




@end
