
//
//  ActivityListVO.h
//  living
//
//  Created by JamHonyZ on 2016/11/6.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import <Foundation/Foundation.h>

#if ! __has_feature(objc_arc)
#define JSONAutoRelease(param) ([param autorelease]);
#else
#define JSONAutoRelease(param) (param)
#endif

@interface ActivityListVO : NSObject

+ (ActivityListVO *)ActivityListVOWithJSONString:(NSString *)jsonString usingEncoding:(NSStringEncoding)stringEncoding error:(NSError **)error;
+ (ActivityListVO *)ActivityListVOWithDictionary:(NSDictionary *)dictionary;
+ (NSArray *)ActivityListVOListWithArray:(NSArray *)array;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@property(nonatomic, retain) NSString       *NickName;
@property(nonatomic, retain) NSString       *EventUuid;
@property(nonatomic, retain) NSNumber       *CurrentNumber;
@property(nonatomic, retain) NSString       *UserUuid;
@property(nonatomic, retain) NSNumber       *TotalNumber;
@property(nonatomic, retain) NSString       *PerCost;
@property(nonatomic, retain) NSString       *Address;
@property(nonatomic, retain) NSDate         *StartTime;
@property(nonatomic, retain) NSString       *EventImg;
@property(nonatomic, retain) NSString       *Avatar;
@property(nonatomic, retain) NSString       *EventName;
@property(nonatomic, retain) NSString       *Status;

@end
