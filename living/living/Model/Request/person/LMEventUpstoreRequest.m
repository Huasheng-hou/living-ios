//
//  LMEventUpstoreRequest.m
//  living
//
//  Created by Ding on 2017/2/12.
//  Copyright © 2017年 chenle. All rights reserved.
//

#import "LMEventUpstoreRequest.h"

@implementation LMEventUpstoreRequest

- (id)initWithevent_uuid:(NSString *)event_uuid
           andstart_time:(NSString *)start_time
             andend_time:(NSString *)end_time
{
    self = [super init];
    if (self) {
        NSMutableDictionary *body = [NSMutableDictionary new];
        if (event_uuid) {
            [body setObject:event_uuid forKey:@"event_uuid"];
        }
        
        if (start_time) {
            [body setObject:start_time forKey:@"start_time"];
        }
        
        if (end_time) {
            [body setObject:end_time forKey:@"end_time"];
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
    return @"event/shelves";//已完结活动重新上架
}

@end
