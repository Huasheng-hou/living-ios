//
//  LMScanRequest.m
//  living
//
//  Created by Ding on 2016/11/2.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "LMScanRequest.h"

@implementation LMScanRequest

-(id)initWithscanningResult:(NSString *)scanningResult
{
    self = [super init];
    
    if (self){
        
        NSMutableDictionary *bodyDict   = [NSMutableDictionary new];
        
        if (scanningResult){
            [bodyDict setObject:scanningResult forKey:@"scanningResult"];
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
    return @"friends/scanning";
}



@end
