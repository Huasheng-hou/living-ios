//
//  BlendVO.h
//  living
//
//  Created by Ding on 2016/12/8.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import <Foundation/Foundation.h>

#if ! __has_feature(objc_arc)
#define JSONAutoRelease(param) ([param autorelease]);
#else
#define JSONAutoRelease(param) (param)
#endif

@interface BlendVO : NSObject

+ (BlendVO *)BlendVOWithJSONString:(NSString *)jsonString usingEncoding:(NSStringEncoding)stringEncoding error:(NSError **)error;
+ (BlendVO *)BlendVOWithDictionary:(NSDictionary *)dictionary;
+ (NSArray *)BlendVOListWithArray:(NSArray *)array;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@property (nonatomic, retain) NSString *content;
@property (nonatomic, retain) NSArray *images;



@end

