
//
//  HeadVO.h
//  FitTrainer
//
//  Created by Huasheng on 15/8/21.
//  Copyright (c) 2015年 Huasheng. All rights reserved.
//

#import <Foundation/Foundation.h>

#if ! __has_feature(objc_arc)
#define JSONAutoRelease(param) ([param autorelease]);
#else
#define JSONAutoRelease(param) (param)
#endif

typedef enum {
    kSysCodeNormal              =       0,
    kSysCodeMaintenance         =       1,
    kSysCodeUpdate              =       2
} FitSysCode;

typedef enum {
    kUserCodeNormal             =       0,
    kUserCodeTimeout            =       1,
    kUserCodeNoUser             =       2,
    kUserCodeWrongPass          =       3,
    kUserCodeReplaced           =       5
} FitUserCode;

typedef enum {
    kResCodeNormal              =       0,
    kResCodeUnknow              =       1,
    kResCodeDeny                =       2,
    kResCodeWrongPara           =       3
} FitResCode;

@interface HeadVO : NSObject
{
}

+ (HeadVO *)HeadVOWithJSONString:(NSString *)jsonString usingEncoding:(NSStringEncoding)stringEncoding error:(NSError **)error;
+ (HeadVO *)HeadVOWithDictionary:(NSDictionary *)dictionary;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@property(nonatomic, assign) FitSysCode     SysCode;
@property(nonatomic, assign) FitUserCode    UserCode;
@property(nonatomic, assign) FitResCode     ResCode;
@property(nonatomic, retain) NSString       *Code;
@property(nonatomic, retain) NSString       *Desc;

@end

