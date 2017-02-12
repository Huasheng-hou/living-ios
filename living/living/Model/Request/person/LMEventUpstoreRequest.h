//
//  LMEventUpstoreRequest.h
//  living
//
//  Created by Ding on 2017/2/12.
//  Copyright © 2017年 chenle. All rights reserved.
//

#import "FitBaseRequest.h"

@interface LMEventUpstoreRequest : FitBaseRequest

- (id)initWithevent_uuid:(NSString *)event_uuid
         andstart_time:(NSString *)start_time
         andend_time:(NSString *)end_time;

@end
