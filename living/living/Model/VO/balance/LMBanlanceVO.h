//
//  LMBanlanceVO.h
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

@interface LMBanlanceVO : NSObject

+ (LMBanlanceVO *)LMBanlanceVOWithJSONString:(NSString *)jsonString usingEncoding:(NSStringEncoding)stringEncoding error:(NSError **)error;
+ (LMBanlanceVO *)LMBanlanceVOWithDictionary:(NSDictionary *)dictionary;
+ (NSArray *)LMBanlanceVOListWithArray:(NSArray *)array;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@property (nonatomic, retain) NSString *amount;
@property (nonatomic, retain) NSString *balanceUuid;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSDate *datetime;
@property (nonatomic, retain) NSString *name;

@end
