//
//  LMPublicEventRequest.h
//  living
//
//  Created by Ding on 16/10/14.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "FitBaseRequest.h"

@interface LMPublicEventRequest : FitBaseRequest

-(id)initWithevent_name:(NSString *)event_name
            Contact_phone:(NSString *)contact_phone
             Contact_name:(NSString *)contact_name
                 Per_cost:(NSString *)per_cost
               Start_time:(NSString *)start_time
                 End_time:(NSString *)end_time
                  Address:(NSString *)address
           Address_detail:(NSString *)address_detail
                Event_img:(NSString *)event_img;

@end