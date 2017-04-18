//
//  LMNearbyLivingRequest.m
//  living
//
//  Created by hxm on 2017/3/22.
//  Copyright © 2017年 chenle. All rights reserved.
//

#import "LMNearbyLivingRequest.h"

@implementation LMNearbyLivingRequest
{
    NSString * _city;
}
- (instancetype)initWithCity:(NSString *)city{
    if (self = [super init]) {
        _city = city;
        
        NSMutableDictionary * body = [NSMutableDictionary new];
        
        if (city) {
            [body setObject:city forKey:@"city"];
        }
        
        
        NSMutableDictionary * bodyDic = [self params];
        [bodyDic setObject:body forKey:@"body"];
    }
    return self;
}

- (BOOL)isPost{
    return YES;
}

- (NSString *)methodPath{
    return @"living/maker";
}

@end
