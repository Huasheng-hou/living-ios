//
//  LMNoticDeleteRequest.m
//  living
//
//  Created by Ding on 2016/10/25.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "LMNoticDeleteRequest.h"

@implementation LMNoticDeleteRequest

- (id)initWithNoticeuuid:(NSArray *)notice_uuid
{
    self = [super init];
    
    if (self){
        
        NSMutableDictionary *bodyDict   = [NSMutableDictionary new];
        
        if (notice_uuid){
            [bodyDict setObject:notice_uuid forKey:@"notice_uuid"];
        }
        NSMutableDictionary *paramsDict = [self params];
        [paramsDict setObject:bodyDict forKey:@"body"];    
    }
    return self;
}

- (BOOL)isPost
{
    return YES;
}

- (NSString *)methodPath
{
    return @"notice/delete";
}


@end
