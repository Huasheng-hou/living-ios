//
//  LMQuestionVO.h
//  living
//
//  Created by Ding on 2016/12/19.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import <Foundation/Foundation.h>
#if ! __has_feature(objc_arc)
#define JSONAutoRelease(param) ([param autorelease]);
#else
#define JSONAutoRelease(param) (param)
#endif

@interface LMQuestionVO : NSObject

+ (LMQuestionVO *)LMQuestionVOWithJSONString:(NSString *)jsonString usingEncoding:(NSStringEncoding)stringEncoding error:(NSError **)error;
+ (LMQuestionVO *)LMQuestionVOWithDictionary:(NSDictionary *)dictionary;
+ (NSArray *)LMQuestionVOListWithArray:(NSArray *)array;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSDate *time;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *question_uuid;
@property (nonatomic, strong) NSString *avatar;
@property (nonatomic, strong) NSString *userUuid;


@end
