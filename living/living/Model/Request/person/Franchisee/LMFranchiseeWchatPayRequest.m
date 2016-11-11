//
//  LMFranchiseeWchatPayRequest.m
//  living
//
//  Created by Ding on 2016/11/11.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "LMFranchiseeWchatPayRequest.h"

@implementation LMFranchiseeWchatPayRequest

- (id)initWithWXRecharge:(NSString *)recharge
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
    return @"join/wechat/order";//支付加盟费（微信）
}

@end
