//
//  LMPublicVoicProjectRequest.m
//  living
//
//  Created by Ding on 2016/12/14.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "LMPublicVoicProjectRequest.h"

@implementation LMPublicVoicProjectRequest

-(id)initWithVoice_uuid:(NSString *)voice_uuid
          Project_title:(NSString *)project_title
            Project_dsp:(NSString *)project_dsp
           Project_imgs:(NSString *)project_imgs
{
    self = [super init];
    
    if (self){
        
        NSMutableDictionary *bodyDict   = [NSMutableDictionary new];
        
        if (voice_uuid){
            [bodyDict setObject:voice_uuid forKey:@"voice_uuid"];
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
    return @"voice/publish/project";//发布语音课程项目
}

@end
