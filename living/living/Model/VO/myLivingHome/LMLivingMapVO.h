//
//  LMLivingMapVO.h
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

@interface LMLivingMapVO : NSObject

+ (LMLivingMapVO *)LMLivingMapVOWithJSONString:(NSString *)jsonString usingEncoding:(NSStringEncoding)stringEncoding error:(NSError **)error;
+ (LMLivingMapVO *)LMLivingMapVOWithDictionary:(NSDictionary *)dictionary;
+ (NSArray *)LMLivingMapVOListWithArray:(NSArray *)array;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@property (nonatomic, assign) int joinNums;
@property (nonatomic, assign) int publishNums;

@end
