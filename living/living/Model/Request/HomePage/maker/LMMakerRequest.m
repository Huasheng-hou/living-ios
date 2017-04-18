//
//  LMMakerRequest.m
//  living
//
//  Created by hxm on 2017/3/27.
//  Copyright © 2017年 chenle. All rights reserved.
//

#import "LMMakerRequest.h"

@implementation LMMakerRequest

- (instancetype)init{
    if (self = [super init]) {
        NSMutableDictionary * body = [NSMutableDictionary new];
        
        NSMutableDictionary * params = [self params];
        [params setObject:body forKey:@"body"];
    }
    return self;
}



- (NSString *)methodPath{
    
    return @"maker/story";
}

@end
