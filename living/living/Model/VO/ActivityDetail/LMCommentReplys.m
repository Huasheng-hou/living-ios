//
//  LMCommentReplys.m
//
//  Created by   on 2016/10/24
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import "LMCommentReplys.h"


NSString *const kReplysUserUuid = @"userUuid";
NSString *const kReplysReplyContent = @"replyContent";
NSString *const kReplysCommentUuid = @"commentUuid";
NSString *const kReplysNickName = @"nickName";
NSString *const kReplysAvatar = @"avatar";


@interface LMCommentReplys ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation LMCommentReplys

@synthesize userUuid = _userUuid;
@synthesize replyContent = _replyContent;
@synthesize commentUuid = _commentUuid;
@synthesize nickName = _nickName;
@synthesize avatar = _avatar;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict
{
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if(self && [dict isKindOfClass:[NSDictionary class]]) {
            self.userUuid = [self objectOrNilForKey:kReplysUserUuid fromDictionary:dict];
            self.replyContent = [self objectOrNilForKey:kReplysReplyContent fromDictionary:dict];
            self.commentUuid = [self objectOrNilForKey:kReplysCommentUuid fromDictionary:dict];
            self.nickName = [self objectOrNilForKey:kReplysNickName fromDictionary:dict];
            self.avatar = [self objectOrNilForKey:kReplysAvatar fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.userUuid forKey:kReplysUserUuid];
    [mutableDict setValue:self.replyContent forKey:kReplysReplyContent];
    [mutableDict setValue:self.commentUuid forKey:kReplysCommentUuid];
    [mutableDict setValue:self.nickName forKey:kReplysNickName];
    [mutableDict setValue:self.avatar forKey:kReplysAvatar];

    return [NSDictionary dictionaryWithDictionary:mutableDict];
}

- (NSString *)description 
{
    return [NSString stringWithFormat:@"%@", [self dictionaryRepresentation]];
}

#pragma mark - Helper Method
- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict
{
    id object = [dict objectForKey:aKey];
    return [object isEqual:[NSNull null]] ? nil : object;
}


#pragma mark - NSCoding Methods

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];

    self.userUuid = [aDecoder decodeObjectForKey:kReplysUserUuid];
    self.replyContent = [aDecoder decodeObjectForKey:kReplysReplyContent];
    self.commentUuid = [aDecoder decodeObjectForKey:kReplysCommentUuid];
    self.nickName = [aDecoder decodeObjectForKey:kReplysNickName];
    self.avatar = [aDecoder decodeObjectForKey:kReplysAvatar];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_userUuid forKey:kReplysUserUuid];
    [aCoder encodeObject:_replyContent forKey:kReplysReplyContent];
    [aCoder encodeObject:_commentUuid forKey:kReplysCommentUuid];
    [aCoder encodeObject:_nickName forKey:kReplysNickName];
    [aCoder encodeObject:_avatar forKey:kReplysAvatar];
}

- (id)copyWithZone:(NSZone *)zone
{
    LMCommentReplys *copy = [[LMCommentReplys alloc] init];
    
    if (copy) {

        copy.userUuid = [self.userUuid copyWithZone:zone];
        copy.replyContent = [self.replyContent copyWithZone:zone];
        copy.commentUuid = [self.commentUuid copyWithZone:zone];
        copy.nickName = [self.nickName copyWithZone:zone];
        copy.avatar = [self.avatar copyWithZone:zone];
    }
    
    return copy;
}


@end
