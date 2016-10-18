//
//  LMRechargeCell.m
//  living
//
//  Created by Ding on 16/10/18.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "LMRechargeCell.h"
#import "FitConsts.h"

@implementation LMRechargeCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubviews];
    }
    return self;
}

- (void)addSubviews
{
    //图片
    _payImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 12.5, 30, 30)];
    [self addSubview:_payImg];
    //文字
    _payLabel = [[UILabel alloc] initWithFrame:CGRectMake(45, 0, 80, 55)];
    _payLabel.font = TEXT_FONT_LEVEL_2;
    _payLabel.textColor = TEXT_COLOR_LEVEL_2;
    [self addSubview:_payLabel];
    //按钮
    _payButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _payButton.frame = CGRectMake(kScreenWidth-60, 5, 45, 45);
    [_payButton setImage:[UIImage imageNamed:@"radio_unchecked"] forState:UIControlStateNormal];
    [_payButton setImage:[UIImage imageNamed:@"radio_checked"] forState:UIControlStateSelected];
    [self addSubview:_payButton];
}

@end
