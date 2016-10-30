//
//  LMOrderDataOrderInfo.h
//
//  Created by   on 2016/10/30
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface LMOrderDataOrderInfo : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *endTime;
@property (nonatomic, strong) NSString *eventName;
@property (nonatomic, strong) NSString *totalMoney;
@property (nonatomic, strong) NSString *startTime;
@property (nonatomic, strong) NSString *eventAddress;
@property (nonatomic, strong) NSString *averagePrice;
@property (nonatomic, assign) double joinNumber;
@property (nonatomic, strong) NSString *orderNumber;
@property (nonatomic, strong) NSString *eventUuid;
@property (nonatomic, strong) NSString *orderUuid;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
