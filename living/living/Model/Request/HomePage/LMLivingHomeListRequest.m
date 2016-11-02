//
//  LMLivingHomeListRequest.m
//  living
//
//  Created by Ding on 2016/10/26.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "LMLivingHomeListRequest.h"

@implementation LMLivingHomeListRequest

-(id)initWithLivingUuid:(NSString *)living_uuid
{
    self = [super init];
    if (self) {
        NSMutableDictionary *body = [NSMutableDictionary new];
        if (living_uuid) {
            [body setObject:living_uuid forKey:@"living_uuid"];
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
    return @"living/list";
}

@end
