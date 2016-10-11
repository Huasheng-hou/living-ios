//
//  DYloginRequest.m
//  dirty
//
//  Created by Ding on 16/8/24.
//  Copyright © 2016年 Huasheng. All rights reserved.
//

#import "DYloginRequest.h"

@implementation DYloginRequest

- (id)initWithPhone:(NSString *)phone andCode:(NSString *)code andPassword:password
{
    self = [super init];
    
    if (self){
        
        NSMutableDictionary *bodyDict   = [NSMutableDictionary new];
        
        if (phone){
            [bodyDict setObject:phone forKey:@"phone"];
        }
        
        if (code){
            [bodyDict setObject:code forKey:@"captcha"];
        }
        if (password){
            [bodyDict setObject:password forKey:@"password"];
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
    return @"user/login";
}

@end
