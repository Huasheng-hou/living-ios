//
//  LMEventCommentVO.h
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

@interface LMEventCommentVO : NSObject

+ (LMEventCommentVO *)LMEventCommentVOWithJSONString:(NSString *)jsonString usingEncoding:(NSStringEncoding)stringEncoding error:(NSError **)error;
+ (LMEventCommentVO *)LMEventCommentVOWithDictionary:(NSDictionary *)dictionary;
+ (NSArray *)LMEventCommentVOListWithArray:(NSArray *)array;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@property (nonatomic, strong) NSString *commentContent;
@property (nonatomic, strong) NSString *replyTime;
@property (nonatomic, strong) NSString *replyUuid;
@property (nonatomic, strong) NSString *userUuid;
@property (nonatomic, strong) NSString *commentTime;
@property (nonatomic, strong) NSString *commentUuid;
@property (nonatomic, strong) NSString *nickName;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *respondentNickname;
@property (nonatomic, strong) NSString *avatar;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, assign) BOOL hasPraised;
@property (nonatomic, assign) int praiseCount;
@property (nonatomic, strong) NSString *replyContent;
@property (nonatomic, strong) NSArray * images;

@end
