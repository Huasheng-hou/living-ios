//
//  LMMemberVO.h
//  living
//
//  Created by Ding on 2016/11/12.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import <Foundation/Foundation.h>

#if ! __has_feature(objc_arc)
#define JSONAutoRelease(param) ([param autorelease]);
#else
#define JSONAutoRelease(param) (param)
#endif

@interface LMMemberVO : NSObject

+ (LMMemberVO *)LMMemberVOWithJSONString:(NSString *)jsonString usingEncoding:(NSStringEncoding)stringEncoding error:(NSError **)error;
+ (LMMemberVO *)LMMemberVOWithDictionary:(NSDictionary *)dictionary;
+ (NSArray *)LMMemberVOListWithArray:(NSArray *)array;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@property(nonatomic, retain) NSString       *userUuid;
@property(nonatomic, retain) NSString       *Avatar;
@property(nonatomic, retain) NSString       *nickName;
@property(nonatomic, retain) NSString       *eventName;
@property(nonatomic, assign) int       number;
@property(nonatomic, retain) NSString       *orderAmount;
@property(nonatomic, assign) int       userId;

@end
