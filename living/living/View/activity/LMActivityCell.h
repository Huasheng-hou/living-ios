//
//  LMActivityCell.h
//  living
//
//  Created by Ding on 16/9/26.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActivityListVO.h"

@protocol LMactivityCellDelegate;

@interface LMActivityCell : UITableViewCell

@property (nonatomic, readonly) float xScale;
@property (nonatomic, readonly) float yScale;
@property (nonatomic, retain)   ActivityListVO  *ActivityList;
@property (nonatomic, weak) id <LMactivityCellDelegate> delegate;
@property (nonatomic)   NSInteger  index;

-(void)setActivityList:(ActivityListVO *)vo index:(NSInteger)index;

- (void)setXScale:(float)xScale yScale:(float)yScale;

@end

@protocol LMactivityCellDelegate <NSObject>

@optional
- (void)cellWillClick:(LMActivityCell *)cell;

@end
