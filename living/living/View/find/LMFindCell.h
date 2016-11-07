//
//  LMFindCell.h
//  living
//
//  Created by Ding on 16/9/26.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LMFindVO.h"

@protocol  LMFindCellDelegate;
@interface LMFindCell : UITableViewCell

@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) UILabel *contentLabel;
@property(nonatomic, strong) UILabel *numLabel;

@property(nonatomic,strong) UIImageView *imageview;

@property(nonatomic,strong)UIButton *praiseBt;

@property(nonatomic,strong)UIImageView *thumbIV;


@property (nonatomic, weak) id <LMFindCellDelegate> delegate;
- (void)setXScale:(float)xScale yScale:(float)yScale;
-(void)setValue:(LMFindVO *)list;

@end


@protocol LMFindCellDelegate <NSObject>

@optional
- (void)cellWillClick:(LMFindCell *)cell;

@end
