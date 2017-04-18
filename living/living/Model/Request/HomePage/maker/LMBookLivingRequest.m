//
//  LMBookLivingRequest.m
//  living
//
//  Created by hxm on 2017/3/22.
//  Copyright © 2017年 chenle. All rights reserved.
//

#import "LMBookLivingRequest.h"

@implementation LMBookLivingRequest

- (id)initWithName:(NSString *)name andPhone:(NSString *)phone andLivingUuid:(NSString *)livingUuid{
    if (self = [super init]) {
        NSMutableDictionary * body = [NSMutableDictionary new];
        
        if (name) {
            [body setObject:name forKey:@"name"];
        }
        if (phone) {
            [body setObject:phone forKey:@"phone"];
        }
        if (livingUuid) {
            [body setObject:livingUuid forKey:@"living_uuid"];
        }
        NSMutableDictionary * bodyDic = [self params];
        [bodyDic setObject:body forKey:@"body"];
        
    }
    return self;
}

- (BOOL)isPost{
    
    return YES;
}

- (NSString *)methodPath{
    
    return @"maker/book";
}

@end
