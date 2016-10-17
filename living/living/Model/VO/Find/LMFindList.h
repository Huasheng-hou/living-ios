//
//  LMFindList.h
//
//  Created by   on 16/10/17
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface LMFindList : NSObject <NSCoding, NSCopying>

@property (nonatomic, assign) double numberOfVotes;
@property (nonatomic, strong) NSString *descrition;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *findUuid;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
