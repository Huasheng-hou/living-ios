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

+ (void)processPayload:(NSString *)payload
{
    if (payload) {
        NSData *payloadData = [payload dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        NSDictionary *payloadDict = [NSJSONSerialization JSONObjectWithData:payloadData options:NSJSONReadingMutableLeaves error:nil];
        
        PayloadVO *payloadVO = [PayloadVO PayloadVOWithDictionary:payloadDict];
        if (payloadVO) {
        }
        
        if (payloadDict[@"push_type"]&&payloadDict[@"push_type"]!=[NSNull null]&&[payloadDict[@"push_type"] isKindOfClass:[NSString class]]) {
            
            if ([payloadDict[@"push_type"] isEqualToString:@"1"]) {//公告
                NSLog(@"收到公告");
                [[NSNotificationCenter defaultCenter] postNotificationName:@"getui_announcement"
                                                                    object:nil];
            }
            if ([payloadDict[@"push_type"] isEqualToString:@"0"]) {//通知
                NSLog(@"收到通知");
                [[NSNotificationCenter defaultCenter]postNotificationName:@"getui_notice"
                                                                   object:nil];
            }
            
        }
    }
}

+ (void)processTransPayload:(NSString *)payload
{
    if (payload) {
        NSData *payloadData = [payload dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        NSDictionary *payloadDict = [NSJSONSerialization JSONObjectWithData:payloadData options:NSJSONReadingMutableLeaves error:nil];
        
//        PayloadVO *payloadVO = [PayloadVO PayloadVOWithDictionary:payloadDict];
//        if (payloadVO) {
         NSLog(@"收到----payloadDict----%@",payloadDict);
            if (payloadDict[@"push_type"]&&payloadDict[@"push_type"]!=[NSNull null]&&[payloadDict[@"push_type"] isKindOfClass:[NSString class]]) {
                
                if ([payloadDict[@"push_type"] isEqualToString:@"1"]) {//公告
                    
                    NSLog(@"收到公告");
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"getui_announcement"
                                      object:nil];
                }
                if ([payloadDict[@"push_type"] isEqualToString:@"0"]) {//通知
                    NSLog(@"收到通知");
                     [[NSNotificationCenter defaultCenter]postNotificationName:@"getui_notice"
                                                                        object:nil];
                }
                
                if ([payloadDict[@"push_type"] isEqualToString:@"2"]) {//审批通知
                    NSLog(@"审批通知");
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"getui" object:nil userInfo:payloadDict];
                }
                
//           }

//            if ([payloadVO.Type isEqualToString:kPayloadTypeMsg]) {
            
//                Message *message    = [FitMessageManager getMessageFromDictionary:payloadVO.Detail];
//                if (!message) {
//                    return;
//                }
//                
//                NSDictionary    *userInfo   = [NSDictionary dictionaryWithObjectsAndKeys:message, @"message", nil];
//                [[NSNotificationCenter defaultCenter] postNotificationName:FIT_TRANS_RECEIVE_MESSAGE_NOTIFICATION object:nil userInfo:userInfo];
                
//                
//            }
//            
//            if ([payloadVO.Type isEqualToString:kPayloadTypeBoard]) {
//                
//                [[NSNotificationCenter defaultCenter] postNotificationName:FIT_TRANS_RECEIVE_BOARD_NOTIFICATION object:nil];
//            }
//            if ([payloadVO.Type isEqualToString:kPayloadTypeCoachInform]) {
//                [[NSNotificationCenter defaultCenter] postNotificationName:FIT_CoachInform_NOTIFICATION object:nil];
//            }
        }
    }
}

@end
