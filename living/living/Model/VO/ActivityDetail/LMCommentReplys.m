//
//  LMCommentReplys.m
//
//  Created by   on 2016/10/24
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import "LMCommentReplys.h"


NSString *const kReplysAvatar = @"avatar";
NSString *const kReplysAddress = @"address";
NSString *const kReplysReplyTime = @"reply_time";
NSString *const kReplysReplyContent = @"replyContent";
NSString *const kReplysRespondentNickname = @"respondent_nickname";
NSString *const kReplysUserUuid = @"userUuid";
NSString *const kReplysNickName = @"nickName";
NSString *const kReplysCommentUuid = @"commentUuid";


@interface LMCommentReplys ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation LMCommentReplys

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
        self.avatar = [self objectOrNilForKey:kReplysAvatar fromDictionary:dict];
        self.address = [self objectOrNilForKey:kReplysAddress fromDictionary:dict];
        self.replyTime = [self objectOrNilForKey:kReplysReplyTime fromDictionary:dict];
        self.replyContent = [self objectOrNilForKey:kReplysReplyContent fromDictionary:dict];
        self.respondentNickname = [self objectOrNilForKey:kReplysRespondentNickname fromDictionary:dict];
        self.userUuid = [self objectOrNilForKey:kReplysUserUuid fromDictionary:dict];
        self.nickName = [self objectOrNilForKey:kReplysNickName fromDictionary:dict];
        self.commentUuid = [self objectOrNilForKey:kReplysCommentUuid fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.avatar forKey:kReplysAvatar];
    [mutableDict setValue:self.address forKey:kReplysAddress];
    [mutableDict setValue:self.replyTime forKey:kReplysReplyTime];
    [mutableDict setValue:self.replyContent forKey:kReplysReplyContent];
    [mutableDict setValue:self.respondentNickname forKey:kReplysRespondentNickname];
    [mutableDict setValue:self.userUuid forKey:kReplysUserUuid];
    [mutableDict setValue:self.nickName forKey:kReplysNickName];
    [mutableDict setValue:self.commentUuid forKey:kReplysCommentUuid];

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

    self.avatar = [aDecoder decodeObjectForKey:kReplysAvatar];
    self.address = [aDecoder decodeObjectForKey:kReplysAddress];
    self.replyTime = [aDecoder decodeObjectForKey:kReplysReplyTime];
    self.replyContent = [aDecoder decodeObjectForKey:kReplysReplyContent];
    self.respondentNickname = [aDecoder decodeObjectForKey:kReplysRespondentNickname];
    self.userUuid = [aDecoder decodeObjectForKey:kReplysUserUuid];
    self.nickName = [aDecoder decodeObjectForKey:kReplysNickName];
    self.commentUuid = [aDecoder decodeObjectForKey:kReplysCommentUuid];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_avatar forKey:kReplysAvatar];
    [aCoder encodeObject:_address forKey:kReplysAddress];
    [aCoder encodeObject:_replyTime forKey:kReplysReplyTime];
    [aCoder encodeObject:_replyContent forKey:kReplysReplyContent];
    [aCoder encodeObject:_respondentNickname forKey:kReplysRespondentNickname];
    [aCoder encodeObject:_userUuid forKey:kReplysUserUuid];
    [aCoder encodeObject:_nickName forKey:kReplysNickName];
    [aCoder encodeObject:_commentUuid forKey:kReplysCommentUuid];
}

- (id)copyWithZone:(NSZone *)zone
{
    LMCommentReplys *copy = [[LMCommentReplys alloc] init];
    
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
