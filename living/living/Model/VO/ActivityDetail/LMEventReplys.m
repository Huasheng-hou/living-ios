//
//  LMEventReplys.m
//
//  Created by   on 2016/10/24
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import "LMEventReplys.h"


NSString *const kLMEventReplysAvatar = @"avatar";
NSString *const kLMEventReplysAddress = @"address";
NSString *const kLMEventReplysReplyTime = @"reply_time";
NSString *const kLMEventReplysReplyContent = @"replyContent";
NSString *const kLMEventReplysRespondentNickname = @"respondent_nickname";
NSString *const kLMEventReplysUserUuid = @"userUuid";
NSString *const kLMEventReplysNickName = @"nickName";
NSString *const kLMEventReplysCommentUuid = @"commentUuid";


@interface LMEventReplys ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation LMEventReplys

@synthesize avatar = _avatar;
@synthesize address = _address;
@synthesize replyTime = _replyTime;
@synthesize replyContent = _replyContent;
@synthesize respondentNickname = _respondentNickname;
@synthesize userUuid = _userUuid;
@synthesize nickName = _nickName;
@synthesize commentUuid = _commentUuid;


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
            self.avatar = [self objectOrNilForKey:kLMEventReplysAvatar fromDictionary:dict];
            self.address = [self objectOrNilForKey:kLMEventReplysAddress fromDictionary:dict];
            self.replyTime = [self objectOrNilForKey:kLMEventReplysReplyTime fromDictionary:dict];
            self.replyContent = [self objectOrNilForKey:kLMEventReplysReplyContent fromDictionary:dict];
            self.respondentNickname = [self objectOrNilForKey:kLMEventReplysRespondentNickname fromDictionary:dict];
            self.userUuid = [self objectOrNilForKey:kLMEventReplysUserUuid fromDictionary:dict];
            self.nickName = [self objectOrNilForKey:kLMEventReplysNickName fromDictionary:dict];
            self.commentUuid = [self objectOrNilForKey:kLMEventReplysCommentUuid fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.avatar forKey:kLMEventReplysAvatar];
    [mutableDict setValue:self.address forKey:kLMEventReplysAddress];
    [mutableDict setValue:self.replyTime forKey:kLMEventReplysReplyTime];
    [mutableDict setValue:self.replyContent forKey:kLMEventReplysReplyContent];
    [mutableDict setValue:self.respondentNickname forKey:kLMEventReplysRespondentNickname];
    [mutableDict setValue:self.userUuid forKey:kLMEventReplysUserUuid];
    [mutableDict setValue:self.nickName forKey:kLMEventReplysNickName];
    [mutableDict setValue:self.commentUuid forKey:kLMEventReplysCommentUuid];

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

    self.avatar = [aDecoder decodeObjectForKey:kLMEventReplysAvatar];
    self.address = [aDecoder decodeObjectForKey:kLMEventReplysAddress];
    self.replyTime = [aDecoder decodeObjectForKey:kLMEventReplysReplyTime];
    self.replyContent = [aDecoder decodeObjectForKey:kLMEventReplysReplyContent];
    self.respondentNickname = [aDecoder decodeObjectForKey:kLMEventReplysRespondentNickname];
    self.userUuid = [aDecoder decodeObjectForKey:kLMEventReplysUserUuid];
    self.nickName = [aDecoder decodeObjectForKey:kLMEventReplysNickName];
    self.commentUuid = [aDecoder decodeObjectForKey:kLMEventReplysCommentUuid];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_avatar forKey:kLMEventReplysAvatar];
    [aCoder encodeObject:_address forKey:kLMEventReplysAddress];
    [aCoder encodeObject:_replyTime forKey:kLMEventReplysReplyTime];
    [aCoder encodeObject:_replyContent forKey:kLMEventReplysReplyContent];
    [aCoder encodeObject:_respondentNickname forKey:kLMEventReplysRespondentNickname];
    [aCoder encodeObject:_userUuid forKey:kLMEventReplysUserUuid];
    [aCoder encodeObject:_nickName forKey:kLMEventReplysNickName];
    [aCoder encodeObject:_commentUuid forKey:kLMEventReplysCommentUuid];
}

- (id)copyWithZone:(NSZone *)zone
{
    LMEventReplys *copy = [[LMEventReplys alloc] init];
    
    if (copy) {

        copy.avatar = [self.avatar copyWithZone:zone];
        copy.address = [self.address copyWithZone:zone];
        copy.replyTime = [self.replyTime copyWithZone:zone];
        copy.replyContent = [self.replyContent copyWithZone:zone];
        copy.respondentNickname = [self.respondentNickname copyWithZone:zone];
        copy.userUuid = [self.userUuid copyWithZone:zone];
        copy.nickName = [self.nickName copyWithZone:zone];
        copy.commentUuid = [self.commentUuid copyWithZone:zone];
    }
    
    return copy;
}


@end
