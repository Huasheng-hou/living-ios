//
//  LMActicleCommentVO.h
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

@interface LMActicleCommentVO : NSObject

+ (LMActicleCommentVO *)LMActicleCommentVOWithJSONString:(NSString *)jsonString usingEncoding:(NSStringEncoding)stringEncoding error:(NSError **)error;
+ (LMActicleCommentVO *)LMActicleCommentVOWithDictionary:(NSDictionary *)dictionary;
+ (NSArray *)LMActicleCommentVOListWithArray:(NSArray *)array;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@property (nonatomic, retain) NSString *replyTime;
@property (nonatomic, assign) int praiseCount;
@property (nonatomic, retain) NSString *replyUuid;
@property (nonatomic, retain) NSString *userUuid;
@property (nonatomic, retain) NSString *commentTime;
@property (nonatomic, retain) NSString *commentUuid;
@property (nonatomic, retain) NSString *nickName;
@property (nonatomic, retain) NSString *type;
@property (nonatomic, retain) NSString *respondentNickname;
@property (nonatomic, retain) NSString *avatar;
@property (nonatomic, retain) NSString *address;
@property (nonatomic, assign) BOOL hasPraised;
@property (nonatomic, retain) NSString *commentContent;


@end
