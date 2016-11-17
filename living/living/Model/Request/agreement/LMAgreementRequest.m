//
//  LMAgreementRequest.m
//  living
//
//  Created by Ding on 2016/11/17.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "LMAgreementRequest.h"

@implementation LMAgreementRequest

- (id)initWithAgreement:(NSString *)agreement
{
    self = [super init];
    
    if (self){
        
        NSMutableDictionary *bodyDict   = [NSMutableDictionary new];
        if (agreement) {
            [bodyDict setObject:agreement forKey:@"agreement"];
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
    return @"balance/agree";//同意支付协议
}


@end
