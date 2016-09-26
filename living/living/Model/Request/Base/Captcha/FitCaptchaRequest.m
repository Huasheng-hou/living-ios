//
//  FitCaptchaRequest.m
//  Baby
//
//  Created by Huasheng on 15/12/26.
//  Copyright © 2015年 Huasheng. All rights reserved.
//

#import "FitCaptchaRequest.h"

@implementation FitCaptchaRequest
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
    return [NSString stringWithFormat:@"user_login/sms_captcha/%@", _phone];
}

@end
