//
//  FirUploadVideoRequest.m
//  living
//
//  Created by Ding on 2017/2/12.
//  Copyright © 2017年 chenle. All rights reserved.
//

#import "FirUploadVideoRequest.h"
#import "FitUserManager.h"

@implementation FirUploadVideoRequest

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
    return [NSString stringWithFormat:@"media/video_upload?user_uuid=%@&password=%@",[FitUserManager sharedUserManager].uuid,[FitUserManager sharedUserManager].password];
}

- (BOOL)iSFileDataInclude
{
    return YES;
}

@end
