//
//  LMOrderCell.h
//  living
//
//  Created by Ding on 16/10/10.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LMOrderVO.h"

@protocol LMOrderCellDelegate;

@interface LMOrderCell : UITableViewCell

@property(nonatomic,strong)NSString *Orderuuid;

@property(nonatomic,strong)NSString *priceStr;


@property (nonatomic, weak) id <LMOrderCellDelegate> delegate;

@property (nonatomic, readonly) float xScale;
@property (nonatomic, readonly) float yScale;

- (void)setXScale:(float)xScale yScale:(float)yScale;

-(void)setValue:(LMOrderVO *)list;
@end

@protocol LMOrderCellDelegate <NSObject>

@optional
- (void)cellWilldelete:(LMOrderCell *)cell;
- (void)cellWillpay:(LMOrderCell *)cell;
- (void)cellWillfinish:(LMOrderCell *)cell;
- (void)cellWillRefund:(LMOrderCell *)cell;
- (void)cellWillrebook:(LMOrderCell *)cell;


@end
