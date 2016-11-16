//
//  LMMemberViewCell.h
//  living
//
//  Created by Ding on 2016/11/12.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LMMemberVO.h"

@interface LMMemberViewCell : UITableViewCell

@property (nonatomic, strong)UIImageView *headImage;

@property (nonatomic, strong)UILabel *IDLabel;

@property (nonatomic, strong)UILabel *nameLabel;

@property (nonatomic, strong)UILabel *priceLabel;

@property (nonatomic, strong)UILabel *numLabel;

@property (nonatomic, strong)UILabel *timeLabel;

@property (nonatomic, strong)UILabel *coupondLabel;

-(void)setData:(LMMemberVO *)list;

@end
