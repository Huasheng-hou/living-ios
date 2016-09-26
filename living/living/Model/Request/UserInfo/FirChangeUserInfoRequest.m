//
//  FirChangeUserInfoRequest.m
//  firefly
//
//  Created by JamHonyZ on 16/1/20.
//  Copyright © 2016年 Huasheng. All rights reserved.
//

#import "FirChangeUserInfoRequest.h"
#import "FitUserManager.h"

@implementation FirChangeUserInfoRequest

- (instancetype)initWithAvatar:(NSString *)avatar andNickname:(NSString *)nickname andName:(NSString *)name andGender:(NSString *)gender andAddress:(NSString *)address andFirm:(NSString *)firm andContact:(NSString *)contact
{
    self = [super init];
    if (self) {
        
        NSMutableDictionary *body = [NSMutableDictionary dictionaryWithCapacity:0];
        if (avatar) {
            [body setValue:avatar forKey:@"avatar"];
        }
        if (nickname) {
            [body setValue:nickname forKey:@"nickname"];
        }
        if (name) {
            [body setValue:name forKey:@"name"];
        }
        if (gender) {
            [body setValue:gender forKey:@"gender"];
        }
        if (address) {
            [body setValue:address forKey:@"address"];
        }
        if (firm) {
            [body setValue:firm forKey:@"firm"];
        }
        if (contact) {
            [body setValue:contact forKey:@"contact"];
        }
        NSMutableDictionary *parmDic = [self params];
        [parmDic setValue:body forKey:@"body"];
        
    }
    return self;
}

- (BOOL)isPost
{
    return YES;
}

- (NSString *)methodPath
{
    return [NSString stringWithFormat:@"user/changeUserInfo"];
}

@end
