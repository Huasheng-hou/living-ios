//
//  LMVoiceMemberVO.h
//  living
//
//  Created by Ding on 2016/12/15.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import <Foundation/Foundation.h>
#if ! __has_feature(objc_arc)
#define JSONAutoRelease(param) ([param autorelease]);
#else
#define JSONAutoRelease(param) (param)
#endif

@interface LMVoiceMemberVO : NSObject
+ (LMVoiceMemberVO *)LMVoiceMemberVOWithJSONString:(NSString *)jsonString usingEncoding:(NSStringEncoding)stringEncoding error:(NSError **)error;
+ (LMVoiceMemberVO *)LMVoiceMemberVOWithDictionary:(NSDictionary *)dictionary;
+ (NSArray *)LMVoiceMemberVOWithArray:(NSArray *)array;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@property (nonatomic, retain) NSString *avatar;
@property (nonatomic, retain) NSString *userId;
@property (nonatomic, retain) NSString *nickname;
@property (nonatomic, retain) NSString *address;

@end
