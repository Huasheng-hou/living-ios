//
//  LMExpertSpaceRequest.m
//  living
//
//  Created by hxm on 2017/3/23.
//  Copyright © 2017年 chenle. All rights reserved.
//

#import "LMExpertSpaceRequest.h"

@implementation LMExpertSpaceRequest

- (instancetype)initWithUserUuid:(NSString *)userUuid{
    if (self = [super init]) {
        NSMutableDictionary * body = [NSMutableDictionary new];
        
        if (userUuid) {
            [body setObject:userUuid forKey:@"user_uuid"];
        }
        
        NSMutableDictionary * paramDic = [self params];
        [paramDic setObject:body forKey:@"body"];
    }
    return self;
}

- (BOOL)isPost{
    return YES;
}

- (NSString *)methodPath{
    
    return @"master/space";
}
@end
