//
//  RequiredQuestion.h
//
//  Created by   on 16/8/31
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface RequiredQuestion : NSObject <NSCoding, NSCopying>

@property (nonatomic, assign) double gender;
@property (nonatomic, strong) NSString *requiredAt;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *questionUuid;
@property (nonatomic, strong) NSString *createdAt;
@property (nonatomic, strong) NSString *userUuid;
@property (nonatomic, strong) NSString *updatedAt;
@property (nonatomic, strong) NSArray *imageUrls;
@property (nonatomic, assign) double tickets;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
