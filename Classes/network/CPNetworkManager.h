//
//  CPNetworkManager.h
//  Cashier
//
//  Created by liwang on 14-1-15.
//  Copyright (c) 2014年 liwang. All rights reserved.
//

#import <Foundation/Foundation.h>



typedef void (^CPNKErrorBlock) (NSString* error);
typedef void (^CPNKSuccessBlock) (NSString* response);

@interface CPNetworkManager : NSObject<NSURLConnectionDelegate>

- (void)post:(NSString*)url
          body:(NSString*)body
        header:(NSDictionary*)header
successHandler:(CPNKSuccessBlock) successBlock
  errorHandler:(CPNKErrorBlock) errorBlock;



@end
