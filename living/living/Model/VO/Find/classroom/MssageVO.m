//
//  MssageVO.m
//  living
//
//  Created by Ding on 2016/12/20.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "MssageVO.h"

@implementation MssageVO

+ (MssageVO *)MssageVOWithJSONString:(NSString *)jsonString usingEncoding:(NSStringEncoding)stringEncoding error:(NSError **)error
{
    NSData *jsonData = [jsonString dataUsingEncoding:stringEncoding];
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                   options:0
                                                                     error:error];
    
    if (nil != error && nil != jsonDictionary) {
        return [MssageVO MssageVOWithDictionary:jsonDictionary];
    }
    
    return nil;
}

+ (MssageVO *)MssageVOWithDictionary:(NSDictionary *)dictionary
{
    MssageVO *instance = [[MssageVO alloc] initWithDictionary:dictionary];
    return JSONAutoRelease(instance);
}

+ (NSArray *)MssageVOListWithArray:(NSArray *)array
{
    if (!array || ![array isKindOfClass:[NSArray class]]) {
        return nil;
    }
    
    NSMutableArray *resultsArray = [[NSMutableArray alloc] init];
    
    for (id entry in array) {
        if (![entry isKindOfClass:[NSDictionary class]]) {
            continue;
        }
        
        [resultsArray addObject:[MssageVO MssageVOWithDictionary:entry]];
    }
    
    return JSONAutoRelease(resultsArray);
}

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        
        if (nil != [dictionary objectForKey:@"name"] && ![[dictionary objectForKey:@"name"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"name"] isKindOfClass:[NSString class]]) {
            self.name = [dictionary objectForKey:@"name"];
        }
        
        if (nil != [dictionary objectForKey:@"content"] && ![[dictionary objectForKey:@"content"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"content"] isKindOfClass:[NSString class]]) {
            self.content = [dictionary objectForKey:@"content"];
        }
        
        if (nil != [dictionary objectForKey:@"type"] && ![[dictionary objectForKey:@"type"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"type"] isKindOfClass:[NSString class]]) {
            self.type = [dictionary objectForKey:@"type"];
        }
        
        if (nil != [dictionary objectForKey:@"time"] && ![[dictionary objectForKey:@"time"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"time"] isKindOfClass:[NSString class]]) {
            
            NSDateFormatter     *formatter  = [[NSDateFormatter alloc] init];
            
            [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            
            self.time = [formatter dateFromString:[dictionary objectForKey:@"time"]];
        }
        
        
        if (nil != [dictionary objectForKey:@"role"] && ![[dictionary objectForKey:@"role"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"role"] isKindOfClass:[NSString class]]) {
            self.role = [dictionary objectForKey:@"role"];
        }
        
        if (nil != [dictionary objectForKey:@"headimgurl"] && ![[dictionary objectForKey:@"headimgurl"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"headimgurl"] isKindOfClass:[NSString class]]) {
            self.headimgurl = [dictionary objectForKey:@"headimgurl"];
        }
        
        if (nil != [dictionary objectForKey:@"voiceurl"] && ![[dictionary objectForKey:@"voiceurl"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"voiceurl"] isKindOfClass:[NSString class]]) {
            self.voiceurl = [dictionary objectForKey:@"voiceurl"];
        }
        
        if (nil != [dictionary objectForKey:@"imageurl"] && ![[dictionary objectForKey:@"imageurl"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"imageurl"] isKindOfClass:[NSString class]]) {
            self.imageurl = [dictionary objectForKey:@"imageurl"];
        }
        
        if (nil != [dictionary objectForKey:@"avatar"] && ![[dictionary objectForKey:@"avatar"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"avatar"] isKindOfClass:[NSString class]]) {
            self.avatar = [dictionary objectForKey:@"avatar"];
        }
        
        if (nil != [dictionary objectForKey:@"attachment"] && ![[dictionary objectForKey:@"attachment"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"attachment"] isKindOfClass:[NSString class]]) {
            self.attachment = [dictionary objectForKey:@"attachment"];
        }
        
        if (nil != [dictionary objectForKey:@"currentIndex"] && ![[dictionary objectForKey:@"currentIndex"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"currentIndex"] isKindOfClass:[NSNumber class]]) {
            self.currentIndex = [dictionary objectForKey:@"currentIndex"];
        }
        if (nil != [dictionary objectForKey:@"recordingTime"] && ![[dictionary objectForKey:@"recordingTime"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"recordingTime"] isKindOfClass:[NSNumber class]]) {
            self.recordingTime = [dictionary objectForKey:@"recordingTime"];
        }
        
        if (nil != [dictionary objectForKey:@"sign"] && ![[dictionary objectForKey:@"sign"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"sign"] isKindOfClass:[NSString class]]) {
            self.sign = [dictionary objectForKey:@"sign"];
        }
        
        if (nil != [dictionary objectForKey:@"host_uuid"] && ![[dictionary objectForKey:@"host_uuid"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"host_uuid"] isKindOfClass:[NSString class]]) {
            self.host_uuid = [dictionary objectForKey:@"host_uuid"];
        }
        
        if (nil != [dictionary objectForKey:@"user_uuid"] && ![[dictionary objectForKey:@"user_uuid"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"user_uuid"] isKindOfClass:[NSString class]]) {
            self.user_uuid = [dictionary objectForKey:@"user_uuid"];
        }
        if (nil != [dictionary objectForKey:@"status"] && ![[dictionary objectForKey:@"status"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"status"] isKindOfClass:[NSString class]]) {
            self.status = [dictionary objectForKey:@"status"];
        }
        
        if (nil != [dictionary objectForKey:@"question_uuid"] && ![[dictionary objectForKey:@"question_uuid"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"question_uuid"] isKindOfClass:[NSString class]]) {
            self.questionUuid = [dictionary objectForKey:@"question_uuid"];
        }
        
        
        if (nil != [dictionary objectForKey:@"has_profile"] && ![[dictionary objectForKey:@"has_profile"] isEqual:[NSNull null]]) {
            self.hasProfile = [(NSNumber *)[dictionary objectForKey:@"has_profile"] boolValue];
        }
        
        self.ifShowTimeLbl              = NO;
    }
    
    return self;
}


@end
