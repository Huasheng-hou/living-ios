//
//  LMYGBDetailVO.h
//  living
//
//  Created by hxm on 2017/3/21.
//  Copyright © 2017年 chenle. All rights reserved.
//

#import <Foundation/Foundation.h>
#if ! __has_feature(objc_arc)
#define JSONAutoRelease(param) ([param autorelease]);
#else
#define JSONAutoRelease(param) (param)
#endif
@interface LMYGBDetailVO : NSObject


@property (nonatomic, copy) NSString * userUuid;
@property (nonatomic, copy) NSString * dateTime;
@property (nonatomic, strong) NSNumber * numbers;
@property (nonatomic, copy) NSString * title;
@property (nonatomic, copy) NSString * type;


+ (LMYGBDetailVO *)LMYGBDetailVOWithJSONString:(NSString *)jsonString usingEncoding:(NSStringEncoding)stringEncoding error:(NSError **)error;
+ (LMYGBDetailVO *)LMYGBDetailVOWithDictionary:(NSDictionary *)dictionary;
+ (NSArray *)LMYGBDetailVOWithArray:(NSArray *)array;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@end
