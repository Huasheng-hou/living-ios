//
//  LMActicleVO.h
//  living
//
//  Created by Ding on 2016/11/5.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import <Foundation/Foundation.h>

#if ! __has_feature(objc_arc)
#define JSONAutoRelease(param) ([param autorelease]);
#else
#define JSONAutoRelease(param) (param)
#endif

@interface LMActicleVO : NSObject

+ (LMActicleVO *)LMActicleVOWithJSONString:(NSString *)jsonString usingEncoding:(NSStringEncoding)stringEncoding error:(NSError **)error;
+ (LMActicleVO *)LMActicleVOWithDictionary:(NSDictionary *)dictionary;
+ (NSArray *)LMActicleVOListWithArray:(NSArray *)array;

- (id)initWithDictionary:(NSDictionary *)dictionary;


@property(nonatomic, copy) NSString *articleName;
@property(nonatomic, copy) NSString *articleContent;
@property(nonatomic, copy) NSString *articleUuid;
@property(nonatomic, copy) NSString *articleTitle;
@property(nonatomic, copy) NSString *publishTime;
@property(nonatomic, copy) NSString *userUuid;
@property(nonatomic, copy) NSString *avatar;
@property(nonatomic, copy) NSString *type;
@property(nonatomic, copy) NSString *franchisee;
@property(nonatomic, copy) NSString *sign;
@property(nonatomic, copy) NSString *group;
@property(nonatomic, copy) NSString *category;



@end
