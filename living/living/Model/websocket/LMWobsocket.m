//
//  LMWobsocket.m
//  living
//
//  Created by Ding on 2017/1/7.
//  Copyright © 2017年 chenle. All rights reserved.
//

#import "LMWobsocket.h"

static STOMPClient *client;

@implementation LMWobsocket

+ (STOMPClient *)shareWebsocket
{
    
//    NSURL *websocketUrl = [NSURL URLWithString:@"ws://websocket.yaoguo1818.com/live-connect/websocket"];  //正式
    NSURL *websocketUrl = [NSURL URLWithString:@"ws://116.62.37.248/live-connect/websocket"];   //测试
    
    if (!client) {
    
        client=[[STOMPClient alloc]initWithURL:websocketUrl webSocketHeaders:nil useHeartbeat:NO];
    }
    return client;
}

@end
