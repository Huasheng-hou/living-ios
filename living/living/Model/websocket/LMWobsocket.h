//
//  LMWobsocket.h
//  living
//
//  Created by Ding on 2017/1/7.
//  Copyright © 2017年 chenle. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WebsocketStompKit.h"

@interface LMWobsocket : NSObject


+(STOMPClient *)shareWebsocket;

@end
