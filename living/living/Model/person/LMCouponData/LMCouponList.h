//
//  LMCouponList.h
//
//  Created by   on 2016/11/3
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface LMCouponList : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *userUuid;
@property (nonatomic, strong) NSString *livingUuid;
@property (nonatomic, strong) NSString *livingName;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
