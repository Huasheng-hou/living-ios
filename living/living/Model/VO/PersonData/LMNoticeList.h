//
//  LMNoticeList.h
//
//  Created by   on 2016/10/25
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface LMNoticeList : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *commentUuid;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *articleUuid;
@property (nonatomic, strong) NSString *userNick;
@property (nonatomic, strong) NSString *noticeTime;
@property (nonatomic, strong) NSString *userUuid;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *eventUuid;
@property (nonatomic, strong) NSString *noticeUuid;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
