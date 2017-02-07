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
    return @"http://120.26.137.44/java-web/iosapp";
}


- (NSString *)methodPath {
    
    return nil;
}


@end
