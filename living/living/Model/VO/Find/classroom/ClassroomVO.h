//
//  ClassroomVO.h
//  living
//
//  Created by Ding on 2016/12/12.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import <Foundation/Foundation.h>

#if ! __has_feature(objc_arc)
#define JSONAutoRelease(param) ([param autorelease]);
#else
#define JSONAutoRelease(param) (param)
#endif


@interface ClassroomVO : NSObject

+ (ClassroomVO *)ClassroomVOWithJSONString:(NSString *)jsonString usingEncoding:(NSStringEncoding)stringEncoding error:(NSError **)error;
+ (ClassroomVO *)ClassroomVOWithDictionary:(NSDictionary *)dictionary;
+ (NSArray *)ClassroomVOListWithArray:(NSArray *)array;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@property (nonatomic, strong) NSString *userUuid;
@property (nonatomic, strong) NSString *voiceUuid;
@property (nonatomic, strong) NSString *avatar;
@property (nonatomic, strong) NSString *nickname;
@property (nonatomic, strong) NSString *image;
@property (nonatomic, strong) NSString *voiceTitle;
@property (nonatomic, assign) int currentNum;
@property (nonatomic, strong) NSDate *startTime;
@property (nonatomic, strong) NSString *perCost;
@property (nonatomic, strong) NSString *discount;
@property (nonatomic, assign) int totalNum;
@property (nonatomic, strong) NSString *status;

@end
