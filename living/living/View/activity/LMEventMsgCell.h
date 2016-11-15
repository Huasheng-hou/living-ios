//
//  LMEventMsgCell.h
//  living
//
//  Created by Ding on 16/10/13.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LMProjectBodyVO.h"

@protocol  LMEventMsgCellDelegate;

@interface LMEventMsgCell : UITableViewCell

@property (nonatomic)CGFloat conHigh;
@property (nonatomic)CGFloat dspHigh;

@property (nonatomic)CGFloat imageWidth;

@property (nonatomic)CGFloat imageHeight;

@property (nonatomic)NSInteger index;

@property (nonatomic, weak) id <LMEventMsgCellDelegate> delegate;

@property (nonatomic, readonly) float xScale;
@property (nonatomic, readonly) float yScale;

- (void)setXScale:(float)xScale yScale:(float)yScale;

-(void)setValue:(LMProjectBodyVO *)data;

//+ (CGFloat)cellHigth:(NSString *)titleString;

@end


@protocol LMEventMsgCellDelegate <NSObject>

@optional

- (void)cellProjectImage:(LMEventMsgCell *)cell;

@end
