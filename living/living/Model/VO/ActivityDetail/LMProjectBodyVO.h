//
//  LMProjectBodyVO.h
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

@interface LMProjectBodyVO : NSObject

+ (LMProjectBodyVO *)LMProjectBodyVOWithJSONString:(NSString *)jsonString usingEncoding:(NSStringEncoding)stringEncoding error:(NSError **)error;
+ (LMProjectBodyVO *)LMProjectBodyVOWithDictionary:(NSDictionary *)dictionary;
+ (NSArray *)LMProjectBodyVOListWithArray:(NSArray *)array;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@property (nonatomic, retain) NSString *projectTitle;
@property (nonatomic, retain) NSString *projectImgs;
@property (nonatomic, retain) NSString *eventProjectUuid;
@property (nonatomic, retain) NSString *projectDsp;

@end
