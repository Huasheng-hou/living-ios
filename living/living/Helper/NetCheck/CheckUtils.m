//
//  HCBCheckUtils.m
//  HuanCheBa
//
//  Created by 林程宇 on 14-9-15.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import "CheckUtils.h"
#import <UIKit/UIKit.h>
#import "FitReachability.h"

@implementation CheckUtils

+ (BOOL)isEnableWIFI
{
    return ([[FitReachability reachabilityForLocalWiFi] isReachableViaWiFi]);
}

+ (BOOL)isEnable3G
{
    return ([[FitReachability reachabilityForInternetConnection] isReachableViaWWAN]);
}

+ (BOOL)isLink
{
    if ([CheckUtils isEnable3G] || [CheckUtils isEnableWIFI]) {
        return YES;
    }
    return NO;
}

+ (BOOL)isRetina
{
    if ([[UIScreen mainScreen] scale] > 1.0) {
        return YES;
    }
    return NO;
}

@end
