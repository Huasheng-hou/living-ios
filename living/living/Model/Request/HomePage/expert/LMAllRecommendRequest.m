//
//  LMAllRecommendRequest.m
//  living
//
//  Created by hxm on 2017/3/14.
//  Copyright © 2017年 chenle. All rights reserved.
//

#import "LMAllRecommendRequest.h"

@implementation LMAllRecommendRequest

- (instancetype)initWithCategory:(NSString *)category{
    if (self = [super init]) {
        
        NSMutableDictionary *body = [NSMutableDictionary new];
        
        if (category){
            [body setObject:category forKey:@"category"];
        }
        
        NSMutableDictionary *parmDic = [self params];
        [parmDic setValue:body forKey:@"body"];
        
    }
    return self;
}
- (BOOL)isPost{
    
    return YES;
}
- (NSString *)methodPath{
    
    return @"master/all/recommend";
}

@end
