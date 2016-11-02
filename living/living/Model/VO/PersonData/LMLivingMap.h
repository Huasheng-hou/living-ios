//
//  LMLivingMap.h
//
//  Created by   on 2016/11/2
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface LMLivingMap : NSObject <NSCoding, NSCopying>

@property (nonatomic, assign) double joinNums;
@property (nonatomic, assign) double publishNums;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
