//
//  LMMonthDetailBill.h
//
//  Created by   on 2016/11/7
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface LMMonthDetailBill : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *recharges;
@property (nonatomic, strong) NSString *expenditure;
@property (nonatomic, strong) NSString *eventsBill;
@property (nonatomic, strong) NSString *rechargesBill;
@property (nonatomic, strong) NSString *refundsBill;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
