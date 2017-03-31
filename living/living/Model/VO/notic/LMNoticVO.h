//
//  LMNoticVO.h
//  living
//
//  Created by Ding on 2016/11/6.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import <Foundation/Foundation.h>

#if ! __has_feature(objc_arc)
#define JSONAutoRelease(param) ([param autorelease]);
#else
#define JSONAutoRelease(param) (param)
#endif

@interface LMNoticVO : NSObject

+ (LMNoticVO *)LMNoticVOWithJSONString:(NSString *)jsonString usingEncoding:(NSStringEncoding)stringEncoding error:(NSError **)error;
+ (LMNoticVO *)LMNoticVOWithDictionary:(NSDictionary *)dictionary;
+ (NSArray *)LMNoticVOListWithArray:(NSArray *)array;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@property (nonatomic, retain) NSString *commentUuid;
@property (nonatomic, retain) NSString *content;
@property (nonatomic, retain) NSString *articleUuid;
@property (nonatomic, retain) NSString *userNick;
@property (nonatomic, retain) NSDate *noticeTime;
@property (nonatomic, retain) NSString *userUuid;
@property (nonatomic, retain) NSString *type;
@property (nonatomic, retain) NSString *eventUuid;
@property (nonatomic, retain) NSString *noticeUuid;
@property (nonatomic, retain) NSString *articleTitle;
@property (nonatomic, retain) NSString *eventName;
@property (nonatomic, retain) NSString *sign;
@property (nonatomic, retain) NSString *voiceUuid;
@property (nonatomic, retain) NSString *voiceTitle;

@property (nonatomic, copy) NSString * reviewUuid;
@property (nonatomic, copy) NSString * reviewTitle;




@end
