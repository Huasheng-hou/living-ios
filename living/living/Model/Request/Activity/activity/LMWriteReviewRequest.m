//
//  LMWriteReviewRequest.m
//  living
//
//  Created by hxm on 2017/3/22.
//  Copyright © 2017年 chenle. All rights reserved.
//

#import "LMWriteReviewRequest.h"

@implementation LMWriteReviewRequest

- (id)initWithEventUuid:(NSString *)eventUuid andEventContent:(NSString *)eventContent andEventImgs:(NSArray *)eventImgs andBlend:(NSArray *)blend andDescribe:(NSString *)describe andTitle:(NSString *)title andCategory:(NSString *)category{
    
    if (self = [super init]) {
        NSMutableDictionary *bodyDict   = [NSMutableDictionary new];
        
        if (eventUuid){
            [bodyDict setObject:eventUuid forKey:@"event_uuid"];
        }
        if (eventContent){
            [bodyDict setObject:eventContent forKey:@"event_content"];
        }
        if (eventImgs){
            [bodyDict setObject:eventImgs forKey:@"event_imgs"];
        }
        if (blend){
            [bodyDict setObject:blend forKey:@"blend"];
        }
        if (describe){
            [bodyDict setObject:describe forKey:@"describe"];
        }
        if (category){
            [bodyDict setObject:category forKey:@"category"];
        }
        if (title){
            [bodyDict setObject:title forKey:@"title"];
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
    
    return @"review/write";
}
@end
