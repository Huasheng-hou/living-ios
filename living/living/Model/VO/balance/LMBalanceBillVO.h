//
//  LMBalanceBillVO.h
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

@interface LMBalanceBillVO : NSObject

+ (LMBalanceBillVO *)LMBalanceBillVOWithJSONString:(NSString *)jsonString usingEncoding:(NSStringEncoding)stringEncoding error:(NSError **)error;
+ (LMBalanceBillVO *)LMBalanceBillVOWithDictionary:(NSDictionary *)dictionary;
+ (NSArray *)LMBalanceBillVOListWithArray:(NSArray *)array;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@property (nonatomic, retain) NSString *recharges;
@property (nonatomic, retain) NSString *expenditure;
@property (nonatomic, retain) NSString *eventsBill;
@property (nonatomic, retain) NSString *rechargesBill;
@property (nonatomic, retain) NSString *refundsBill;

@end
