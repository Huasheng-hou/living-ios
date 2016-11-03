//
//  LMAliRechargeRequest.m
//  living
//
//  Created by Ding on 16/10/18.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "LMAliRechargeRequest.h"

@implementation LMAliRechargeRequest

- (id)initWithAliRecharge:(NSString *)recharge andLivingUuid:(NSString *)living_uuid
{
    self = [super init];
    if (self)
    {
        NSMutableDictionary     *bodyDict   = [NSMutableDictionary new];
        
        if (recharge) {
            [bodyDict setObject:recharge forKey:@"totalMoney"];
        }
        if (living_uuid) {
            [bodyDict setObject:living_uuid forKey:@"living_uuid"];
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
    return @"alipayRecharge/order";//支付宝充值下单
}

@end
