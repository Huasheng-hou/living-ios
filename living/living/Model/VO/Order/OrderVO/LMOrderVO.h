//
//  LMOrderVO.h
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

@interface LMOrderVO : NSObject

+ (LMOrderVO *)LMOrderVOWithJSONString:(NSString *)jsonString usingEncoding:(NSStringEncoding)stringEncoding error:(NSError **)error;
+ (LMOrderVO *)LMOrderVOWithDictionary:(NSDictionary *)dictionary;
+ (NSArray *)LMOrderVOListWithArray:(NSArray *)array;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@property (nonatomic, retain) NSString *avatar;
@property (nonatomic, retain) NSString *orderStatus;
@property (nonatomic, retain) NSString *eventName;
@property (nonatomic, retain) NSString *eventUuid;
@property (nonatomic, retain) NSString *orderAmount;
@property (nonatomic, retain) NSString *userUuid;
@property (nonatomic, retain) NSString *payStatus;
@property (nonatomic, retain) NSString *orderUuid;
@property (nonatomic, retain) NSString *orderNumber;
@property (nonatomic, retain) NSString *orderingTime;
@property (nonatomic, retain) NSString *eventImg;
@property (nonatomic, assign) int number;
@property (nonatomic, assign) BOOL hasCoupon;
@property (nonatomic, retain) NSString *couponMoney;
@property (nonatomic, retain) NSString *discountMoney;
@property (nonatomic, assign) int status;
@property (nonatomic, retain) NSString *voiceStatus;
@property (nonatomic, retain) NSString *type;
@property (nonatomic, retain) NSString *voiceTitle;
@property (nonatomic, retain) NSString *voiceUuid;
@property (nonatomic, retain) NSString *voiceImages;

@end
