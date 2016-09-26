//
//  UserInfoVO.m
//  FitTrainer
//
//  Created by Huasheng on 15/8/27.
//  Copyright (c) 2015年 Huasheng. All rights reserved.
//

#import "UserInfoVO.h"

@implementation UserInfoVO

+ (UserInfoVO *)UserInfoVOWithJSONString:(NSString *)jsonString usingEncoding:(NSStringEncoding)stringEncoding error:(NSError **)error
{
    NSData *jsonData = [jsonString dataUsingEncoding:stringEncoding];
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                   options:0
                                                                     error:error];
    
    if (nil != error && nil != jsonDictionary) {
        return [UserInfoVO UserInfoVOWithDictionary:jsonDictionary];
    }
    
    return nil;
}

+ (UserInfoVO *)UserInfoVOWithDictionary:(NSDictionary *)dictionary
{
    UserInfoVO *instance = [[UserInfoVO alloc] initWithDictionary:dictionary];
    return JSONAutoRelease(instance);
}

+ (NSArray *)UserInfoVOListWithArray:(NSArray *)array
{
    if (!array || ![array isKindOfClass:[NSArray class]]) {
        return nil;
    }
    
    NSMutableArray *resultsArray = [[NSMutableArray alloc] init];
    
    for (id entry in array) {
        if (![entry isKindOfClass:[NSDictionary class]]) {
            continue;
        }
        
        [resultsArray addObject:[UserInfoVO UserInfoVOWithDictionary:entry]];
    }
    
    return JSONAutoRelease(resultsArray);
}

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        
        if (nil != [dictionary objectForKey:@"avatar"] && ![[dictionary objectForKey:@"avatar"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"avatar"] isKindOfClass:[NSString class]]) {
            self.Avatar = [dictionary objectForKey:@"avatar"];
        }
        
        if (nil != [dictionary objectForKey:@"user_uuid"] && ![[dictionary objectForKey:@"user_uuid"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"user_uuid"] isKindOfClass:[NSString class]]) {
            self.UUID = [dictionary objectForKey:@"user_uuid"];
        }
        
        if (nil != [dictionary objectForKey:@"nickname"] && ![[dictionary objectForKey:@"nickname"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"nickname"] isKindOfClass:[NSString class]]) {
            self.Username = [dictionary objectForKey:@"nickname"];
        }
        
        if (nil != [dictionary objectForKey:@"name"] && ![[dictionary objectForKey:@"name"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"name"] isKindOfClass:[NSString class]]) {
            self.Name = [dictionary objectForKey:@"name"];
        }
        
        if (nil != [dictionary objectForKey:@"address"] && ![[dictionary objectForKey:@"address"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"address"] isKindOfClass:[NSString class]]) {
            self.Address = [dictionary objectForKey:@"address"];
        }
        
        if (nil != [dictionary objectForKey:@"firm"] && ![[dictionary objectForKey:@"firm"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"firm"] isKindOfClass:[NSString class]]) {
            self.Firm = [dictionary objectForKey:@"firm"];
        }
        
        
        if (nil != [dictionary objectForKey:@"contact"] && ![[dictionary objectForKey:@"contact"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"contact"] isKindOfClass:[NSString class]]) {
            self.Contact = [dictionary objectForKey:@"contact"];
        }
        
        if (nil != [dictionary objectForKey:@"gender"] && ![[dictionary objectForKey:@"gender"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"gender"] isKindOfClass:[NSString class]]) {
            self.Gender = [dictionary objectForKey:@"gender"];
        }
        if (nil != [dictionary objectForKey:@"staffID"] && ![[dictionary objectForKey:@"staffID"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"staffID"] isKindOfClass:[NSString class]]) {
            self.StaffID = [dictionary objectForKey:@"staffID"];
        }
        if (nil != [dictionary objectForKey:@"emp_uuid"] && ![[dictionary objectForKey:@"emp_uuid"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"emp_uuid"] isKindOfClass:[NSString class]]) {
            self.Emp_uuid = [dictionary objectForKey:@"emp_uuid"];
        }
        if (nil != [dictionary objectForKey:@"homePhone"] && ![[dictionary objectForKey:@"homePhone"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"homePhone"] isKindOfClass:[NSString class]]) {
            self.homePhone = [dictionary objectForKey:@"homePhone"];
        }
        if (nil != [dictionary objectForKey:@"phone"] && ![[dictionary objectForKey:@"phone"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"phone"] isKindOfClass:[NSString class]]) {
            self.phone = [dictionary objectForKey:@"phone"];
        }
        if (nil != [dictionary objectForKey:@"joinDateTime"] && ![[dictionary objectForKey:@"joinDateTime"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"joinDateTime"] isKindOfClass:[NSString class]]) {
            self.joinDateTime = [dictionary objectForKey:@"joinDateTime"];
        }

        if (nil != [dictionary objectForKey:@"roleName"] && ![[dictionary objectForKey:@"roleName"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"roleName"] isKindOfClass:[NSArray class]]) {
            self.roleName = [dictionary objectForKey:@"roleName"];
        }
        if (nil != [dictionary objectForKey:@"department"] && ![[dictionary objectForKey:@"department"] isEqual:[NSNull null]]
            && [[dictionary objectForKey:@"department"] isKindOfClass:[NSArray class]]) {
            self.department = [dictionary objectForKey:@"department"];
        }

       
    }
    
    return self;
}

@end
