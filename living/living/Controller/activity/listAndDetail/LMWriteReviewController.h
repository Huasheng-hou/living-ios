//
//  LMWriteReviewController.h
//  living
//
//  Created by hxm on 2017/3/22.
//  Copyright © 2017年 chenle. All rights reserved.
//

#import "LMPublicArticleController.h"

@interface LMWriteReviewController : FitTableViewController

@property (nonatomic, copy) NSString * eventUuid;

@property (nonatomic, copy) NSString * eventName;

@property (nonatomic, strong) NSDictionary *draftDic;

@end
