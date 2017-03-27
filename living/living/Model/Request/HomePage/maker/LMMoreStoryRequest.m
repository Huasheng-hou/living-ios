//
//  LMMoreStoryRequest.m
//  living
//
//  Created by hxm on 2017/3/27.
//  Copyright © 2017年 chenle. All rights reserved.
//

#import "LMMoreStoryRequest.h"

@implementation LMMoreStoryRequest

- (instancetype)init{
    if (self = [super init]) {
        NSMutableDictionary * body = [NSMutableDictionary new];
        
        NSMutableDictionary * params = [self params];
        [params setObject:body forKey:@"body"];
    }
    return self;
}



- (NSString *)methodPath{
    
    return @"maker/more/story";
}

@end
