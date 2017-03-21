//
//  LMYGBBannerRequest.m
//  living
//
//  Created by hxm on 2017/3/21.
//  Copyright © 2017年 chenle. All rights reserved.
//

#import "LMYGBBannerRequest.h"

@implementation LMYGBBannerRequest

- (instancetype)init{
    if (self = [super init]) {
        NSMutableDictionary *bodyDict   = [NSMutableDictionary new];
        NSMutableDictionary *paramsDict = [self params];
        [paramsDict setObject:bodyDict forKey:@"body"];
    }
    return self;
}

- (NSString *)methodPath{
    return @"coin/banner";
}
@end
