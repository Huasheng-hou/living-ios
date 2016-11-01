//
//  LMAUTHORList.h
//
//  Created by   on 2016/11/1
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface LMAUTHORList : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *articleContent;
@property (nonatomic, strong) NSString *nickname;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *publishTime;
@property (nonatomic, strong) NSString *cover;
@property (nonatomic, strong) NSString *authorUuid;
@property (nonatomic, strong) NSString *articleUuid;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
