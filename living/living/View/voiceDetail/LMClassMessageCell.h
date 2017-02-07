//
//  LMClassMessageCell.h
//  living
//
//  Created by Ding on 2016/12/13.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LMVoiceDetailVO.h"


@protocol  LMClassMessageCellDelegate;

@interface LMClassMessageCell : UITableViewCell

@property (nonatomic, strong) UILabel *numberLabel;

@property (nonatomic, readonly) float xScale;
@property (nonatomic, readonly) float yScale;
@property (nonatomic, weak) id <LMClassMessageCellDelegate> delegate;

-(void)setValue:(LMVoiceDetailVO *)event;

- (void)setXScale:(float)xScale yScale:(float)yScale;

@end


@protocol LMClassMessageCellDelegate <NSObject>

@optional
- (void)cellWillreport:(LMClassMessageCell *)cell;


@end
