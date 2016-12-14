//
//  LMVoiceDetailVO.h
//  living
//
//  Created by Ding on 2016/12/13.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import <Foundation/Foundation.h>

#if ! __has_feature(objc_arc)
#define JSONAutoRelease(param) ([param autorelease]);
#else
#define JSONAutoRelease(param) (param)
#endif

@interface LMVoiceDetailVO : NSObject

+ (LMVoiceDetailVO *)LMVoiceDetailVOWithJSONString:(NSString *)jsonString usingEncoding:(NSStringEncoding)stringEncoding error:(NSError **)error;
+ (LMVoiceDetailVO *)LMVoiceDetailVOWithDictionary:(NSDictionary *)dictionary;
+ (NSArray *)LMVoiceDetailVOListWithArray:(NSArray *)array;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@property(nonatomic, retain) NSString       *voiceUuid;

@property(nonatomic, retain) NSString       *userUuid;

@property(nonatomic, retain) NSString       *image;

@property(nonatomic, retain) NSString       *voiceTitle;

@property(nonatomic, retain) NSString       *publishName;

@property(nonatomic, retain) NSNumber       *number;

@property(nonatomic, retain) NSString       *contactPhone;

@property(nonatomic, retain) NSString       *contactName;

@property(nonatomic, retain) NSString       *perCost;

@property(nonatomic, retain) NSString       *discount;

@property(nonatomic, retain) NSDate         *startTime;

@property(nonatomic, retain) NSDate         *endTime;

@property(nonatomic, retain) NSNumber       *limitNum;

@property(nonatomic, retain) NSString       *avatar;

@property(nonatomic, retain) NSString       *name;

@property(nonatomic, retain) NSString       *status;

@property(nonatomic, retain) NSString       *livingUuid;


@end

