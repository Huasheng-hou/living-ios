//
//  LMOrderpayRequest.m
//  living
//
//  Created by Ding on 2016/10/30.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "LMOrderpayRequest.h"

@implementation LMOrderpayRequest


-(id)initWithOrder_uuid:(NSString *)order_uuid

{
    self = [super init];
    
    if (self){
        
        NSMutableDictionary *bodyDict   = [NSMutableDictionary new];
        
        if (order_uuid){
            [bodyDict setObject:order_uuid forKey:@"order_uuid"];
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
    return @"order/comfirm";
}

@end
