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

- (id)initWithNone
{
    NSMutableDictionary *bodyParams = [NSMutableDictionary dictionaryWithCapacity:0];
    NSMutableDictionary *paramsDict = [self params];
    [paramsDict setObject:bodyParams forKey:@"body"];
    
    return self;
}

- (NSString *)serverHost
{
    //测试
    
    return @"http://120.26.77.84:8080/dirty/";
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

- (BOOL)isPost
{
    return NO;
}

-(BOOL)isLogin
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
        
        afRequest   = [httpClient requestWithMethod:@"POST"
                                               path:[self methodPath]
                                         parameters:[NSDictionary dictionaryWithObject:[[NSString alloc] initWithData:[self toJSONData:[self query]]
                                                                                                             encoding:NSUTF8StringEncoding]
                                                                                forKey:@"json_package"]];
        
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
