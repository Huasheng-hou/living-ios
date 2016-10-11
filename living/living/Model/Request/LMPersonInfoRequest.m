//
//  LMPersonInfoRequest.m
//  living
//
//  Created by Ding on 16/10/11.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "LMPersonInfoRequest.h"

@implementation LMPersonInfoRequest

{
    NSString    *_uuid;
}

- (id)initWithPhone:(NSString *)uuid
{
    self = [super init];
    
    if (self){
        _uuid  = uuid;
        
        NSMutableDictionary *bodyDict   = [NSMutableDictionary new];
        
//        if (uuid){
//            [bodyDict setObject:uuid forKey:@"uuid"];
//        }
//        
        NSMutableDictionary *paramsDict = [self params];
        [paramsDict setObject:bodyDict forKey:@"body"];
        
        
    }
    return self;
}

- (NSString *)methodPath
{
    return [NSString stringWithFormat:@"user/%@", _uuid];
}

@end
