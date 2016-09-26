//
//  hcb_CarInfoManager.h
//  HuanCheBa
//
//  Created by 赵洋 on 15/4/7.
//  Copyright (c) 2015年 huancheclub. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FitSignalCacheManager : NSObject

+ (FitSignalCacheManager *)sharedManager;

- (void)saveCache:(NSString *)data forKey:(NSString*) key;
- (void)removeCacheForKey:(NSString *)key;

- (NSString *)queryDataFor:(NSString *)key;
- (void)clearAll;

@end
