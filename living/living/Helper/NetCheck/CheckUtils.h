//
//  HCBCheckUtils.h
//  HuanCheBa
//
//  Created by 林程宇 on 14-9-15.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CheckUtils : NSObject

// 检查网络环境
+ (BOOL)isEnableWIFI;
+ (BOOL)isEnable3G;
+ (BOOL)isLink;

// 检查屏幕类型
+ (BOOL)isRetina;

@end
