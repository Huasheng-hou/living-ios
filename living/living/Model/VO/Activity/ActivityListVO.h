
//
//  ActivityListVO.h
//  living
//
//  Created by JamHonyZ on 2016/11/6.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import <Foundation/Foundation.h>

#if ! __has_feature(objc_arc)
#define JSONAutoRelease(param) ([param autorelease]);
#else
#define JSONAutoRelease(param) (param)
#endif

@interface ActivityListVO : NSObject

+ (ActivityListVO *)ActivityListVOWithJSONString:(NSString *)jsonString usingEncoding:(NSStringEncoding)stringEncoding error:(NSError **)error;
+ (ActivityListVO *)ActivityListVOWithDictionary:(NSDictionary *)dictionary;
+ (NSArray *)ActivityListVOListWithArray:(NSArray *)array;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@property(nonatomic, copy) NSString         *userUuid;
@property(nonatomic, copy) NSString         *eventUuid;
@property(nonatomic, copy) NSString         *avatar;
@property(nonatomic, copy) NSString         *nickName;
@property(nonatomic, copy) NSString         *address;
@property(nonatomic, copy) NSString         *eventImg;
@property(nonatomic, copy) NSString         *eventName;
@property(nonatomic, strong) NSNumber       *currentNumber;
@property(nonatomic, copy) NSString         *startTime;
@property(nonatomic, copy) NSString         *perCost;
@property(nonatomic, copy) NSString         *discount;
@property(nonatomic, strong) NSNumber       *totalNumber;
@property(nonatomic, strong) NSNumber       *status;
@property (nonatomic, copy) NSString        * category;
@property (nonatomic, copy) NSString        * type;



@end
