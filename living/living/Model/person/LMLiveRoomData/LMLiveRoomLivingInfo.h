//
//  LMLiveRoomLivingInfo.h
//
//  Created by   on 2016/11/2
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface LMLiveRoomLivingInfo : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSArray *livingImage;
@property (nonatomic, strong) NSString *livingName;
@property (nonatomic, strong) NSString *livingTitle;
@property (nonatomic, strong) NSString *userUuid;
@property (nonatomic, strong) NSString *livingUuid;
@property (nonatomic, strong) NSString *balance;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
