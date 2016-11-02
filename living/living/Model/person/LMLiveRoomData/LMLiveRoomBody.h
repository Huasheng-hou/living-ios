//
//  LMLiveRoomBody.h
//
//  Created by   on 2016/11/2
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LMLiveRoomMap, LMLiveRoomLivingInfo;

@interface LMLiveRoomBody : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *result;
@property (nonatomic, strong) NSArray *listofUser;
@property (nonatomic, strong) LMLiveRoomMap *map;
@property (nonatomic, strong) LMLiveRoomLivingInfo *livingInfo;
@property (nonatomic, strong) NSString *bodyDescription;
@property (nonatomic, strong) NSArray *list;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
