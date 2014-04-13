//
//  HttpsConnect.m
//
//  Created by xy on 10-3-19.
//  Copyright 2010 UnionPay. All rights reserved.
//

#include "UPChannelExpress.h"
#include "UPXProguardUtil.h"
#import "UPHttpsConnect.h"
#import "UPLocale.h"
#import "UPConfig.h"
#import "UPStringID.h"
#import "UPDataContainer.h"


#define kClientV3Server     @"http://218.80.192.213:1725/gateway/mobile/json"

#define KURL_PM             @"http://202.101.25.178:8080/gateway/mobile/json"
#define KURL_INNERTEST      @"http://120.204.69.167:11000/gateway/mobile/json"
#define KURL_TEST           @"http://222.66.233.198:8080/gateway/mobile/json"
#define KURL_PAY             @"46D161D187B21F6C33FFF3999ACBB09867630C345D51972BA8C2EE9D2D17922FF24301D35464BEB070A367307C2E8A67"
#define kDNS                @"33FFF3999ACBB09867630C345D51972B814D8D037274A316" 

#define KMAX_TIME           60

static UPHttpsConnect* _instance = nil;
@implementation UPHttpsConnect

@synthesize delegate;



+ (UPHttpsConnect*)shareInstance
{
    @synchronized(self)
    {
        if (_instance == nil) {
            _instance = [[UPHttpsConnect alloc] init];
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

- (void)dealloc {
    if (mRecvData != nil)
    {
        [mRecvData release];
        mRecvData = nil;
    }
    
    if (mURLConnection != nil)
    {
        [self stopConnection];
    }
    
    self.delegate = nil;
    [super dealloc];
}

- (NSURL*)url:(NSString*)mode
{
    NSURL *url = nil;
    if ([mode isEqualToString:KMODE_INNERTEST])
    {
        url = [NSURL URLWithString:KURL_INNERTEST];
    }
    else if ([mode isEqualToString:KMODE_TEST])
    {
        url = [NSURL URLWithString:KURL_TEST];
    }
    else if ([mode isEqualToString:KMODE_PM])
    {
        url = [NSURL URLWithString:KURL_PM];
    }
    else if ([mode isEqualToString:kMode_ClientV3])
    {
        url = [NSURL URLWithString:kClientV3Server];
    }
    else
    {
        UPXProguardUtil *util = new UPXProguardUtil(EProjectPlugin);
        char *realData = NULL;
        util->decryptData([KURL_PAY UTF8String], &realData);
        if (realData != NULL) {
            NSString *urlString = [[NSString alloc] initWithCString:realData encoding:NSUTF8StringEncoding];
            url = [NSURL URLWithString:urlString];
            url = [NSURL URLWithString:@"https://mgate.unionpay.com/gateway/mobile/upcard/json"];
            [urlString release];
            delete []realData;
        }
        delete util;
    }
    return url;
}

- (void)handleTimeOut:(NSTimer*)timer
{
    if (!mFinished && mURLConnection) {
        [self stopConnection];
        [delegate httpsConnectFailed:[[UPLocale instance] getStringById:KSTR_ERR_NETWORK]];
        
    }
}

- (void)stopTimer
{
    [mTimeOut invalidate];
    mTimeOut = nil;
}

- (void)stopConnection
{
    mFinished = YES;
    if (mURLConnection != nil)
    {
        [mURLConnection cancel];
        [mURLConnection release];
        mURLConnection = nil;
    }
}

- (void)postMessage:(NSString*)message
{
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    mFinished = NO;
    mTimeOut = [NSTimer scheduledTimerWithTimeInterval:KMAX_TIME target:self selector:@selector(handleTimeOut:) userInfo:nil repeats:NO];
    NSURL *url = [self url:[UPDataContainer instance].mMode];
	NSData * postData=[message dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest * urlRequest=[NSMutableURLRequest requestWithURL:url];
	[urlRequest setHTTPMethod:@"POST"];
	[urlRequest setHTTPBody:postData];
    
    if ([UPDataContainer instance].mSessionId) 
    {
        [urlRequest addValue:[UPDataContainer instance].mSessionId forHTTPHeaderField:KHEADER_SID];
    }
    else
    {
        //get sessionKey
        char* dataOut = NULL;
        UPChannelExpress::instance()->encryptSessionKey(&dataOut);
        if (dataOut)
        {
            NSString *headerValue = [[NSString alloc] initWithCString:dataOut encoding:NSUTF8StringEncoding];
            [urlRequest addValue:headerValue forHTTPHeaderField:KHEADER_SECRET];
            [urlRequest addValue:kMagicNumberValue forHTTPHeaderField:kMagicNumberName];
            free(dataOut);
            [headerValue release];
        }
    }
    
    mURLConnection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
    [mURLConnection start];
    [pool release];
}



- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse*)response 
{
    NSHTTPURLResponse* rsp = (NSHTTPURLResponse*)response;
    
    if ([rsp statusCode] != 200)
    {
        [delegate httpsConnectFailed:[NSString stringWithFormat:@"%d",[rsp statusCode]]];
        [self stopConnection];
        [self stopTimer];
    }
    else
    {
        if (mRecvData != nil)
        {
            [mRecvData release];
            mRecvData = nil;
        }
        mRecvData = [[NSMutableData alloc] init];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [mRecvData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection 
{
    [self stopConnection];
    [self stopTimer];
    [delegate httpsRecvDataFinished:mRecvData];
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [self stopConnection];
    [self stopTimer];
    
    NSString* msg = [[UPLocale instance] getStringById:KSTR_ERR_NETWORK];
    [delegate httpsConnectFailed:msg];
}


- (void)connection:(NSURLConnection *)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    if([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust])
    {
        
        OSStatus            err;
        BOOL                allowConnection = NO;
        SecPolicyRef        newPolicy = NULL;
        NSMutableArray *    certificates = NULL;
        CFIndex             certCount;
        CFIndex             certIndex;
        SecTrustRef         newTrust = NULL;
        SecTrustResultType  newTrustResult;
        SecTrustRef trust = challenge.protectionSpace.serverTrust;
        
        UPXProguardUtil *util = new UPXProguardUtil(EProjectPlugin);
        char *realData = NULL;
        util->decryptData([kDNS UTF8String], &realData);
        if (realData != NULL) {
            
            CFStringRef dnsRef = NULL;
            dnsRef = CFStringCreateWithCString(kCFAllocatorDefault,
                                                    realData,
                                                    kCFStringEncodingUTF8);
            newPolicy = SecPolicyCreateSSL(false, dnsRef);
            CFRelease(dnsRef); 
            delete []realData;
        }
        delete util;
        
        if (newPolicy != NULL) {
            certificates = [NSMutableArray array];
            
            certCount = SecTrustGetCertificateCount(trust);
            for (certIndex = 0; certIndex < certCount; certIndex++) {
                SecCertificateRef   thisCertificate;
                
                thisCertificate = SecTrustGetCertificateAtIndex(trust, certIndex);
                [certificates addObject:(id)thisCertificate];
            }
            
            err = SecTrustCreateWithCertificates(
                                                 (CFArrayRef) certificates,
                                                 newPolicy,
                                                 &newTrust
                                                 );
            if (err == noErr) {
                err = SecTrustEvaluate(newTrust, &newTrustResult);
            }
            if (err == noErr) {
                allowConnection = (newTrustResult == kSecTrustResultProceed) ||
                (newTrustResult == kSecTrustResultUnspecified);
            }
        }
        
        if (newTrust != NULL) {
            CFRelease(newTrust);
        }
        if (newPolicy != NULL) {
            CFRelease(newPolicy);
        }
        
        if (allowConnection) {
            [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
        }
        else
        {
            [challenge.sender cancelAuthenticationChallenge:challenge];
        }
    }
}



@end
