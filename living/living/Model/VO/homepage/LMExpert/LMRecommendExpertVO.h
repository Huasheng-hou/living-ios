//
//  LMRecommendExpertVO.h
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

@interface LMRecommendExpertVO : NSObject
+ (LMRecommendExpertVO *)LMRecommendExpertVOWithJSONString:(NSString *)jsonString usingEncoding:(NSStringEncoding)stringEncoding error:(NSError **)error;
+ (LMRecommendExpertVO *)LMRecommendExpertVOWithDictionary:(NSDictionary *)dictionary;
+ (NSArray *)LMRecommendExpertVOListWithArray:(NSArray *)array;

- (id)initWithDictionary:(NSDictionary *)dictionary;


@property (nonatomic, copy)NSString * userUuid;
@property (nonatomic, copy)NSString * nickName;
@property (nonatomic, copy)NSString * avatar;
@property (nonatomic, assign)NSInteger userId;
@property (nonatomic, copy)NSString * address;

@end
