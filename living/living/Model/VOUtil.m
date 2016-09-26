//
//  VOUtil.m
//  FitTrainer
//
//  Created by Huasheng on 15/8/20.
//  Copyright (c) 2015年 Huasheng. All rights reserved.
//

#import "VOUtil.h"
#import "HeadVO.h"
#import "FitNotificationNames.h"

#define RESP_HEAD   @"head"
#define RESP_BODY   @"body"
#define RESP_RESULT @"result"
#define RESP_DESC   @"description"
#define RESP_ERROR  @"网络错误"

@implementation VOUtil

+ (NSDictionary*)parseBody:(NSString*)resp
{
    if (!resp || ![resp isKindOfClass:[NSString class]]) {
        return nil;
    }
    
    NSData *respData = [resp dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSDictionary *respDict = [NSJSONSerialization
                              JSONObjectWithData:respData
                              options:NSJSONReadingMutableLeaves
                              error:nil];
    if (!respData || !respDict) {
        return nil;
    }
    
    id headJson = [respDict objectForKey:RESP_HEAD];
    if (headJson && ![headJson isEqual:[NSNull null]] && [headJson isKindOfClass:[NSDictionary class]]) {
        HeadVO *headVO = [HeadVO HeadVOWithDictionary:headJson];
        
        if (headVO.SysCode == kSysCodeNormal && headVO.UserCode == kUserCodeNormal && headVO.ResCode == kResCodeNormal) {
            id bodyJson = [respDict objectForKey:RESP_BODY];
            if ( bodyJson && ![bodyJson isEqual:[NSNull null]] && [bodyJson isKindOfClass:[NSDictionary class]]) {
                return bodyJson;
            }
        } else if (headVO.UserCode == kUserCodeReplaced) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:FIT_USER_BEING_REPLACED_NOTIFICATION object:nil];
        }
    }
    
    return nil;
}

+ (BOOL)parseBizCode:(NSDictionary*)body AcceptCodes:(NSArray*)codes
{
    for (int i = 0; i < codes.count; i ++) {
        
        if ([codes objectAtIndex:i] && [[codes objectAtIndex:i] isKindOfClass:[NSString class]]) {
            
            NSString    *code   = [codes objectAtIndex:i];
            
            if ([[body objectForKey:RESP_RESULT] isKindOfClass:[NSString class]]) {
                
                if ([[body objectForKey:RESP_RESULT] isEqualToString:code]) {
                    return YES;
                }
            }
        }
    }

    return NO;
}

+ (NSString*)parseDescription:(NSDictionary*)body
{
    return body ? [body objectForKey:RESP_DESC] : RESP_ERROR;
}

+ (NSArray*)listOf:(Class<VOReflactable>)clazz FromDictArray:(NSArray*)dictArray
{
    if (![dictArray isKindOfClass:[NSArray class]]) {
        return nil;
    }
    NSMutableArray *resultsArray = [[NSMutableArray alloc] init];
    for (id entry in dictArray) {
        if ([entry isKindOfClass:[NSDictionary class]]) {
            [resultsArray addObject:[clazz objFromDictionary:entry]];
        }
    }
    return resultsArray;
}

@end
