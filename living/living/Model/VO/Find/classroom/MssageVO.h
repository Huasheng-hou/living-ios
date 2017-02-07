//
//  MssageVO.h
//  living
//
//  Created by Ding on 2016/12/20.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import <Foundation/Foundation.h>

#if ! __has_feature(objc_arc)
#define JSONAutoRelease(param) ([param autorelease]);
#else
#define JSONAutoRelease(param) (param)
#endif

@interface MssageVO : NSObject

+ (MssageVO *)MssageVOWithJSONString:(NSString *)jsonString usingEncoding:(NSStringEncoding)stringEncoding error:(NSError **)error;
+ (MssageVO *)MssageVOWithDictionary:(NSDictionary *)dictionary;
+ (NSArray *)MssageVOListWithArray:(NSArray *)array;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *time;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *role;
@property (nonatomic, strong) NSString *headimgurl;
@property (nonatomic, strong) NSString *voiceurl;
@property (nonatomic, strong) NSString *imageurl;
@property (nonatomic, strong) NSString *avatar;
@property (nonatomic, strong) NSString *attachment;
@property (nonatomic, assign) NSNumber *currentIndex;
@property (nonatomic, assign) NSNumber *recordingTime;
@property (nonatomic, strong) NSString *sign;
@property (nonatomic, strong) NSString *host_uuid;
@property (nonatomic, strong) NSString *user_uuid;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, assign) BOOL hasProfile;
@property (nonatomic, strong) NSString *questionUuid;
@property (nonatomic, strong) NSString *transcodingUrl;

@property (nonatomic, assign) BOOL  ifShowTimeLbl;
@property (nonatomic, assign) BOOL  ifStopAnimal;
@property (nonatomic, assign) BOOL  ifchangeText;
@property (nonatomic, assign) BOOL  isfirstClick;

@end
