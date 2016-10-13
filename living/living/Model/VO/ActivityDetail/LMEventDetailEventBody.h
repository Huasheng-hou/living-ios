//
//  LMEventDetailEventBody.h
//
//  Created by   on 16/10/13
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface LMEventDetailEventBody : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *publishName;
@property (nonatomic, strong) NSString *contactPhone;
@property (nonatomic, strong) NSString *userUuid;
@property (nonatomic, strong) NSString *eventName;
@property (nonatomic, strong) NSString *startTime;
@property (nonatomic, assign) double totalNumber;
@property (nonatomic, strong) NSString *eventImg;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *eventUuid;
@property (nonatomic, strong) NSString *endTime;
@property (nonatomic, strong) NSString *perCost;
@property (nonatomic, strong) NSString *contactName;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
