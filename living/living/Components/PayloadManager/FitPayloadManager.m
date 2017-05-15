//
//  FitPayloadManager.m
//  FitTrainer
//
//  Created by Huasheng on 15/8/20.
//  Copyright (c) 2015年 Huasheng. All rights reserved.
//

#import "FitPayloadManager.h"
#import "PayloadVO.h"
#import "FitNotificationNames.h"

@implementation FitPayloadManager
//推送
+ (void)processPayload:(NSString *)payload
{
    if (payload) {
        NSData *payloadData = [payload dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        NSDictionary *payloadDict = [NSJSONSerialization JSONObjectWithData:payloadData options:NSJSONReadingMutableLeaves error:nil];
        
        PayloadVO *payloadVO = [PayloadVO PayloadVOWithDictionary:payloadDict];
        if (payloadVO) {
        }
        
        if (payloadDict[@"push_title"]&&payloadDict[@"push_title"]!=[NSNull null]&&[payloadDict[@"push_title"] isKindOfClass:[NSString class]]) {
            

                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"getui_message"
                                                                    object:nil];

            
        }
    }
}
//透传
+ (void)processTransPayload:(NSString *)payload
{
    if (payload) {
        NSData *payloadData = [payload dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        NSDictionary *payloadDict = [NSJSONSerialization JSONObjectWithData:payloadData options:NSJSONReadingMutableLeaves error:nil];
        
        PayloadVO *payloadVO = [PayloadVO PayloadVOWithDictionary:payloadDict];
        if (payloadVO) {
         NSLog(@"收到----payloadDict----%@",payloadDict);
            if (payloadDict[@"push_title"]&&payloadDict[@"push_title"]!=[NSNull null]&&[payloadDict[@"push_title"] isKindOfClass:[NSString class]]) {
                if ([payloadVO.Type isEqualToString:@"7"]) {
                    
                    NSDictionary    *userInfo   = [NSDictionary dictionaryWithObjectsAndKeys:payloadDict, @"message", nil];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"message_notice" object:nil userInfo:userInfo];
                    
                    
                }else{
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"getui_message"
                                                                        object:nil
                                                                      userInfo:payloadDict];
                }

                }
                
           }
        
    }
}

@end
