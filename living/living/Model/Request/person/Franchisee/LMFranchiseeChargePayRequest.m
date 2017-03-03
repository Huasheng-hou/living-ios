//
//  LMFranchiseeChargePayRequest.m
//  living
//
//  Created by Ding on 2017/3/1.
//  Copyright © 2017年 chenle. All rights reserved.
//

#import "LMFranchiseeChargePayRequest.h"

@implementation LMFranchiseeChargePayRequest
- (id)initWithPayRecharge:(NSString *)recharge
            andLivingUuid:(NSString *)living_uuid
                 andPhone:(NSString *)phone
                  andName:(NSString *)name
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
        if (phone) {
            [bodyDict setObject:phone forKey:@"phone"];
        }
        
        if (name) {
            [bodyDict setObject:name forKey:@"name"];
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
    return @"balance/franchisee";//支付加盟费（余额）
}


@end
