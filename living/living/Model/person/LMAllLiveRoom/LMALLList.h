//
//  LMALLList.h
//
//  Created by   on 2016/11/3
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface LMALLList : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *livingImage;
@property (nonatomic, strong) NSString *livingName;
@property (nonatomic, strong) NSString *livingUuid;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
