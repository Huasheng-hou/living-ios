//
//  FitClientIDManager.m
//  FitTrainer
//
//  Created by Huasheng on 15/8/20.
//  Copyright (c) 2015年 Huasheng. All rights reserved.
//

#import "FitClientIDManager.h"
#import "FitUserManager.h"
#import "HTTPProxy.h"

#define ENCODE_KEY          @"Bomo_FitTrainer"

static FitClientIDManager *__sharedClientIDManager;
static NSString *const __kClientInfoFileName = @"B911B8BD8CCD76D1";

@interface FitClientIDManager (/* 私有方法 */)

- (NSString *)clientIDFileFullPath;
- (NSData *)simpleEncode:(NSString *)s;
- (NSString *)simpleDecode:(NSData *)s;

@end

@implementation FitClientIDManager

+ (FitClientIDManager *)sharedClientIDManager
{
    if (!__sharedClientIDManager) {
        __sharedClientIDManager = [[FitClientIDManager alloc] init];
    }
    
    return __sharedClientIDManager;
}

- (BOOL)hasClientID
{
    NSDictionary *info = [self clientInfo];
    
    if ([info objectForKey:@"cid"]) {
        return YES;
    }
    
    return NO;
}

- (BOOL)resignClientInfo
{
    NSMutableDictionary *clientInfoDict = [[NSMutableDictionary alloc] initWithDictionary:[self clientInfo]];
    [clientInfoDict removeObjectForKey:@"cid"];
    [self updateClientInfo:clientInfoDict];
    
    return YES;
}

#pragma mark - Save and Get Password
- (BOOL)saveClientID:(NSString *)clientID
{
    if (!clientID || [clientID isEqualToString:@""]) {
        return NO;
    }
    NSMutableDictionary *clientInfoDict = [[NSMutableDictionary alloc] initWithDictionary:[self clientInfo]];
    [clientInfoDict setObject:clientID forKey:@"cid"];
    [self updateClientInfo:clientInfoDict];
    
    [self syncClientIDWithServer];
    
    return YES;
}

- (NSString *)getClientID
{
    NSMutableDictionary *clientInfoDict = [[NSMutableDictionary alloc] initWithDictionary:[self clientInfo]];
    
    if ([clientInfoDict objectForKey:@"cid"] && [[clientInfoDict objectForKey:@"cid"] isKindOfClass:[NSString class]]) {
        NSString *cid = (NSString *)[clientInfoDict objectForKey:@"cid"];
        if (![cid isEqualToString:@""]) {
            return cid;
        }
    }
    
    return nil;
}

- (void)syncClientIDWithServer
{
    NSString    *clientID   = [self getClientID];
    
    if (!clientID || ![clientID isKindOfClass:[NSString class]] || [clientID isEqualToString:@""]) {
        return;
    }
}

#pragma mark - Save and Get User Info
- (NSDictionary *)clientInfo
{
    NSString *path = [self clientIDFileFullPath];
    NSFileManager *fm = [NSFileManager defaultManager];
    
    if ([fm fileExistsAtPath:path]) {
        NSDictionary *info = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
        if ([info.allKeys count] > 0) {
            return info;
        }
    }
    
    return nil;
}

- (BOOL)updateClientInfo:(NSDictionary *)clientInfo
{
    NSString *path = [self clientIDFileFullPath];
    
    return [NSKeyedArchiver archiveRootObject:clientInfo toFile:path];
}

- (NSString *)clientIDFileFullPath
{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *fullPath = [path stringByAppendingPathComponent:__kClientInfoFileName];
    
    return fullPath;
}

#pragma mark - Encode and Decode
- (NSData *)simpleEncode:(NSString *)s
{
    NSData *data = [s dataUsingEncoding:NSUTF8StringEncoding];
    
    char *dataPtr = (char *)[data bytes];
    char *keyData = (char *)[[ENCODE_KEY dataUsingEncoding:NSUTF8StringEncoding] bytes];
    char *keyPtr = keyData;
    int keyIndex = 0;
    
    for (int i = 0; i < [data length]; i++) {
        *dataPtr = *dataPtr ^ *keyPtr;
        dataPtr++;
        keyPtr++;
        
        if (++keyIndex == [ENCODE_KEY length]) {
            keyIndex = 0;
            keyPtr = keyData;
        }
    }
    
    return data;
}

- (NSString *)simpleDecode:(NSData *)s
{
    NSData *data = [NSData dataWithData:s];
    
    char *dataPtr = (char *)[data bytes];
    char *keyData = (char *)[[ENCODE_KEY dataUsingEncoding:NSUTF8StringEncoding] bytes];
    char *keyPtr = keyData;
    int keyIndex =0;
    
    for (int i = 0; i < [data length]; i++) {
        *dataPtr = *dataPtr ^ *keyPtr;
        dataPtr++;
        keyPtr++;
        
        if (++keyIndex == [ENCODE_KEY length]) {
            keyIndex = 0;
            keyPtr = keyData;
        }
    }
    
    NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return result;
}

@end
