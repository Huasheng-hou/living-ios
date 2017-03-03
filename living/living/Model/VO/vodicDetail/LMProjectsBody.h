//
//  LMProjectsBody.h
//  living
//
//  Created by Ding on 2016/12/13.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import <Foundation/Foundation.h>

#if ! __has_feature(objc_arc)
#define JSONAutoRelease(param) ([param autorelease]);
#else
#define JSONAutoRelease(param) (param)
#endif

@interface LMProjectsBody : NSObject

+ (LMProjectsBody *)LMProjectsBodyWithJSONString:(NSString *)jsonString usingEncoding:(NSStringEncoding)stringEncoding error:(NSError **)error;
+ (LMProjectsBody *)LMProjectsBodyWithDictionary:(NSDictionary *)dictionary;
+ (NSArray *)LMProjectsBodyVOWithArray:(NSArray *)array;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@property (nonatomic, retain) NSString *projectTitle;
@property (nonatomic, retain) NSString *projectImgs;
@property (nonatomic, retain) NSString *projectUuid;
@property (nonatomic, retain) NSString *projectDsp;
@property (nonatomic, assign) float   width;
@property (nonatomic, assign) float   height;

@end
