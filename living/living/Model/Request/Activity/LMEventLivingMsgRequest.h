//
//  LMEventLivingMsgRequest.h
//  living
//
//  Created by Ding on 16/10/14.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "FitBaseRequest.h"

@interface LMEventLivingMsgRequest : FitBaseRequest

-(id)initWithEvent_uuid:(NSString *)event_uuid Commentcontent:(NSString *)comment_content;

@end
