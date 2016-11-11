//
//  LMCouponChoseCell.h
//  living
//
//  Created by Ding on 2016/11/9.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LMCouponVO.h"

@interface LMCouponChoseCell : UITableViewCell

@property(nonatomic,strong)UIImageView *chooseView;

@property(nonatomic,strong)UILabel *priceLabel;

@property(nonatomic,strong)UILabel *nameLabel;



-(void)setArray:(NSMutableArray *)array index:(NSInteger)index;

-(void) setValue:(LMCouponVO *)vo;

@end
