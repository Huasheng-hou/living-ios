//
//  LMExpertSpaceVO.h
//  living
//
//  Created by hxm on 2017/3/16.
//  Copyright © 2017年 chenle. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LMMoreEventsVO.h"
#import "LMMoreArticlesVO.h"
#import "LMMoreVoicesVO.h"


#if ! __has_feature(objc_arc)
#define JSONAutoRelease(param) ([param autorelease]);
#else
#define JSONAutoRelease(param) (param)
#endif
@interface LMExpertSpaceVO : NSObject

+ (LMExpertSpaceVO *)LMExpertSapceVOWithJSONString:(NSString *)jsonString usingEncoding:(NSStringEncoding)stringEncoding error:(NSError **)error;
+ (LMExpertSpaceVO *)LMExpertSapceVOWithDictionary:(NSDictionary *)dictionary;
+ (NSArray *)LMExpertSapceVOListWithArray:(NSArray *)array;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@property (nonatomic, copy) NSString * nickName;
@property (nonatomic, copy) NSString * avatar;
@property (nonatomic, strong) NSString * images;
@property (nonatomic, copy) NSString * introduce;
@property (nonatomic, copy) NSString * gender;
@property (nonatomic, copy) NSString * userId;
@property (nonatomic, copy) NSString * province;
@property (nonatomic, copy) NSString * city;
@property (nonatomic, copy) NSString * franchisee;
@property (nonatomic, copy) NSString * sign;
@property (nonatomic, copy) NSString * userUuid;






@end
