//
//  LMEventListVO.h
//  living
//
//  Created by hxm on 2017/3/13.
//  Copyright © 2017年 chenle. All rights reserved.
//

#import <Foundation/Foundation.h>
#if ! __has_feature(objc_arc)
#define JSONAutoRelease(param) ([param autorelease]);
#else
#define JSONAutoRelease(param) (param)
#endif
@interface LMEventListVO : NSObject

+ (LMEventListVO *)EventListVOWithJSONString:(NSString *)jsonString usingEncoding:(NSStringEncoding)stringEncoding error:(NSError **)error;
+ (LMEventListVO *)EventListVOWithDictionary:(NSDictionary *)dictionary;
+ (NSArray *)EventListVOListWithArray:(NSArray *)array;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@property (nonatomic, copy) NSString * userUuid;
@property (nonatomic, copy) NSString * eventUuid;
@property (nonatomic, copy) NSString * avatar;
@property (nonatomic, copy) NSString * nickName;
@property (nonatomic, copy) NSString * address;
@property (nonatomic, copy) NSString * eventImg;
@property (nonatomic, copy) NSString * eventName;
@property (nonatomic, strong) NSNumber * currentNum;
@property (nonatomic, copy) NSString * perCost;
@property (nonatomic, copy) NSString * discount;
@property (nonatomic, strong) NSNumber * totalNum;
@property (nonatomic, strong) NSNumber * status;
@property (nonatomic, copy) NSString * category;
@property (nonatomic, copy) NSString * type;



@end
