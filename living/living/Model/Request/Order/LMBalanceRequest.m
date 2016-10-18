//
//  LMBalanceRequest.m
//  living
//
//  Created by Ding on 16/10/18.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "LMBalanceRequest.h"

@implementation LMBalanceRequest

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

- (BOOL)isPost
{
    return YES;
}


- (NSString *)methodPath
{
    return @"balance/wallet";
}

@end
