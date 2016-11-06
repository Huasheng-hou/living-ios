//
//  LMBalanceVO.h
//  living
//
//  Created by Ding on 2016/11/6.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LMBanlanceVO.h"

#if ! __has_feature(objc_arc)
#define JSONAutoRelease(param) ([param autorelease]);
#else
#define JSONAutoRelease(param) (param)
#endif

@interface LMBalanceVO : NSObject

+ (LMBalanceVO *)LMBalanceVOWithJSONString:(NSString *)jsonString usingEncoding:(NSStringEncoding)stringEncoding error:(NSError **)error;
+ (LMBalanceVO *)LMBalanceVOWithDictionary:(NSDictionary *)dictionary;
+ (NSArray *)LMBalanceVOListWithArray:(NSArray *)array;

@property (nonatomic, retain) NSMutableArray *Banlance;
@property (nonatomic, retain) NSString *month;

@end
