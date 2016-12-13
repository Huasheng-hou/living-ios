//
//  LMHostChoiceRequest.m
//  living
//
//  Created by Ding on 2016/12/13.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "LMHostChoiceRequest.h"

@implementation LMHostChoiceRequest

- (id)initWithUserId:(NSArray *)userId
{
    self = [super init];
    
    if (self){
        
        NSMutableDictionary *bodyDict   = [NSMutableDictionary new];
        
        if (userId){
            [bodyDict setObject:userId forKey:@"userId"];
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
    return @"voice/choice";
}

@end
