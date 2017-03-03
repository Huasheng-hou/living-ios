//
//  LMArticleBodyVO.h
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

@interface LMArticleBodyVO : NSObject

+ (LMArticleBodyVO *)LMArticleBodyVOWithJSONString:(NSString *)jsonString usingEncoding:(NSStringEncoding)stringEncoding error:(NSError **)error;
+ (LMArticleBodyVO *)LMArticleBodyVOWithDictionary:(NSDictionary *)dictionary;
+ (NSArray *)LMArticleBodyVOListWithArray:(NSArray *)array;

- (id)initWithDictionary:(NSDictionary *)dictionary;


@property (nonatomic, assign) int articlePraiseNum;
@property (nonatomic, retain) NSString *avatar;
@property (nonatomic, retain) NSString *articleTitle;
@property (nonatomic, retain) NSString *articleContent;
@property (nonatomic, retain) NSString *describe;
@property (nonatomic, assign) BOOL hasPraised;
@property (nonatomic, retain) NSDate *publishTime;
@property (nonatomic, assign) int commentNum;
@property (nonatomic, assign) int fakaid;
@property (nonatomic, retain) NSString *articleName;
@property (nonatomic, retain) NSString *userUuid;
@property (nonatomic, retain) NSString *articleUuid;
@property (nonatomic, retain) NSArray *articleImgs;
@property (nonatomic, retain) NSString *type;


@end
