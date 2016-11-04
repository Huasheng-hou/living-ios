//
//  FirUploadImageRequest.m
//  firefly
//
//  Created by JamHonyZ on 16/1/20.
//  Copyright © 2016年 Huasheng. All rights reserved.
//

#import "FirUploadImageRequest.h"
#import "FitUserManager.h"

@implementation FirUploadImageRequest

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

- (NSString *)serverHost
{

//    return @"http://120.26.64.40:8080/living/";//内测地址
    
    return @"http://yaoguo1818.com/living/";//发布地址

}

- (BOOL)isPost
{
    return YES;
}

- (NSString *)methodPath
{
    return [NSString stringWithFormat:@"media/file_upload?user_uuid=%@&password=%@",[FitUserManager sharedUserManager].uuid,[FitUserManager sharedUserManager].password];
}

- (BOOL)isImageInclude
{
    return YES;
}

@end
