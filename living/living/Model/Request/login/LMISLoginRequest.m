//
//  LMISLoginRequest.m
//  living
//
//  Created by Ding on 2016/11/29.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "LMISLoginRequest.h"

@implementation LMISLoginRequest
- (id)init{
    
    self = [super init];
    
    if (self) {
        
        NSMutableDictionary *bodyDict   = [NSMutableDictionary new];
        NSMutableDictionary *paramsDict = [self params];
        [paramsDict setObject:bodyDict forKey:@"body"];
    }
    return self;
}

- (NSString *)serverHost
{
    return @"http://app.cars48db.com/wechat-api/iosapp";
}


- (NSString *)methodPath {
    
    return nil;
}


@end
