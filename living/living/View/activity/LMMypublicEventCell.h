//
//  LMMypublicEventCell.h
//  living
//
//  Created by Ding on 2016/11/16.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActivityListVO.h"

@protocol LMMypublicEventCellDelegate;

@interface LMMypublicEventCell : UITableViewCell

@property(nonatomic,strong)NSString *Orderuuid;

@property(nonatomic,strong)NSString *priceStr;


@property (nonatomic, weak) id <LMMypublicEventCellDelegate> delegate;

@property (nonatomic, readonly) float xScale;
@property (nonatomic, readonly) float yScale;

- (void)setXScale:(float)xScale yScale:(float)yScale;

-(void)setActivityList:(ActivityListVO *)list;
@end

@protocol LMMypublicEventCellDelegate <NSObject>

@optional
- (void)cellWilldelete:(LMMypublicEventCell *)cell;
- (void)cellWillbegin:(LMMypublicEventCell *)cell;
- (void)cellWillfinish:(LMMypublicEventCell *)cell;
- (void)cellWillclick:(LMMypublicEventCell *)cell;


@end

