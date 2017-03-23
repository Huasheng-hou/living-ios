//
//  LMNewPublicEventRequest.h
//  living
//
//  Created by hxm on 2017/3/23.
//  Copyright © 2017年 chenle. All rights reserved.
//

#import "FitBaseRequest.h"

@interface LMNewPublicEventRequest : FitBaseRequest

-(id)initWithEvent_name:(NSString *)event_name
          Contact_phone:(NSString *)contact_phone
           Contact_name:(NSString *)contact_name
               Per_cost:(NSString *)per_cost
               Discount:(NSString *)discount
        FranchiseePrice:(NSString *)franchiseePrice
                Address:(NSString *)address
         Address_detail:(NSString *)address_detail
              Event_img:(NSString *)event_img
               Latitude:(NSString *)latitude
              Longitude:(NSString *)longitude
                notices:(NSString *)notices
              available:(NSString *)available
               Category:(NSString *)category
                   Type:(NSString *)type
                  blend:(NSArray *)blend;

@end
