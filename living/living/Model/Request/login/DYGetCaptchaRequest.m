//
//  DYGetCaptchaRequest.m
//  dirty
//
//  Created by Ding on 16/8/24.
//  Copyright © 2016年 Huasheng. All rights reserved.
//

#import "DYGetCaptchaRequest.h"

@implementation DYGetCaptchaRequest

{
    NSString    *_phone;
}

- (id)initWithPhone:(NSString *)phone
{
    self = [super init];
    
    if (self){
        _phone  = phone;
        
        NSMutableDictionary *bodyDict   = [NSMutableDictionary new];
        
//        if (phone){
//            [bodyDict setObject:phone forKey:@"phone"];
//        }
        
        NSMutableDictionary *paramsDict = [self params];
        [paramsDict setObject:bodyDict forKey:@"body"];
        
        
    }
    return self;
}

- (NSString *)methodPath
{
    return [NSString stringWithFormat:@"captcha/%@", _phone];//获取验证码路径
}


@end
