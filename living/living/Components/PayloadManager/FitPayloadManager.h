
//
//  FitPayloadManager.h
//  FitTrainer
//
//  Created by Huasheng on 15/8/20.
//  Copyright (c) 2015年 Huasheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FitPayloadManager : NSObject

+ (void)processPayload:(NSString *)payload;
+ (void)processTransPayload:(NSString *)payload;

@end
