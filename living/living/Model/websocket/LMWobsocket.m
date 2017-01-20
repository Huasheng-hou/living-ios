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
    NSURL *websocketUrl = [NSURL URLWithString:@"ws://121.43.40.58/live-connect/websocket"];
    
    if (!client) {
    
        client=[[STOMPClient alloc]initWithURL:websocketUrl webSocketHeaders:nil useHeartbeat:NO];
    }
    return client;
}

@end
