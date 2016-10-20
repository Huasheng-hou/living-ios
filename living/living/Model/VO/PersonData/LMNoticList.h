//
//  LMNoticList.h
//
//  Created by   on 16/10/20
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface LMNoticList : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *eventUuid;
@property (nonatomic, strong) NSString *userNick;
@property (nonatomic, strong) NSString *commentUuid;
@property (nonatomic, strong) NSString *userUuid;
@property (nonatomic, strong) NSString *noticeTime;
@property (nonatomic, strong) NSString *content;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
