//
//  LMProjectBodyVO.m
//  living
//
//  Created by Ding on 2016/11/6.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "LMProjectBodyVO.h"

@implementation LMProjectBodyVO

+ (LMProjectBodyVO *)LMProjectBodyVOWithJSONString:(NSString *)jsonString usingEncoding:(NSStringEncoding)stringEncoding error:(NSError **)error
{
    NSData *jsonData = [jsonString dataUsingEncoding:stringEncoding];
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                   options:0
                                                                     error:error];
    
    if (nil != error && nil != jsonDictionary) {
        return [LMProjectBodyVO LMProjectBodyVOWithDictionary:jsonDictionary];
    }
    
    return nil;
    
}
+ (LMProjectBodyVO *)LMProjectBodyVOWithDictionary:(NSDictionary *)dictionary
{
    LMProjectBodyVO *instance = [[LMProjectBodyVO alloc] initWithDictionary:dictionary];
    return JSONAutoRelease(instance);
}
+ (NSArray *)LMProjectBodyVOListWithArray:(NSArray *)array
{
    if (!array || ![array isKindOfClass:[NSArray class]]) {
        return nil;
    }
    
    NSMutableArray *resultsArray = [[NSMutableArray alloc] init];
    
    for (id entry in array) {
        if (![entry isKindOfClass:[NSDictionary class]]) {
            continue;
        }
        
        [resultsArray addObject:[LMProjectBodyVO LMProjectBodyVOWithDictionary:entry]];
    }
    
    return JSONAutoRelease(resultsArray);
    
}

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        if (nil != [dictionary objectForKey:@"project_title"] && ![[dictionary objectForKey:@"project_title"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"project_title"] isKindOfClass:[NSString class]]) {
            self.projectTitle = [dictionary objectForKey:@"project_title"];
        }
        
        if (nil != [dictionary objectForKey:@"project_imgs"] && ![[dictionary objectForKey:@"project_imgs"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"project_imgs"] isKindOfClass:[NSString class]]) {
            self.projectImgs = [dictionary objectForKey:@"project_imgs"];
        }
        
        if (nil != [dictionary objectForKey:@"event_project_uuid"] && ![[dictionary objectForKey:@"event_project_uuid"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"event_project_uuid"] isKindOfClass:[NSString class]]) {
            self.eventProjectUuid= [dictionary objectForKey:@"event_project_uuid"];
        }
        
        if (nil != [dictionary objectForKey:@"project_dsp"] && ![[dictionary objectForKey:@"project_dsp"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"project_dsp"] isKindOfClass:[NSString class]]) {
            self.projectDsp= [dictionary objectForKey:@"project_dsp"];
        }
        
        if (nil != [dictionary objectForKey:@"width"] && ![[dictionary objectForKey:@"width"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"width"] isKindOfClass:[NSNumber class]]) {
            self.width=[(NSNumber *) [dictionary objectForKey:@"width"] floatValue];
        }
        
        if (nil != [dictionary objectForKey:@"height"] && ![[dictionary objectForKey:@"height"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"height"] isKindOfClass:[NSNumber class]]) {
            self.height=[(NSNumber *) [dictionary objectForKey:@"height"] floatValue];
        }
        
    }
    return self;
}


@end
