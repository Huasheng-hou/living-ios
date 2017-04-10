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


//活动回顾
@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) NSString * reviewUuid;
@property (nonatomic, copy) NSString * content;
@property (nonatomic, copy) NSString * title;
@property (nonatomic, strong) NSArray * imgs;
@property (nonatomic, assign) int praiseNum;

//课程
@property (nonatomic, copy) NSString * voiceUuid;
@property (nonatomic, copy) NSString * image;
@property (nonatomic, copy) NSString * voiceTitle;
@property (nonatomic, copy) NSString * publishName;
@property (nonatomic, assign) NSInteger  number;
@property (nonatomic, copy) NSString * contactPhone;
@property (nonatomic, copy) NSString * contactName;
@property (nonatomic, copy) NSString * perCost;
@property (nonatomic, copy) NSString * discount;
@property (nonatomic, copy) NSString * startTime;
@property (nonatomic, copy) NSString * endTime;
@property (nonatomic, assign) NSInteger limitNum;
@property (nonatomic, copy) NSString * notices;
@property (nonatomic, assign) BOOL isBuy;
@property (nonatomic, assign) BOOL isReport;
@property (nonatomic, copy) NSString * status;
@property (nonatomic, copy) NSString * livingUuid;
@property (nonatomic, assign) NSInteger totalNumber;
@property (nonatomic, strong) NSArray * list;
@property (nonatomic, copy) NSString * available;


@end
