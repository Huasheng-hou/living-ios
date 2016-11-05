//
//  LMFindList.h
//
//  Created by   on 2016/11/5
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface LMFindList : NSObject <NSCoding, NSCopying>

@property (nonatomic, assign) double numberOfVotes;
@property (nonatomic, assign) BOOL hasPraised;
@property (nonatomic, strong) NSString *descrition;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *findUuid;
@property (nonatomic, strong) NSString *images;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
