//
//  LMCouponCell.h
//  living
//
//  Created by JamHonyZ on 2016/11/2.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LMCouponVO.h"

@interface LMCouponCell : UITableViewCell

@property(nonatomic,strong)UILabel *nameLabel;

@property(nonatomic,strong)UITextView *contentLabel;

@property(nonatomic,strong)UILabel *priceLabel;

@property(nonatomic,strong)UIImageView *imageV;

@property(nonatomic,strong)UILabel *typeLabel;

@property (nonatomic, assign) NSInteger type;

-(void)setValue:(LMCouponVO *)list;

- (void)setData:(NSDictionary *)dict;


@end
