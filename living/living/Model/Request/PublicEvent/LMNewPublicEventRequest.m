//
//  LMNewPublicEventRequest.m
//  living
//
//  Created by hxm on 2017/3/23.
//  Copyright © 2017年 chenle. All rights reserved.
//

#import "LMNewPublicEventRequest.h"

@implementation LMNewPublicEventRequest

- (id)initWithEvent_name:(NSString *)event_name Contact_phone:(NSString *)contact_phone Contact_name:(NSString *)contact_name Per_cost:(NSString *)per_cost Discount:(NSString *)discount FranchiseePrice:(NSString *)franchiseePrice Address:(NSString *)address Address_detail:(NSString *)address_detail Event_img:(NSString *)event_img Latitude:(NSString *)latitude Longitude:(NSString *)longitude notices:(NSString *)notices available:(NSString *)available Category:(NSString *)category Type:(NSString *)type blend:(NSArray *)blend{
    
    
    if (self = [super init]) {
        NSMutableDictionary *bodyDict   = [NSMutableDictionary new];
        
        if (event_name){
            [bodyDict setObject:event_name forKey:@"event_name"];
        }
        if (contact_phone){
            [bodyDict setObject:contact_phone forKey:@"contact_phone"];
        }
        if (contact_name){
            [bodyDict setObject:contact_name forKey:@"contact_name"];
        }
        if (per_cost){
            [bodyDict setObject:per_cost forKey:@"per_cost"];
        }
        if (discount){
            [bodyDict setObject:discount forKey:@"discount"];
        }
        
        if (address){
            [bodyDict setObject:address forKey:@"address"];
        }
        if (address_detail){
            [bodyDict setObject:address_detail forKey:@"address_detail"];
        }
        if (event_img){
            [bodyDict setObject:event_img forKey:@"event_img"];
        }
        if (type){
            [bodyDict setObject:type forKey:@"event_type"];
        }
        if (latitude){
            [bodyDict setObject:latitude forKey:@"latitude"];
        }
        if (longitude){
            [bodyDict setObject:longitude forKey:@"longitude"];
        }
        if (notices){
            [bodyDict setObject:notices forKey:@"notices"];
        }
        
        if (franchiseePrice){
            [bodyDict setObject:franchiseePrice forKey:@"franchiseePrice"];
        }
        if (category) {
            [bodyDict setObject:category forKey:@"category"];
        }
        if (available){
            [bodyDict setObject:available forKey:@"available"];
        }
        
        
        NSMutableDictionary *paramsDict = [self params];
        [paramsDict setObject:bodyDict forKey:@"body"];
        
    }
    return self;

    
}

- (BOOL)isPost{
    
    return YES;
}

- (NSString *)methodPath{
    
    return @"item/publish";
}

@end
