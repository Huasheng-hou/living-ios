//
//  LMPublicVoiceRequest.m
//  living
//
//  Created by Ding on 2016/12/14.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "LMPublicVoiceRequest.h"

@implementation LMPublicVoiceRequest

-(id)initWithvoice_title:(NSString *)voice_title
           Contact_phone:(NSString *)contact_phone
            Contact_name:(NSString *)contact_name
                Per_cost:(NSString *)per_cost
                Discount:(NSString *)discount
              Start_time:(NSString *)start_time
                End_time:(NSString *)end_time
                   image:(NSString *)image
                    host:(NSString *)host
            limit_number:(int)limit_number
                 notices:(NSString *)notices
         franchiseePrice:(NSString *)franchiseePrice
               available:(NSString *)available
{
    self = [super init];
    
    if (self){
        
        NSMutableDictionary *bodyDict   = [NSMutableDictionary new];
        
        if (voice_title){
            [bodyDict setObject:voice_title forKey:@"voice_title"];
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
        if (image){
            [bodyDict setObject:image forKey:@"image"];
        }
        if (limit_number!=-1){
            [bodyDict setObject:[NSString stringWithFormat:@"%d", limit_number] forKey:@"limit_number"];
        }
        if (host){
            [bodyDict setObject: host forKey:@"host"];
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
    return @"voice/publish";
}

@end
