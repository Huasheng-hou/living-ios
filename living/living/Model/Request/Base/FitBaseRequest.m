//
//  FitBaseRequest.m
//  FitTrainer
//
//  Created by Huasheng on 15/8/21.
//  Copyright (c) 2015年 Huasheng. All rights reserved.
//

#import "FitBaseRequest.h"
#import "FitUserManager.h"
#import "FitClientIDManager.h"
#import <AFNetworking/AFNetworking.h>

@interface FitBaseRequest ()

- (NSData *)toJSONData:(id)theData;

@end

@implementation FitBaseRequest

@synthesize params          =       _params;
@synthesize imageData       =       _imageData;
@synthesize imageName       =       _imageName;
@synthesize fileData        =       _fileData;
@synthesize videoData       =       _videoData;

- (id)initWithNone
{
    NSMutableDictionary *bodyParams = [NSMutableDictionary dictionaryWithCapacity:0];
    NSMutableDictionary *paramsDict = [self params];
    [paramsDict setObject:bodyParams forKey:@"body"];
    
    return self;
}

- (NSString *)serverHost
{
//    return @"http://yaoguo1818.com/living/";
    return @"http://120.26.64.40:8080/living/";
}

- (NSString *)methodPath
{
    return nil;
}

- (NSDictionary *)query
{
    NSMutableDictionary *headParams = [NSMutableDictionary new];
    
    if ([[FitUserManager sharedUserManager] isLogin]) {
        NSString *user_uuid          = [[FitUserManager sharedUserManager] uuid];
        NSString *password      = [[FitUserManager sharedUserManager] password];
        
        if (user_uuid) {
            [headParams setObject:user_uuid forKey:@"user_uuid"];
        }
        
        if (password) {
            [headParams setObject:password forKey:@"password"];
        }
    }
    
    if ([[FitClientIDManager sharedClientIDManager] hasClientID]) {
        NSString *cid = [[FitClientIDManager sharedClientIDManager] getClientID];
        
        if (cid && ![cid isEqualToString:@""]) {
            [headParams setObject:cid forKey:@"cid"];
        }
    }
    
    NSString    *fitVersion     = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString*)kCFBundleVersionKey];
    [headParams setObject:fitVersion forKey:@"app_version"];
    
    [headParams setObject:@"IOS" forKey:@"app_os"];
    
    NSUserDefaults  *Defaults   = [NSUserDefaults standardUserDefaults];
    
    if ([Defaults objectForKey:@"deviceToken"]) {
        
        [headParams setObject:[Defaults objectForKey:@"deviceToken"] forKey:@"devicetoken"];
    }
    
    NSMutableDictionary *paramsDict = [self params];
    [paramsDict setObject:headParams forKey:@"head"];
    
    return _params;
}

- (BOOL)isPrivate
{
    return YES;
}

- (BOOL)isImageInclude
{
    return NO;
}

- (BOOL)isVoiceInclude
{
    return NO;
}

- (BOOL)iSFileDataInclude;
{
    return NO;
}


- (BOOL)isPost
{
    return NO;
}

- (BOOL)isLogin
{
    return YES;
}

- (NSMutableDictionary *)params
{
    if (nil == _params) {
        _params = [NSMutableDictionary dictionaryWithCapacity:2];
    }
    return _params;
}

- (NSURLRequest *)req
{
    NSURL *url = [NSURL URLWithString:[self serverHost]];
    
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    httpClient.parameterEncoding    = AFFormURLParameterEncoding;
    
    NSMutableURLRequest *afRequest;
    
    if ([self isPost]) {
        
        if (![self isImageInclude]&&![self isVoiceInclude]) {
            
            afRequest   = [httpClient requestWithMethod:@"POST"
                                                   path:[self methodPath]
                                             parameters:[NSDictionary dictionaryWithObject:[[NSString alloc] initWithData:[self toJSONData:[self query]]
                                                                                                                 encoding:NSUTF8StringEncoding]
                                                                                    forKey:@"json_package"]];
            
        }else if([self isImageInclude]){
            
            afRequest = [httpClient multipartFormRequestWithMethod:@"POST"
                                                              path:[self methodPath]
                                                        parameters:nil
                                         constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                                             
                                             [formData appendPartWithFormData:[self toJSONData:[self query]]
                                                                         name:@"json_package"];
                                             
                                             if ([self isImageInclude] && _imageData) {
                                                 [formData appendPartWithFileData:_imageData
                                                                             name:_imageName
                                                                         fileName:[NSString stringWithFormat:@"%@.jpg", _imageName]
                                                                         mimeType:@"image/jpeg"];
                                             }
                                             
                                         }];
            
        }else if([self isVoiceInclude]){
            
            afRequest = [httpClient multipartFormRequestWithMethod:@"POST"
                                                              path:[self methodPath]
                                                        parameters:nil
                                         constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                                             
                                             [formData appendPartWithFormData:[self toJSONData:[self query]]
                                                                         name:@"json_package"];
                                             
                                             if ([self isVoiceInclude] && _fileData) {
                                                 [formData appendPartWithFileData:_fileData
                                                                             name:_imageName
                                                                         fileName:[NSString stringWithFormat:@"%@.wav", @"filename"]
                                                                         mimeType:@"application/octet-stream"];
                                             }
                                             
                                         }];
        }else if ([self iSFileDataInclude]){
            
                afRequest = [httpClient multipartFormRequestWithMethod:@"POST"
                                                                  path:[self methodPath]
                                                            parameters:nil
                                             constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                                                 
                                                 [formData appendPartWithFormData:[self toJSONData:[self query]]
                                                                             name:@"json_package"];
                                                 
                                                 if ([self iSFileDataInclude] && _videoData) {
                                                     [formData appendPartWithFileData:_videoData
                                                                                 name:_imageName
                                                                             fileName:[NSString stringWithFormat:@"%@.mp4", @"filename"]
                                                                             mimeType:@"video/quicktime"];
                                                 }
                                                 
                                             }];
            

        }
        
        
        
    } else {
        
        afRequest = [httpClient requestWithMethod:@"GET"
                                             path:[self methodPath]
                                       parameters:nil];
    }
    
    return afRequest;
}


- (NSData *)toJSONData:(id)theData
{
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:theData
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    
    if ([jsonData length] > 0 && error == nil) {
        return jsonData;
    } else {
        return nil;
    }
}

@end
