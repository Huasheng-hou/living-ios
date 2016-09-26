//
//  FitUserInfoManager.m
//  FitTrainer
//
//  Created by Huasheng on 15/8/20.
//  Copyright (c) 2015年 Huasheng. All rights reserved.
//

#import "FitUserInfoManager.h"
#import "FitUserManager.h"
#import "FitSignalCacheManager.h"
#import "HTTPProxy.h"
#import "VOUtil.h"
#import "FitNotificationNames.h"

static FitUserInfoManager *__sharedUserInfoManager;

@implementation FitUserInfoManager

+ (FitUserInfoManager *)sharedManager
{
    if (!__sharedUserInfoManager) {
        __sharedUserInfoManager = [[FitUserInfoManager alloc] init];
    }
    
    return __sharedUserInfoManager;
}

- (void)getUserInfoFromServerAfterDelay:(NSTimeInterval)delay
{
    if (![[FitUserManager sharedUserManager] isLogin]) {
        return;
    }
    
    [self performSelector:@selector(getUserInfo) withObject:nil afterDelay:delay];
}

- (void)getUserInfo
{
//    FitGetUserInfoRequest   *request    = [[FitGetUserInfoRequest alloc] init];
//    
//    HTTPProxy   *proxy  = [HTTPProxy loadWithRequest:request completed:^(NSString *resp, NSStringEncoding encoding) {
//        
//        NSDictionary    *bodyDict   = [VOUtil parseBody:resp];
//        
//        if ([bodyDict objectForKey:@"phone"] && [[bodyDict objectForKey:@"phone"] isKindOfClass:[NSString class]]) {
//            [[FitUserManager sharedUserManager] setPhone:[bodyDict objectForKey:@"phone"]];
//        }
//        
//        if ([bodyDict objectForKey:@"avatar"] && [[bodyDict objectForKey:@"avatar"] isKindOfClass:[NSString class]]) {
//            [[FitUserManager sharedUserManager] setAvatar:[bodyDict objectForKey:@"avatar"]];
//        }
//        
//        if ([bodyDict objectForKey:@"nickname"] && [[bodyDict objectForKey:@"nickname"] isKindOfClass:[NSString class]]) {
//            [[FitUserManager sharedUserManager] setUsername:[bodyDict objectForKey:@"nickname"]];
//        }
//        
//        if ([bodyDict objectForKey:@"slogan"] && [[bodyDict objectForKey:@"slogan"] isKindOfClass:[NSString class]]) {
//            [[FitUserManager sharedUserManager] setSlogan:[bodyDict objectForKey:@"slogan"]];
//        }
//        
//        if ([bodyDict objectForKey:@"gender"] && [[bodyDict objectForKey:@"gender"] isKindOfClass:[NSString class]]) {
//            [[FitUserManager sharedUserManager] setGender:[bodyDict objectForKey:@"gender"]];
//        }
//        
//        if ([bodyDict objectForKey:@"birthday"] && [[bodyDict objectForKey:@"birthday"] isKindOfClass:[NSString class]]) {
//            [[FitUserManager sharedUserManager] setBirthday:[bodyDict objectForKey:@"birthday"]];
//        }
//        
//        if ([bodyDict objectForKey:@"height"] && [[bodyDict objectForKey:@"height"] isKindOfClass:[NSString class]]) {
//            [[FitUserManager sharedUserManager] setHeight:[bodyDict objectForKey:@"height"]];
//        }
//        
//        if ([bodyDict objectForKey:@"initial_weight"] && [[bodyDict objectForKey:@"initial_weight"] isKindOfClass:[NSString class]]) {
//            [[FitUserManager sharedUserManager] setWeight:[bodyDict objectForKey:@"initial_weight"]];
//        }
//        
//        if ([bodyDict objectForKey:@"target"] && [[bodyDict objectForKey:@"target"] isKindOfClass:[NSString class]]) {
//            [[FitUserManager sharedUserManager] setAim:[bodyDict objectForKey:@"target"]];
//        }
//        
//        if ([bodyDict objectForKey:@"amount"] && [[bodyDict objectForKey:@"amount"] isKindOfClass:[NSString class]]) {
//            [[FitUserManager sharedUserManager] setBalance:[bodyDict objectForKey:@"amount"]];
//        }
//
//        [[NSNotificationCenter defaultCenter] postNotificationName:FIT_UPDATE_USERINFO_NOTIFICATION object:nil];
//        
//    } failed:^(NSError *error) {
//        
//    }];
//    
//    [proxy start];
}

- (BOOL)isInfoComplete
{
    if (![[FitUserManager sharedUserManager] username] || [[[FitUserManager sharedUserManager] username] isEqualToString:@""]) {
        return NO;
    }
    
    if (![[FitUserManager sharedUserManager] avatar] || [[[FitUserManager sharedUserManager] avatar] isEqualToString:@""]) {
        return NO;
    }
    
    if (![[FitUserManager sharedUserManager] slogan] || [[[FitUserManager sharedUserManager] slogan] isEqualToString:@""]) {
        return NO;
    }
    
    if (![[FitUserManager sharedUserManager] gender] || [[[FitUserManager sharedUserManager] gender] isEqualToString:@""]) {
        return NO;
    }
    
    if (![[FitUserManager sharedUserManager] birthday] || [[[FitUserManager sharedUserManager] birthday] isEqualToString:@""]) {
        return NO;
    }
    
    if (![[FitUserManager sharedUserManager] city] || [[[FitUserManager sharedUserManager] city] isEqualToString:@""]) {
        return NO;
    }
    
    if (![[FitUserManager sharedUserManager] emp_uuid] || [[[FitUserManager sharedUserManager] emp_uuid] isEqualToString:@""]) {
        return NO;
    }
    
    if (![[FitUserManager sharedUserManager] province] || [[[FitUserManager sharedUserManager] province] isEqualToString:@""]) {
        return NO;
    }
    
 
    
    return YES;
}

@end
