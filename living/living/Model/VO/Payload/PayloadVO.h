
//
//  PayloadVO.h
//  FitTrainer
//
//  Created by Huasheng on 15/8/20.
//  Copyright (c) 2015年 Huasheng. All rights reserved.
//

#import <Foundation/Foundation.h>

#if ! __has_feature(objc_arc)
#define JSONAutoRelease(param) ([param autorelease]);
#else
#define JSONAutoRelease(param) (param)
#endif

#define kPayloadTypeMsg     @"msg"
#define kPayloadTypeBoard   @"board"
#define kPayloadTypeCoachInform  @"coach"

@interface PayloadVO : NSObject

+ (PayloadVO *)PayloadVOWithJSONString:(NSString *)jsonString usingEncoding:(NSStringEncoding)stringEncoding error:(NSError **)error;
+ (PayloadVO *)PayloadVOWithDictionary:(NSDictionary *)dictionary;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@property(nonatomic, assign) NSString       *Type;
@property(nonatomic, retain) NSDictionary   *Detail;

@end
