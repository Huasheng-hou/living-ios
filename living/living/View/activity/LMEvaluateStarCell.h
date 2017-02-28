//
//  LMEvaluateStarCell.h
//  living
//
//  Created by WangShengquan on 2017/2/24.
//  Copyright © 2017年 chenle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditImageView.h"

@class LMEvaluateStarCell;

@protocol LMEvaluateStarCellDelegate <NSObject>

@optional
- (void)cellWilladdImage:(LMEvaluateStarCell *)cell;

@end


@interface LMEvaluateStarCell : UITableViewCell

@property (nonatomic, strong)EditImageView *imageV;
@property (nonatomic, weak) id<LMEvaluateStarCellDelegate> delegate;
@property(nonatomic,strong)NSMutableArray *array;


@end
