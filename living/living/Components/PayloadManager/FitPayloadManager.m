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
        
        if (payloadDict[@"push_title"]&&payloadDict[@"push_title"]!=[NSNull null]&&[payloadDict[@"push_title"] isKindOfClass:[NSString class]]) {
            

                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"getui_message"
                                                                    object:nil];

            
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
            if (payloadDict[@"push_title"]&&payloadDict[@"push_title"]!=[NSNull null]&&[payloadDict[@"push_title"] isKindOfClass:[NSString class]]) {
                

                    [[NSNotificationCenter defaultCenter] postNotificationName:@"getui_message"
                                      object:nil];
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

@end
