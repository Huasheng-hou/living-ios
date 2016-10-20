//
//  UserInfo.h
//
//  Created by   on 16/10/11
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface LMUserInfo : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *gender;
@property (nonatomic, strong) NSString *nickName;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *avatar;
@property (nonatomic, strong) NSString *eventNum;
@property (nonatomic, assign) double balance;
@property (nonatomic, strong) NSString *birthday;
@property (nonatomic, assign) double orderNumber;
@property (nonatomic, strong) NSString *totalEventNum;
@property (nonatomic, strong) NSString *province;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
