
//
//  HTTPProxy.h
//  FitTrainer
//
//  Created by Huasheng on 15/8/20.
//  Copyright (c) 2015年 Huasheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
#import "FitBaseRequest.h"

@protocol  CacheKeyGenerator <NSObject>

- (NSString*)genCacheKey:(FitBaseRequest *)request;
@end

typedef void (^RequestCompletedHandleBlock)(NSString * resp, NSStringEncoding encoding);
typedef void (^RequestCachableCompletedHandleBlock)(NSString * resp, BOOL isCache, NSStringEncoding encoding);
typedef void (^RequestFailedHandleBlock)(NSError * error);

@interface HTTPProxy : NSObject

@property (readonly, nonatomic) BOOL loading;
@property (readonly, nonatomic) BOOL loaded;
@property (strong, nonatomic) AFHTTPRequestOperation *oper;

- (void)start;
- (BOOL)isLoading;
- (BOOL)isLoaded;

/**
 * @brief 直接发起网络请求，不使用缓存（既没有缓存查询，也没有缓存写入）.
 */
+ (HTTPProxy *)loadWithRequest:(FitBaseRequest *)request
                     completed:(RequestCompletedHandleBlock)completeHandleBlock
                        failed:(RequestFailedHandleBlock)failedHandleBlock;


@end
