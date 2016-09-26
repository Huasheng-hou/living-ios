//
//  VOUtil.h
//  FitTrainer
//
//  Created by Huasheng on 15/8/20.
//  Copyright (c) 2015年 Huasheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VOReflactable.h"

@interface VOUtil : NSObject

+ (NSDictionary*)parseBody:(NSString*)resp;
+ (BOOL)parseBizCode:(NSDictionary*)body AcceptCodes:(NSArray*)codes;
+ (NSString*)parseDescription:(NSDictionary*)body;
+ (NSArray*)listOf:(Class<VOReflactable>)clazz FromDictArray:(NSArray*)dictArray;

@end
