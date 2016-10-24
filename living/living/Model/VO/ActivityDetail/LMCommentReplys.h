//
//  LMCommentReplys.h
//
//  Created by   on 2016/10/24
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface LMCommentReplys : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *userUuid;
@property (nonatomic, strong) NSString *replyContent;
@property (nonatomic, strong) NSString *commentUuid;
@property (nonatomic, strong) NSString *nickName;
@property (nonatomic, strong) NSString *avatar;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
