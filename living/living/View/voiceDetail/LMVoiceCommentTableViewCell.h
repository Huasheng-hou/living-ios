//
//  LMVoiceCommentTableViewCell.h
//  living
//
//  Created by Ding on 2016/12/14.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"
#import "LMCommentButton.h"
#import "LMEventCommentVO.h"
@protocol  LMVoiceCommentTableViewCellDelegate;
@interface LMVoiceCommentTableViewCell : UITableViewCell


@property (nonatomic, strong)NSString *event_uuid;

@property (nonatomic, strong)NSString *commentUUid;


@property (nonatomic) NSInteger count;
@property (nonatomic)CGFloat conHigh;

@property (nonatomic, strong)LMCommentButton *zanButton;
@property (nonatomic, strong)LMCommentButton *replyButton;

@property (nonatomic, weak) id <LMVoiceCommentTableViewCellDelegate> delegate;


@property (nonatomic, readonly) float xScale;
@property (nonatomic, readonly) float yScale;

- (void)setXScale:(float)xScale yScale:(float)yScale;
-(void)setValue:(LMEventCommentVO *)data;

+ (CGFloat)cellHigth:(NSString *)titleString;

@end

@protocol LMVoiceCommentTableViewCellDelegate <NSObject>

@optional
- (void)cellWillComment:(LMVoiceCommentTableViewCell *)cell;
- (void)cellWillReply:(LMVoiceCommentTableViewCell *)cell;


@end
