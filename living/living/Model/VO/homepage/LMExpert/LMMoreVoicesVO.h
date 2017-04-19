//
//  LMMoreVoicesVO.h
//  living
//
//  Created by hxm on 2017/3/14.
//  Copyright © 2017年 chenle. All rights reserved.
//

#import <Foundation/Foundation.h>
#if ! __has_feature(objc_arc)
#define JSONAutoRelease(param) ([param autorelease]);
#else
#define JSONAutoRelease(param) (param)
#endif

@interface LMMoreVoicesVO : NSObject
+ (LMMoreVoicesVO *)LMMoreVoicesVOWithJSONString:(NSString *)jsonString usingEncoding:(NSStringEncoding)stringEncoding error:(NSError **)error;
+ (LMMoreVoicesVO *)LMMoreVoicesVOWithDictionary:(NSDictionary *)dictionary;
+ (NSArray *)LMMoreVoicesVOWithArray:(NSArray *)array;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@property (nonatomic, copy) NSString * userUuid;
@property (nonatomic, copy) NSString * voiceUuid;
@property (nonatomic, copy) NSString * avatar;
@property (nonatomic, copy) NSString * nickName;
@property (nonatomic, copy) NSString * image;
@property (nonatomic, copy) NSString * voiceTitle;

@property (nonatomic, assign) NSInteger  currentNum;
@property (nonatomic, copy) NSString * startTime;
@property (nonatomic, copy) NSString * perCost;
@property (nonatomic, copy) NSString * discount;
@property (nonatomic, assign) NSInteger  totalNum;
@property (nonatomic, copy) NSString * status;
@property (nonatomic, copy) NSString * category;
@property (nonatomic, copy) NSString * hoster;

@end
