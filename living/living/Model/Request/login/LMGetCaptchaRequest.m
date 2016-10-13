//
//  LMGetCaptchaRequest.m
//  living
//
//  Created by Ding on 16/10/13.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "LMGetCaptchaRequest.h"

@implementation LMGetCaptchaRequest
{
    NSString    *_phone;
}

- (id)initWithPhone:(NSString *)phone
{
    self = [super init];
    if (self) {
        
        if (phone && [phone isKindOfClass:[NSString class]]) {
            _phone  = phone;
        }
    }
    
    return self;
}

- (NSString *)methodPath
{
    return [NSString stringWithFormat:@"user/captcha/%@", _phone];
}

@end
