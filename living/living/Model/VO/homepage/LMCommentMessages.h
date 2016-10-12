//
//  CommentMessages.h
//
//  Created by   on 16/10/12
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface LMCommentMessages : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *nickName;
@property (nonatomic, strong) NSString *commentUuid;
@property (nonatomic, strong) NSString *avatar;
@property (nonatomic, assign) double praiseCount;
@property (nonatomic, strong) NSString *commentContent;
@property (nonatomic, strong) NSString *userUuid;
@property (nonatomic, strong) NSString *commentTime;
@property (nonatomic, assign) BOOL hasPraised;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
