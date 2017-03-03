//
//  LMOrderInfoVO.h
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

@interface LMOrderInfoVO : NSObject

+ (LMOrderInfoVO *)LMOrderInfoVOWithJSONString:(NSString *)jsonString usingEncoding:(NSStringEncoding)stringEncoding error:(NSError **)error;
+ (LMOrderInfoVO *)LMOrderInfoVOWithDictionary:(NSDictionary *)dictionary;
+ (NSArray *)LMOrderInfoVOListWithArray:(NSArray *)array;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@property (nonatomic, retain) NSString *endTime;
@property (nonatomic, retain) NSString *eventName;
@property (nonatomic, retain) NSString *totalMoney;
@property (nonatomic, retain) NSString *startTime;
@property (nonatomic, retain) NSString *eventAddress;
@property (nonatomic, retain) NSString *averagePrice;
@property (nonatomic, assign) int joinNumber;
@property (nonatomic, retain) NSString *orderNumber;
@property (nonatomic, retain) NSString *eventUuid;
@property (nonatomic, retain) NSString *orderUuid;
@property (nonatomic, retain) NSString *validatedPrice;
@property (nonatomic, retain) NSString *voiceTitle;
@property (nonatomic, retain) NSString *voiceUuid;

@end
