//
//  LMArtcleTypeRequest.m
//  living
//
//  Created by Ding on 2016/12/7.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "LMArtcleTypeRequest.h"

@implementation LMArtcleTypeRequest

-(id)init
{
    self = [super init];
    
    if (self){
        
        NSMutableDictionary *bodyDict   = [NSMutableDictionary new];
        
        
        NSMutableDictionary *paramsDict = [self params];
        [paramsDict setObject:bodyDict forKey:@"body"];
    }
    return self;
}


- (NSString *)methodPath
{
    return @"article/type";
}


@end
