//
//  hcb_CarInfoManager.m
//  HuanCheBa
//
//  Created by 赵洋 on 15/4/7.
//  Copyright (c) 2015年 huancheclub. All rights reserved.
//

#import "FitSignalCacheManager.h"
//#import "TMCache.h"
#import "NSString+StringHelper.h"

#define KB *1024
#define MB KB KB

NSString* const SIGNAL_CACHE = @"signal";

static FitSignalCacheManager *__sharedCarInfos;

@interface FitSignalCacheManager()
//{
//    TMCache* _cache;
//}
@end

@implementation FitSignalCacheManager

+ (FitSignalCacheManager *)sharedManager
{
    if (!__sharedCarInfos) {
        __sharedCarInfos = [[FitSignalCacheManager alloc] init];
        [__sharedCarInfos initCacheCenter];
    }
    return __sharedCarInfos;

}
- (void)initCacheCenter
{
//    _cache = [[TMCache alloc] initWithName:SIGNAL_CACHE];
//    _cache.memoryCache.costLimit = 15 MB;
//    _cache.diskCache.byteLimit = 6 MB;
}

//- (NSString *)queryDataFor:(NSString *)key
//{
    //    NSLog(@"SignalCache----query. key:'%@'",key);
    //    NSLog(@"SignalCache----cache status: memory(%lu/%lu), disk(%lu/%lu)",
    //          _cache.memoryCache.totalCost,  _cache.memoryCache.costLimit,
    //          _cache.diskCache.byteCount, _cache.diskCache.byteLimit);
//    return [_cache objectForKey:[key md5]];
//}

- (void)saveCache:(NSString *)data forKey:(NSString *)key
{
//    [_cache setObject:data forKey:[key md5]];
}

- (void)removeCacheForKey:(NSString *)key
{
    if (!key || ![key isKindOfClass:[NSString class]]) {
        return;
    }
    
//    [_cache removeObjectForKey:[key md5]];
}

- (void)clearAll
{
//    [_cache removeAllObjects];
}

@end
