//
//  LMOrderBodyVO.h
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

@interface LMOrderBodyVO : NSObject

+ (LMOrderBodyVO *)LMOrderBodyVOWithJSONString:(NSString *)jsonString usingEncoding:(NSStringEncoding)stringEncoding error:(NSError **)error;
+ (LMOrderBodyVO *)LMOrderBodyVOWithDictionary:(NSDictionary *)dictionary;
+ (NSArray *)LMOrderBodyVOListWithArray:(NSArray *)array;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@property (nonatomic, assign) int number;
@property (nonatomic, copy) NSString *eventName;
@property (nonatomic, copy) NSString *totalMoney;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *orderUuid;
@property (nonatomic, copy) NSString *eventUuid;
@property (nonatomic, copy) NSString *orderTime;
@property (nonatomic, copy) NSString *balance;
@property (nonatomic, assign) int coupons;
@property (nonatomic, copy) NSString *couponPrice;
@property (nonatomic, copy) NSString *couponMoney;
@property (nonatomic, copy) NSString *voiceTitle;
@property (nonatomic, copy) NSString *voiceUuid;
@property (nonatomic, copy) NSString * available;

@end
