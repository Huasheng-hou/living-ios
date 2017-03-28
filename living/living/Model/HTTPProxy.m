
//
//  HTTPProxy.m
//  FitTrainer
//
//  Created by Huasheng on 15/8/20.
//  Copyright (c) 2015年 Huasheng. All rights reserved.
//

#import "HTTPProxy.h"
#import "FitSignalCacheManager.h"

@implementation HTTPProxy

+ (HTTPProxy *)loadWithRequest:(FitBaseRequest *)request
                     completed:(RequestCompletedHandleBlock)completeHandleBlock
                        failed:(RequestFailedHandleBlock)failedHandleBlock
{
    HTTPProxy       *proxy  = [[HTTPProxy alloc] init];
    NSURLRequest    *urlReq = [request req];
    
    proxy.oper = [[AFHTTPRequestOperation alloc] initWithRequest:urlReq];
    [proxy.oper setSuccessCallbackQueue:(dispatch_get_global_queue(0, 0))];
    [proxy.oper setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (completeHandleBlock) {
            
            completeHandleBlock([operation responseString], [operation responseStringEncoding]);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"==================================================");
        NSLog(@"加载数据失败，Error: %@", [error localizedDescription]);
        NSLog(@"Class:::%@", NSStringFromClass([self class]));
        NSLog(@"==================================================");
        
        if (failedHandleBlock) {
            failedHandleBlock(error);
        }
    }];
    
    return proxy;
}


- (void)start
{
    if (_oper && _oper.isReady) {
        [_oper start];
    }
}

- (BOOL)isLoading
{
    _loading = [_oper isExecuting];
    return _loading;
}

- (BOOL)isLoaded
{
    _loaded = [_oper isFinished];
    return _loaded;
}

@end
