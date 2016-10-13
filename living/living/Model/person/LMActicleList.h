//
//  LMActicleList.h
//
//  Created by   on 16/10/11
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LMActicleList : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *articleName;
@property (nonatomic, strong) NSString *articleUuid;
@property (nonatomic, strong) NSString *articleTitle;
@property (nonatomic, strong) NSString *publishTime;
@property (nonatomic, strong) NSString *userUuid;
@property (nonatomic, strong) NSString *avatar;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
