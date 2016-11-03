//
//  LMCouponRequest.m
//  living
//
//  Created by JamHonyZ on 2016/11/3.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "LMCouponRequest.h"

@implementation LMCouponRequest

-(id)initWithUserUuid:(NSString *)user_uuid
{
    self = [super init];
    
    if (self){
        
        NSMutableDictionary *bodyDict   = [NSMutableDictionary new];
        
        if (user_uuid){
            [bodyDict setObject:user_uuid forKey:@"user_uuid"];
        }
        
        
        NSMutableDictionary *paramsDict = [self params];
        [paramsDict setObject:bodyDict forKey:@"body"];
        
        
    }
    return self;
}

- (BOOL)isPost
{
    return YES;
}

- (NSString *)methodPath
{
    return @"coupon/list";//我的优惠券
}

@end
