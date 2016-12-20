//
//  FirUploadFileRequest.m
//  living
//
//  Created by Ding on 2016/12/19.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "FirUploadFileRequest.h"
#import "FitUserManager.h"

@implementation FirUploadFileRequest

- (id)initWithFileName:(NSString *)filename
{
    if (self = [super init]) {
        NSMutableDictionary *bodyParams = [NSMutableDictionary dictionaryWithCapacity:1];
        
        if (filename) {
            [bodyParams setObject:filename forKey:@"file_name"];
            self.imageName = filename;
        }
        
        NSMutableDictionary *paramsDict = [self params];
        [paramsDict setObject:bodyParams forKey:@"body"];
    }
    
    return self;
}

- (BOOL)isPost
{
    return YES;
}

- (NSString *)methodPath
{
    return [NSString stringWithFormat:@"media/audio_upload?user_uuid=%@&password=%@",[FitUserManager sharedUserManager].uuid,[FitUserManager sharedUserManager].password];
}

- (BOOL)isImageInclude
{
    return YES;
}

@end
