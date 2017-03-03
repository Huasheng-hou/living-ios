//
//  LMEventJoinRequest.h
//  living
//
//  Created by Ding on 16/10/14.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "FitBaseRequest.h"

@interface LMEventJoinRequest : FitBaseRequest

-(id)initWithEvent_uuid:(NSString *)event_uuid
             order_nums:(NSString *)order_nums
                   name:(NSString *)name
                  phone:(NSString *)phone;

@end
