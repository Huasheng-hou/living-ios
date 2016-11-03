//
//  LMLivingListRequest.m
//  living
//
//  Created by Ding on 2016/11/3.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "LMLivingListRequest.h"

@implementation LMLivingListRequest


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
    return @"living/all";
}

@end
