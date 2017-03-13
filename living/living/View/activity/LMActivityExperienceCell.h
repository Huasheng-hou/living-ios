//
//  LMActivityExperienceCell.h
//  living
//
//  Created by WangShengquan on 2017/2/22.
//  Copyright © 2017年 chenle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LMEventListVO.h"
@protocol doSomethingForActivityDelegate <NSObject>
/**
 点赞
 */
- (void)like;

/**
 分享
 */
- (void)share;

/**
 评论
 */
- (void)comment;

/**
 评分
 */
- (void)grade;

@end

@interface LMActivityExperienceCell : UITableViewCell

@property (nonatomic, weak) id<doSomethingForActivityDelegate> delegate;

- (void)setVO:(LMEventListVO *)list;

@end
