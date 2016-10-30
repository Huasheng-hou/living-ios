//
//  LMBalanceList.h
//
//  Created by   on 2016/10/30
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface LMBalanceList : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *amount;
@property (nonatomic, strong) NSString *balanceUuid;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *datetime;
@property (nonatomic, strong) NSString *name;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
