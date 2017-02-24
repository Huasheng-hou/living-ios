//
//  LMLevavingMessageRequest.h
//  living
//
//  Created by Ding on 2017/2/24.
//  Copyright © 2017年 chenle. All rights reserved.
//

#import "FitBaseRequest.h"

@interface LMLevavingMessageRequest : FitBaseRequest

-(id)initWithuser_uuid:(NSString *)user_uuid andContent:(NSString *)content;

@end
