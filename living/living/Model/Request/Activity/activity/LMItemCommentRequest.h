//
//  LMItemCommentRequest.h
//  living
//
//  Created by hxm on 2017/3/29.
//  Copyright © 2017年 chenle. All rights reserved.
//

#import "FitBaseRequest.h"

@interface LMItemCommentRequest : FitBaseRequest
- (id)initWithEventUuid:(NSString *)eventUuid andContent:(NSString *)commentContent andStar:(NSString *)star andPhotos:(NSArray *)photos;

@end
