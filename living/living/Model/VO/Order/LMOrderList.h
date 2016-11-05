//
//  LMOrderList.h
//
//  Created by   on 16/10/17
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface LMOrderList : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *avatar;
@property (nonatomic, strong) NSString *orderStatus;
@property (nonatomic, strong) NSString *eventName;
@property (nonatomic, strong) NSString *eventUuid;
@property (nonatomic, strong) NSString *orderAmount;
@property (nonatomic, strong) NSString *userUuid;
@property (nonatomic, strong) NSString *payStatus;
@property (nonatomic, strong) NSString *orderUuid;
@property (nonatomic, strong) NSString *orderNumber;
@property (nonatomic, strong) NSString *orderingTime;
@property (nonatomic, assign) double number;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
