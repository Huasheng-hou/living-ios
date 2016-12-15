//
//  LMVoiceMemberRequest.h
//  living
//
//  Created by Ding on 2016/12/15.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "FitBaseRequest.h"

@interface LMVoiceMemberRequest : FitBaseRequest

-(id)initWithPageIndex:(int)pageIndex andPageSize:(int)pageSize andVoiceUuid:(NSString *)voice_uuid;

@end
