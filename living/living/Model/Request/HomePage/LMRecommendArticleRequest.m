//
//  LMRecommendArticleRequest.m
//  living
//
//  Created by hxm on 2017/3/10.
//  Copyright © 2017年 chenle. All rights reserved.
//

#import "LMRecommendArticleRequest.h"

@implementation LMRecommendArticleRequest

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
    return @"article/recommend";
}






@end
