//
//  LMProjectsBody.m
//  living
//
//  Created by Ding on 2016/12/13.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "LMProjectsBody.h"

@implementation LMProjectsBody

+ (LMProjectsBody *)LMProjectsBodyWithJSONString:(NSString *)jsonString usingEncoding:(NSStringEncoding)stringEncoding error:(NSError **)error
{
    NSData *jsonData = [jsonString dataUsingEncoding:stringEncoding];
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                   options:0
                                                                     error:error];
    
    if (nil != error && nil != jsonDictionary) {
        return [LMProjectsBody LMProjectsBodyWithDictionary:jsonDictionary];
    }
    
    return nil;
    
}
+ (LMProjectsBody *)LMProjectsBodyWithDictionary:(NSDictionary *)dictionary
{
    LMProjectsBody *instance = [[LMProjectsBody alloc] initWithDictionary:dictionary];
    return JSONAutoRelease(instance);
}
+ (NSArray *)LMProjectsBodyVOWithArray:(NSArray *)array
{
    if (!array || ![array isKindOfClass:[NSArray class]]) {
        return nil;
    }
    
    NSMutableArray *resultsArray = [[NSMutableArray alloc] init];
    
    for (id entry in array) {
        if (![entry isKindOfClass:[NSDictionary class]]) {
            continue;
        }
        
        [resultsArray addObject:[LMProjectsBody LMProjectsBodyWithDictionary:entry]];
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
        
        if (nil != [dictionary objectForKey:@"project_uuid"] && ![[dictionary objectForKey:@"project_uuid"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"project_uuid"] isKindOfClass:[NSString class]]) {
            self.projectUuid= [dictionary objectForKey:@"project_uuid"];
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
