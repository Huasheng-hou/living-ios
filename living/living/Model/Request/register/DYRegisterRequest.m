//
//  DYRegisterRequest.m
//  dirty
//
//  Created by Ding on 16/8/25.
//  Copyright © 2016年 Huasheng. All rights reserved.
//

#import "DYRegisterRequest.h"

@implementation DYRegisterRequest

- (id)initWithNickname:(NSString *)nickname
           andPassword:(NSString *)password
             andGender:(NSString *)gender
             andAvatar:(NSString *)avatar
              andPhone:(NSString *)phone
           andBirtyday:(NSString *)birthday
           andProvince:(NSString *)province
               andCity:(NSString *)city
{
    self = [super init];
    
    if (self){
        
        NSMutableDictionary *bodyDict   = [NSMutableDictionary new];
        
        if (nickname){
            [bodyDict setObject:nickname forKey:@"nickname"];
        }
        
        if (password){
            [bodyDict setObject:password forKey:@"password"];
        }
        if (gender){
            [bodyDict setObject:gender forKey:@"gender"];
        }
        if (avatar){
            [bodyDict setObject:avatar forKey:@"avatar"];
        }
        if (phone){
            [bodyDict setObject:phone forKey:@"phone"];
        }
        if (birthday){
            [bodyDict setObject:birthday forKey:@"birthday"];
        }
        if (province){
            [bodyDict setObject:province forKey:@"province"];
        }
        if (city){
            [bodyDict setObject:city forKey:@"city"];
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
    return @"user/register";
}


@end
