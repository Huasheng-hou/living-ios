//
//  LMCloseQuestionRequest.h
//  living
//
//  Created by Ding on 2017/1/3.
//  Copyright © 2017年 chenle. All rights reserved.
//

#import "FitBaseRequest.h"

@interface LMCloseQuestionRequest : FitBaseRequest

-(id)initWithQuestionUuid:(NSString *)question_uuid;

@end
