//
//  LMFindVO.h
//  living
//
//  Created by Ding on 2016/11/7.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import <Foundation/Foundation.h>

#if ! __has_feature(objc_arc)
#define JSONAutoRelease(param) ([param autorelease]);
#else
#define JSONAutoRelease(param) (param)
#endif


@interface LMFindVO : NSObject

+ (LMFindVO *)LMFindVOWithJSONString:(NSString *)jsonString usingEncoding:(NSStringEncoding)stringEncoding error:(NSError **)error;
+ (LMFindVO *)LMFindVOWithDictionary:(NSDictionary *)dictionary;
+ (NSArray *)LMFindVOListWithArray:(NSArray *)array;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@property (nonatomic, assign) int numberOfVotes;
@property (nonatomic, assign) BOOL hasPraised;
@property (nonatomic, strong) NSString *descrition;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *findUuid;
@property (nonatomic, strong) NSString *images;

@end
