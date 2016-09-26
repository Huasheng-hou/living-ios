//
//  NSString+HCBStringHelper.h
//  HuanCheBa
//
//  Created by 林程宇 on 14-9-15.
//  Copyright (c) 2014年 LinChengyu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (StringHelper)

- (NSString *)md5;
- (NSString *)toGBK;
- (NSString *)trim;
- (NSString *)urlEncode;

@end
