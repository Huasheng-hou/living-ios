//
//  LMPublicProjectRequest.m
//  living
//
//  Created by Ding on 16/10/17.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "LMPublicProjectRequest.h"

@implementation LMPublicProjectRequest

-(id)initWithEvent_uuid:(NSString *)event_uuid
          Project_title:(NSString *)project_title
            Project_dsp:(NSString *)project_dsp
           Project_imgs:(NSString *)project_imgs
{
    self = [super init];
    
    if (self){
        
        NSMutableDictionary *bodyDict   = [NSMutableDictionary new];
        
        if (event_uuid){
            [bodyDict setObject:event_uuid forKey:@"event_uuid"];
        }
        if (project_title){
            [bodyDict setObject:project_title forKey:@"project_title"];
        }
        if (project_dsp){
            [bodyDict setObject:project_dsp forKey:@"project_dsp"];
        }
        if (project_imgs){
            [bodyDict setObject:project_imgs forKey:@"project_imgs"];
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
    return @"event/publish/project";
}



@end
