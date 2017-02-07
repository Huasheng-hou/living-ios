//
//  LMVoiceProjectCell.h
//  living
//
//  Created by Ding on 2016/12/13.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LMProjectBodyVO.h"

@protocol  LMVoiceProjectCellDelegate;
@interface LMVoiceProjectCell : UITableViewCell

@property (nonatomic)CGFloat conHigh;
@property (nonatomic)CGFloat dspHigh;

@property (nonatomic)CGFloat imageWidth;

@property (nonatomic)CGFloat imageHeight;

@property (nonatomic)NSInteger index;

@property (nonatomic, weak) id <LMVoiceProjectCellDelegate> delegate;

@property (nonatomic, readonly) float xScale;
@property (nonatomic, readonly) float yScale;

- (void)setXScale:(float)xScale yScale:(float)yScale;

-(void)setValue:(LMProjectBodyVO *)data;

+ (CGFloat)cellHigth:(NSString *)titleString;

@end


@protocol LMVoiceProjectCellDelegate <NSObject>

@optional

- (void)cellProjectImage:(LMVoiceProjectCell *)cell;

@end
