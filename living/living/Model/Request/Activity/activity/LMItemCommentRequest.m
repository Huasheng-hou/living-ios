//
//  LMItemCommentRequest.m
//  living
//
//  Created by hxm on 2017/3/29.
//  Copyright © 2017年 chenle. All rights reserved.
//

#import "LMItemCommentRequest.h"

@implementation LMItemCommentRequest

- (id)initWithEventUuid:(NSString *)eventUuid andContent:(NSString *)commentContent andStar:(NSString *)star andPhotos:(NSArray *)photos{
    
    if (self = [super init]) {
        
        NSMutableDictionary *bodyDict   = [NSMutableDictionary new];
        
        if (eventUuid){
            [bodyDict setObject:eventUuid forKey:@"event_uuid"];
        }
        if (commentContent){
            [bodyDict setObject:commentContent forKey:@"comment_content"];
        }
    
        if (star){
            [bodyDict setObject:star forKey:@"star"];
        }
    
        if (photos){
            [bodyDict setObject:photos forKey:@"photos"];
        }
    
        NSMutableDictionary *paramsDict = [self params];
        [paramsDict setObject:bodyDict forKey:@"body"];
        
    }
    return self;
    
}


- (BOOL)isPost{
    return YES;
}
- (NSString *)methodPath{
    
    return @"item/comment";
}
@end
