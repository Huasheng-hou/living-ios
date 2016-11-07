//
//  LMBlanceHeadCell.h
//  living
//
//  Created by Ding on 2016/10/30.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LMBalanceBillVO.h"

#import "LMMonthDetailBill.h"

@protocol  LMBlanceHeadCellDelegate;

@interface LMBlanceHeadCell : UITableViewCell

@property(nonatomic, strong)UILabel *timeLabel;
@property (nonatomic, weak) id <LMBlanceHeadCellDelegate> delegate;


-(void)setDic:(NSDictionary *)dic;


-(void)setValue:(LMMonthDetailBill *)bill;


@end


@protocol LMBlanceHeadCellDelegate <NSObject>

@optional
- (void)cellWillclick:(LMBlanceHeadCell *)cell;

@end
