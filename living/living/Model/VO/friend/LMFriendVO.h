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

@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *myNickname;
@property (nonatomic, copy) NSString *userUuid;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *UserID;
@property (nonatomic, assign) int  userId;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *myContent;
@property (nonatomic, copy) NSString * remark;
@property (nonatomic, copy) NSString * addTime;
@property (nonatomic, strong) NSArray * coupons;

@end
