//
//  LMLeavemessagecell.h
//  living
//
//  Created by Ding on 16/10/14.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"
#import "LMCommentButton.h"
#import "LMEventCommentVO.h"
@protocol  LMLeavemessagecellDelegate;
@interface LMLeavemessagecell : UITableViewCell


@property (nonatomic, strong)NSString *event_uuid;

@property (nonatomic, strong)NSString *commentUUid;


@property (nonatomic) NSInteger count;
@property (nonatomic)CGFloat conHigh;

@property (nonatomic, strong)LMCommentButton *zanButton;
@property (nonatomic, strong)LMCommentButton *replyButton;

@property (nonatomic, weak) id <LMLeavemessagecellDelegate> delegate;


@property (nonatomic, readonly) float xScale;
@property (nonatomic, readonly) float yScale;

- (void)setXScale:(float)xScale yScale:(float)yScale;
-(void)setValue:(LMEventCommentVO *)data;

+ (CGFloat)cellHigth:(NSString *)titleString;

@end

@protocol LMLeavemessagecellDelegate <NSObject>

@optional
- (void)cellWillComment:(LMLeavemessagecell *)cell;
- (void)cellWillReply:(LMLeavemessagecell *)cell;


@end
