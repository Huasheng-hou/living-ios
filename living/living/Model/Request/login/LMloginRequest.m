//
//  LMloginRequest.m
//  living
//
//  Created by Ding on 16/10/13.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "LMloginRequest.h"

@implementation LMloginRequest

{
    NSString    *_phone;
}

- (id)initWithPhone:(NSString *)phone
        andPassword:(NSString *)password
         andCaptcha:(NSString *)captcha
{
    self = [super init];
    if (self) {
        
        NSMutableDictionary     *bodyDict   = [NSMutableDictionary new];
        
        if (phone && [phone isKindOfClass:[NSString class]]) {
            
            _phone      = phone;
            [bodyDict setObject:phone forKey:@"phone"];
        }
        
        if (password && [password isKindOfClass:[NSString class]]) {
            [bodyDict setObject:password forKey:@"password"];
        }
        
        if (captcha && [captcha isKindOfClass:[NSString class]]) {
            [bodyDict setObject:captcha forKey:@"captcha"];
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
    return [NSString stringWithFormat:@"user/login/%@", _phone];
}

@end
