//
//  HttpsConnect.h
//
//  Created by UnionPay on 11-10-10.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UPHttpsConnectDelegate.h"

@interface UPHttpsConnect : NSObject {
    NSMutableData* mRecvData;
    NSURLConnection* mURLConnection;
    NSTimer* mTimeOut;
    BOOL mFinished;
    id<UPHttpsConnectDelegate> delegate;
}

@property(nonatomic,assign) id<UPHttpsConnectDelegate> delegate;

+ (UPHttpsConnect*)shareInstance;
+ (void)releaseInstance;


- (void)postMessage:(NSString*)message;
- (void)handleTimeOut:(NSTimer*)timer;
- (NSURL*)url:(NSString*)mode;
- (void)stopTimer;
- (void)stopConnection;

@end

