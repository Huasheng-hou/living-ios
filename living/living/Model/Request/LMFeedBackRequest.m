//
//  LMFeedBackRequest.m
//  living
//
//  Created by Ding on 16/10/19.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "LMFeedBackRequest.h"

@implementation LMFeedBackRequest

- (id)initWithFeedbackcontent:(NSString *)feedback_content
{
    self = [super init];
    
    if (self){
        
        NSMutableDictionary *bodyDict   = [NSMutableDictionary new];
        
        if (feedback_content){
            [bodyDict setObject:feedback_content forKey:@"feedback_content"];
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
    return @"feedBack/commit";
}


@end
