//
//  LMAuthorVO.h
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

@interface LMAuthorVO : NSObject

+ (LMAuthorVO *)LMAuthorVOWithJSONString:(NSString *)jsonString usingEncoding:(NSStringEncoding)stringEncoding error:(NSError **)error;
+ (LMAuthorVO *)LMAuthorVOWithDictionary:(NSDictionary *)dictionary;
+ (NSArray *)LMAuthorVOListWithArray:(NSArray *)array;

- (id)initWithDictionary:(NSDictionary *)dictionary;


@property (nonatomic, retain) NSString *articleContent;
@property (nonatomic, retain) NSString *nickname;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *publishTime;
@property (nonatomic, retain) NSString *cover;
@property (nonatomic, retain) NSString *authorUuid;
@property (nonatomic, retain) NSString *articleUuid;


@end
