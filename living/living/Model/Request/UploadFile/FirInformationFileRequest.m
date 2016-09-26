//
//  FirInformationFileRequest.m
//  firefly
//
//  Created by Ding on 16/6/16.
//  Copyright © 2016年 Huasheng. All rights reserved.
//

#import "FirInformationFileRequest.h"

@implementation FirInformationFileRequest

- (instancetype)initWithStaffID:(NSString *)staffID
{
    self = [super init];
    if (self) {
        NSMutableDictionary *body = [NSMutableDictionary new];
        if (staffID) {
            [body setValue:staffID forKey:@"staffID"];
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
    return @"login/userinfo";
}

@end
