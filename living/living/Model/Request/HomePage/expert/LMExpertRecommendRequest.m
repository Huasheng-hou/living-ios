//
//  LMExpertRecommendRequest.m
//  living
//
//  Created by hxm on 2017/3/14.
//  Copyright © 2017年 chenle. All rights reserved.
//

#import "LMExpertRecommendRequest.h"

@implementation LMExpertRecommendRequest
{
    NSString * _category;
}
- (instancetype)initWithCategory:(NSString *)category{
    if (self = [super init]) {
        _category = category;
        NSMutableDictionary *body = [NSMutableDictionary new];
        
        NSMutableDictionary *parmDic = [self params];
        [parmDic setValue:body forKey:@"body"];
        
    }
    return self;
}

- (NSString *)methodPath{
    
    return [NSString stringWithFormat:@"master/recommend/%@", _category];
}

@end
