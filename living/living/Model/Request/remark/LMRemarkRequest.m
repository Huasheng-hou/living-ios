//
//  LMRemarkRequest.m
//  living
//
//  Created by hxm on 2017/5/4.
//  Copyright © 2017年 chenle. All rights reserved.
//

#import "LMRemarkRequest.h"

@implementation LMRemarkRequest

- (instancetype)initWithFriendUuid:(NSString *)friendUuid andRemark:(NSString *)remark{
    
    if (self = [super init]) {
        NSMutableDictionary * body = [NSMutableDictionary new];
        
        if (friendUuid) {
            [body setObject:friendUuid forKey:@"friend_uuid"];
        }
        if (remark) {
            [body setObject:remark forKey:@"remark"];
        }
        
        NSMutableDictionary * params = [self params];
        [params setObject:body forKey:@"body"];
    }
    return self;
    
}

- (BOOL)isPost{
    return YES;
}

- (NSString *)methodPath{
    
    return @"friends/remark";
}
@end
