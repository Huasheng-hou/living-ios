//
//  LMPublicEventRequest.m
//  living
//
//  Created by Ding on 16/10/14.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "LMPublicEventRequest.h"

@implementation LMPublicEventRequest

-(id)initWithevent_name:(NSString *)event_name
          Contact_phone:(NSString *)contact_phone
           Contact_name:(NSString *)contact_name
               Per_cost:(NSString *)per_cost
               Discount:(NSString *)discount
             Start_time:(NSString *)start_time
               End_time:(NSString *)end_time
                Address:(NSString *)address
         Address_detail:(NSString *)address_detail
              Event_img:(NSString *)event_img
             Event_type:(NSString *)event_type
            andLatitude:(NSString *)latitude
           andLongitude:(NSString *)longitude
           limit_number:(int)limit_number
                notices:(NSString *)notices
franchiseePrice:(NSString *)franchiseePrice
              available:(NSString *)available

{
    self = [super init];
    
    if (self){
        
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
        if (start_time){
            [bodyDict setObject:start_time forKey:@"start_time"];
        }
        if (end_time){
            [bodyDict setObject:end_time forKey:@"end_time"];
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
        if (event_type){
            [bodyDict setObject:event_type forKey:@"event_type"];
        }
        if (latitude){
            [bodyDict setObject:latitude forKey:@"latitude"];
        }
        if (longitude){
            [bodyDict setObject:longitude forKey:@"longitude"];
        }
        
        if (limit_number!=-1){
            [bodyDict setObject:[NSString stringWithFormat:@"%d", limit_number] forKey:@"limit_number"];
        }
        
        if (notices){
            [bodyDict setObject:notices forKey:@"notices"];
        }
        
        if (franchiseePrice){
            [bodyDict setObject:franchiseePrice forKey:@"franchiseePrice"];
        }
        if (available){
            [bodyDict setObject:available forKey:@"available"];
        }

        
        NSMutableDictionary *paramsDict = [self params];
        [paramsDict setObject:bodyDict forKey:@"body"];
    }
    return self;
}

- (BOOL)isPost
{
    return YES;
}

- (NSString *)methodPath
{
    return @"event/publish";
}

@end
