
//
//  FitClientIDManager.h
//  FitTrainer
//
//  Created by Huasheng on 15/8/20.
//  Copyright (c) 2015年 Huasheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FitClientIDManager : NSObject

+ (FitClientIDManager *)sharedClientIDManager;

- (BOOL)hasClientID;
- (BOOL)resignClientInfo;

- (BOOL)saveClientID:(NSString *)clientID;
- (NSString *)getClientID;

- (NSDictionary *)clientInfo;
- (BOOL)updateClientInfo:(NSDictionary *)clientInfo;

- (void)syncClientIDWithServer;

@end
