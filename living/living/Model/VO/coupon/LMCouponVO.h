//
//  LMCouponVO.h
//  living
//
//  Created by Ding on 2016/11/8.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import <Foundation/Foundation.h>

#if ! __has_feature(objc_arc)
#define JSONAutoRelease(param) ([param autorelease]);
#else
#define JSONAutoRelease(param) (param)
#endif

@interface LMCouponVO : NSObject

+ (LMCouponVO *)LMCouponVOWithJSONString:(NSString *)jsonString usingEncoding:(NSStringEncoding)stringEncoding error:(NSError **)error;
+ (LMCouponVO *)LMCouponVOWithDictionary:(NSDictionary *)dictionary;
+ (NSArray *)LMCouponVOListWithArray:(NSArray *)array;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@property (nonatomic, retain) NSString *amount;
@property (nonatomic, retain) NSString *userUuid;
@property (nonatomic, retain) NSString *livingUuid;
@property (nonatomic, retain) NSString *livingName;
@property (nonatomic, retain) NSString *eventName;
@property (nonatomic, retain) NSString *couponUuid;
@property (nonatomic, retain) NSString *createTime;

@end
