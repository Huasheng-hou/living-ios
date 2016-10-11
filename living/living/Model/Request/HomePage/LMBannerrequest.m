//
//  LMBannerrequest.m
//  living
//
//  Created by Ding on 16/10/11.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "LMBannerrequest.h"

@implementation LMBannerrequest


- (id)init
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
    return [NSString stringWithFormat:@"home/banner"];
}


@end
