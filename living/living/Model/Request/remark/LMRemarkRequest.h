//
//  LMRemarkRequest.h
//  living
//
//  Created by hxm on 2017/5/4.
//  Copyright © 2017年 chenle. All rights reserved.
//

#import "FitBaseRequest.h"

@interface LMRemarkRequest : FitBaseRequest

- (instancetype)initWithFriendUuid:(NSString *)friendUuid andRemark:(NSString *)remark;


@end
