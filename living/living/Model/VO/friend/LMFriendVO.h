//
//  LMFriendVO.h
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

@interface LMFriendVO : NSObject

+ (LMFriendVO *)LMFriendVOWithJSONString:(NSString *)jsonString usingEncoding:(NSStringEncoding)stringEncoding error:(NSError **)error;
+ (LMFriendVO *)LMFriendVOWithDictionary:(NSDictionary *)dictionary;
+ (NSArray *)LMFriendVOListWithArray:(NSArray *)array;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@property (nonatomic, retain) NSString *avatar;
@property (nonatomic, retain) NSString *nickname;
@property (nonatomic, retain) NSString *myNickname;
@property (nonatomic, retain) NSString *userUuid;
@property (nonatomic, retain) NSString *address;
@property (nonatomic, retain) NSString *UserID;
@property (nonatomic, assign) int  userId;
@property (nonatomic, retain) NSString *content;
@property (nonatomic, retain) NSString *myContent;

@end
