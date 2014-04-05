//
//  HttpsConnectDelegate.h
//  UPPayPluginEx
//
//  Created by wxzhao on 12-9-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol UPHttpsConnectDelegate <NSObject>

- (void)httpsRecvDataFinished:(NSData*)recvData;
- (void)httpsConnectFailed:(NSString*)msg;


@end
