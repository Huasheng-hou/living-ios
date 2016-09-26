//
//  FirGetUserInfoRequest.m
//  firefly
//
//  Created by JamHonyZ on 16/1/21.
//  Copyright © 2016年 Huasheng. All rights reserved.
//

#import "FirGetUserInfoRequest.h"
#import "FitUserManager.h"


@implementation FirGetUserInfoRequest

- (NSString *)methodPath
{
    return [NSString stringWithFormat:@"user/getUserInfo/%@", [[FitUserManager sharedUserManager] uuid]];
}

@end
