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
        franchiseePrice:(NSString *)franchiseePrice;

@end
