//
//  FirUploadEventFileRequest.m
//  firefly
//
//  Created by JamHonyZ on 16/1/29.
//  Copyright © 2016年 Huasheng. All rights reserved.
//

#import "FirUploadEventFileRequest.h"

@implementation FirUploadEventFileRequest

- (instancetype)initWithFileUUID:(NSString *)fileUUID andEventUUID:(NSString *)eventUUID
{
    self = [super init];
    if (self) {
        
        NSMutableDictionary *body = [NSMutableDictionary dictionaryWithCapacity:0];
        if (fileUUID) {
            [body setValue:fileUUID forKey:@"file_uuid"];
        }
        if (eventUUID) {
            [body setValue:eventUUID forKey:@"event_uuid"];
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
    return @"file/uploadEventFile";
}

@end
