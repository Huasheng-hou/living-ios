//
//  FirPersonVO.m
//  firefly
//
//  Created by Ding on 16/7/4.
//  Copyright © 2016年 Huasheng. All rights reserved.
//


#import "FirPersonVO.h"
#import "UserInfoVO.h"

@implementation FirPersonVO

//- (FirPersonVO *)initWithDic:(NSDictionary *)dic
//{
//    self = [super init];
//    if (self) {
//
//        if (dic[@"roleName"] && [dic[@"roleName"] isKindOfClass:[NSString class]]) {
//            NSArray *postArr =dic[@"roleName"];
//            for (NSString *str in postArr) {
//                self.roleName = str;
//            }
//        }
//        
//        if (dic[@"departmentName"] && [dic[@"departmentName"] isKindOfClass:[NSString class]]) {
//            NSArray *postArr =dic[@"departmentName"];
//            for (NSString *str in postArr) {
//                self.departmentName = str;
//            }
//        }
//        
//        if (dic[@"status"] && ![[dic objectForKey:@"status"] isEqual:[NSNull null]] && [dic[@"status"] isKindOfClass:[NSString class]]) {
//            self.status = dic[@"status"];
//        }
//        
//        if (dic[@"joinDatetime"] && [dic[@"joinDatetime"] isKindOfClass:[NSString class]]) {
//            self.joinDatetime = [NSString stringWithFormat:@"%@", dic[@"joinDatetime"]];
//        }
//        
//        if (dic[@"avatarUrl"] && [dic[@"avatarUrl"] isKindOfClass:[NSString class]]) {
//            self.avatarUrl = [NSString stringWithFormat:@"%@", dic[@"avatarUrl"]];
//        }
//        
//        if (dic[@"name"] && [dic[@"name"] isKindOfClass:[NSString class]]) {
//            self.name = [NSString stringWithFormat:@"%@", dic[@"name"]];
//        }
//        if (dic[@"homePhone"] && ![[dic objectForKey:@"homePhone"] isEqual:[NSNull null]] && [dic[@"homePhone"] isKindOfClass:[NSString class]]) {
//            self.homePhone = dic[@"homePhone"];
//        }
//        if (dic[@"phone"] && ![[dic objectForKey:@"phone"] isEqual:[NSNull null]] && [dic[@"phone"] isKindOfClass:[NSString class]]) {
//            self.phone = dic[@"phone"];
//        }
//        if (dic[@"status"] && ![[dic objectForKey:@"status"] isEqual:[NSNull null]] && [dic[@"status"] isKindOfClass:[NSString class]]) {
//            self.status = dic[@"status"];
//        }
//        
//        if (dic[@"award"] && [dic[@"award"] isKindOfClass:[NSArray class]]) {
//            self.awardArr = dic[@"award"];
//        }
//        
//    }
//    return self;
//}

@end