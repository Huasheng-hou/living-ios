//
//  LMCouponUseRequest.m
//  living
//
//  Created by Ding on 2016/11/8.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "LMCouponUseRequest.h"

@implementation LMCouponUseRequest
-(id)initWithOrder_uuid:(NSString *)order_uuid
            couponMoney:(NSString *)couponMoney
             couponUuid:(NSString *)coupon_uuid
{
    self = [super init];
    
    if (self){
        
        NSMutableDictionary *bodyDict   = [NSMutableDictionary new];
        
        if (order_uuid){
            [bodyDict setObject:order_uuid forKey:@"order_uuid"];
        }
        if (couponMoney){
            [bodyDict setObject:couponMoney forKey:@"couponMoney"];
        }
        
        if (coupon_uuid){
            [bodyDict setObject:coupon_uuid forKey:@"coupon_uuid"];
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
    return @"order/coupon";
}

@end
