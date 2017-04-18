//
//  LMCoinlistVO.h
//  living
//
//  Created by hxm on 2017/3/21.
//  Copyright © 2017年 chenle. All rights reserved.
//

#import <Foundation/Foundation.h>
#if ! __has_feature(objc_arc)
#define JSONAutoRelease(param) ([param autorelease]);
#else
#define JSONAutoRelease(param) (param)
#endif
@interface LMCoinlistVO : NSObject

@property (nonatomic, copy) NSString * amount;
@property (nonatomic, copy) NSString * describe;
@property (nonatomic, copy) NSString * title;
@property (nonatomic, copy) NSString * image;
@property (nonatomic, assign) int numbers;


+ (LMCoinlistVO *)LMCoinlistVOWithJSONString:(NSString *)jsonString usingEncoding:(NSStringEncoding)stringEncoding error:(NSError **)error;
+ (LMCoinlistVO *)LMCoinlistVOWithDictionary:(NSDictionary *)dictionary;
+ (NSArray *)LMCoinlistVOWithArray:(NSArray *)array;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@end
