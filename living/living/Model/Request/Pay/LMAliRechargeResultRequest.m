//
//  LMAliRechargeResultRequest.m
//  living
//
//  Created by Ding on 16/10/18.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "LMAliRechargeResultRequest.h"

@implementation LMAliRechargeResultRequest

- (id)initWithMyOrderUuid:(NSString *)myOrderUuid andAlipayResult:(NSDictionary *)alipayResult
{
    self = [super init];
    if (self)
    {
        
        NSMutableDictionary     *bodyDict   = [NSMutableDictionary new];
        
        if (myOrderUuid) {
            [bodyDict setObject:myOrderUuid forKey:@"myOrderUuid"];
        }
        
        if (alipayResult) {
            [bodyDict setObject:alipayResult forKey:@"alipayResult"];
        }
        
        NSMutableDictionary     *paramsDict = [self params];
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
    if (_type == 2) {
        return @"recharge/alipay/result";//支付宝充值结果确认 大礼包
    }
    
    return @"alipayRecharge/result";//支付宝充值结果确认
    
}

@end
