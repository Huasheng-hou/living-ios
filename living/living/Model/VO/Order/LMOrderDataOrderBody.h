//
//  LMOrderDataOrderBody.h
//
//  Created by   on 2016/10/30
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface LMOrderDataOrderBody : NSObject <NSCoding, NSCopying>

@property (nonatomic, assign) double number;
@property (nonatomic, strong) NSString *eventName;
@property (nonatomic, strong) NSString *totalMoney;
@property (nonatomic, strong) NSString *price;
@property (nonatomic, strong) NSString *orderUuid;
@property (nonatomic, strong) NSString *eventUuid;
@property (nonatomic, strong) NSString *orderTime;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
