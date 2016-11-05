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


@property(nonatomic, retain) NSString *articleName;
@property(nonatomic, retain) NSString *articleContent;
@property(nonatomic, retain) NSString *articleUuid;
@property(nonatomic, retain) NSString *articleTitle;
@property(nonatomic, retain) NSString *publishTime;
@property(nonatomic, retain) NSString *userUuid;
@property(nonatomic, retain) NSString *avatar;



@end
