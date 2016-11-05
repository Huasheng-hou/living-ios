//
//  LMCommentCell.h
//  living
//
//  Created by Ding on 16/9/28.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LMCommentButton.h"
#import "LMAriticleCommentMessages.h"
#import "UIImageView+WebCache.h"

@protocol  LMCommentCellDelegate;

@interface LMCommentCell : UITableViewCell

@property (nonatomic, strong)NSString *article_uuid;

@property (nonatomic, strong)NSString *commentUUid;

@property (nonatomic) NSInteger count;
@property (nonatomic)CGFloat conHigh;

@property (nonatomic, strong)LMCommentButton *zanButton;
@property (nonatomic, strong)LMCommentButton *replyButton;

@property (nonatomic, weak) id <LMCommentCellDelegate> delegate;


@property (nonatomic, readonly) float xScale;
@property (nonatomic, readonly) float yScale;

- (void)setXScale:(float)xScale yScale:(float)yScale;
-(void)setValue:(LMAriticleCommentMessages *)data;

+ (CGFloat)cellHigth:(NSString *)titleString;

@end

@protocol LMCommentCellDelegate <NSObject>

@optional
- (void)cellWillComment:(LMCommentCell *)cell;

-(void)cellWillReply:(LMCommentCell *)cell;

@end







