//
//  LMEventBodyVO.h
//  living
//
//  Created by Ding on 2016/11/6.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import <Foundation/Foundation.h>


#if ! __has_feature(objc_arc)
#define JSONAutoRelease(param) ([param autorelease]);
#else
#define JSONAutoRelease(param) (param)
#endif

@interface LMEventBodyVO : NSObject

+ (LMEventBodyVO *)LMEventBodyVOWithJSONString:(NSString *)jsonString usingEncoding:(NSStringEncoding)stringEncoding error:(NSError **)error;
+ (LMEventBodyVO *)LMEventBodyVOWithDictionary:(NSDictionary *)dictionary;
+ (NSArray *)LMEventBodyVOListWithArray:(NSArray *)array;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@property (nonatomic, strong) NSString *publishName;
@property (nonatomic, strong) NSString *discount;
@property (nonatomic, strong) NSString *contactName;
@property (nonatomic, assign) int totalNum;             // * 总人数
@property (nonatomic, strong) NSString *userUuid;
@property (nonatomic, strong) NSString *eventName;
@property (nonatomic, strong) NSString *contactPhone;
@property (nonatomic, strong) NSDate *startTime;
@property (nonatomic, strong) NSString *eventImg;
@property (nonatomic, assign) int totalNumber;          // * 当前参加人数
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *eventUuid;
@property (nonatomic, strong) NSDate *endTime;
@property (nonatomic, strong) NSString *perCost;
@property (nonatomic, strong) NSString *publishAvatar;
@property (nonatomic, assign) int status;
@property (nonatomic, strong) NSString *longitude;
@property (nonatomic, strong) NSString *latitude;
@property (nonatomic, strong) NSString *livingUuid;
@property (nonatomic, strong) NSString *notices;
@property (nonatomic, assign) int eventid;
@property (nonatomic, assign) BOOL isBuy;

@end
