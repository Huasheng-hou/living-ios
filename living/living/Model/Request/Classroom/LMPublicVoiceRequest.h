//
//  LMPublicVoiceRequest.h
//  living
//
//  Created by Ding on 2016/12/14.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "FitBaseRequest.h"

@interface LMPublicVoiceRequest : FitBaseRequest

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
                category:(NSString *)category;

@end
