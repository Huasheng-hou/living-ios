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
@property (nonatomic, retain) NSString *eventName;
@property (nonatomic, retain) NSString *totalMoney;
@property (nonatomic, retain) NSString *price;
@property (nonatomic, retain) NSString *orderUuid;
@property (nonatomic, retain) NSString *eventUuid;
@property (nonatomic, retain) NSString *orderTime;
@property (nonatomic, retain) NSString *balance;
@property (nonatomic, assign) int coupons;
@property (nonatomic, retain) NSString *couponPrice;
@property (nonatomic, retain) NSString *couponMoney;
@property (nonatomic, retain) NSString *voiceTitle;
@property (nonatomic, retain) NSString *voiceUuid;


@end
