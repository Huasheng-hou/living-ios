//
//  LMActivityList.h
//
//  Created by   on 16/10/13
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface LMActivityList : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *eventName;
@property (nonatomic, assign) double currentNum;
@property (nonatomic, assign) double totalnum;
@property (nonatomic, strong) NSString *startTime;
@property (nonatomic, strong) NSString *userUuid;
@property (nonatomic, strong) NSString *perCost;
@property (nonatomic, strong) NSString *eventImg;
@property (nonatomic, strong) NSString *eventUuid;
@property (nonatomic, strong) NSString *avatar;
@property (nonatomic, strong) NSString *nickNname;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
