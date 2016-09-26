//
//  FirUploadFileRequest.m
//  firefly
//
//  Created by JamHonyZ on 16/1/29.
//  Copyright © 2016年 Huasheng. All rights reserved.
//

#import "FirUploadFileRequest.h"

@implementation FirUploadFileRequest

- (instancetype)initWithTpye:(NSString *)type andFileName:(NSString *)fileName
{
    self = [super init];
    if (self) {
        
        self.type = type;
        NSMutableDictionary *body = [NSMutableDictionary dictionaryWithCapacity:0];
        [body setValue:fileName forKey:@"filename"];
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
    return @"file/do_upload";
}

@end
