//
//  LMWriteReviewRequest.h
//  living
//
//  Created by hxm on 2017/3/22.
//  Copyright © 2017年 chenle. All rights reserved.
//

#import "FitBaseRequest.h"

@interface LMWriteReviewRequest : FitBaseRequest

- (id)initWithEventUuid:(NSString *)eventUuid
        andEventContent:(NSString *)eventContent
           andEventImgs:(NSArray *)eventImgs
               andBlend:(NSArray *)blend
            andDescribe:(NSString *)describe
               andTitle:(NSString *)title
            andCategory:(NSString *)category;

@end
