//
//  LMActivityDetailRequest.h
//  living
//
//  Created by Ding on 16/10/13.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "FitBaseRequest.h"

@interface LMActivityDetailRequest : FitBaseRequest

@property (nonatomic, assign) int type;


-(id)initWithEvent_uuid:(NSString *)event_uuid;

@end
