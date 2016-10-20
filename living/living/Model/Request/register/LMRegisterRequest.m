//
//  LMRegisterRequest.m
//  living
//
//  Created by Ding on 16/10/13.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "LMRegisterRequest.h"

@implementation LMRegisterRequest

- (id)initWithNickname:(NSString *)nickname
             andGender:(NSString *)gender
             andAvatar:(NSString *)avatar
           andBirtyday:(NSString *)birthday
           andProvince:(NSString *)province
               andCity:(NSString *)city
{
    self = [super init];
    
    if (self){
        
        NSMutableDictionary *bodyDict   = [NSMutableDictionary new];
        
        if (nickname){
            [bodyDict setObject:nickname forKey:@"nick_name"];
        }
        if (gender){
            [bodyDict setObject:gender forKey:@"gender"];
        }
        if (avatar){
            [bodyDict setObject:avatar forKey:@"avatar"];
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
    return @"user/edit";
}

@end
