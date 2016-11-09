//
//  LMCouponChoseCell.m
//  living
//
//  Created by Ding on 2016/11/9.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "LMCouponChoseCell.h"
#import "FitConsts.h"

@implementation LMCouponChoseCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self    = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self addSubviews];
    }
    return self;
}

-(void)addSubviews
{
    _chooseView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 15, 20, 20)];
    //    _chooseView.image = [UIImage imageNamed:@"choose-no"];
    [self.contentView addSubview:_chooseView];
    
    _priceLabel = [UILabel new];
    _priceLabel.textColor = TEXT_COLOR_LEVEL_2;
    _priceLabel.font = TEXT_FONT_LEVEL_1;
    _priceLabel.textAlignment = NSTextAlignmentRight;
    _priceLabel.frame = CGRectMake(kScreenWidth-110, 0, 90, 50);
    [self.contentView addSubview:_priceLabel];

    _nameLabel = [UILabel new];
    _nameLabel.textColor = TEXT_COLOR_LEVEL_2;
    _nameLabel.font = TEXT_FONT_LEVEL_1;
    _nameLabel.frame = CGRectMake(40, 0, kScreenWidth-80-10, 50);
    [self.contentView addSubview:_nameLabel];
    
    
    
}

-(void)setArray:(NSMutableArray *)array index:(NSInteger)index
{
    _priceLabel.text = [NSString stringWithFormat:@"抵 ￥%@",array[index]];
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:_priceLabel.text];
    [str addAttribute:NSForegroundColorAttributeName value:TEXT_COLOR_LEVEL_2 range:NSMakeRange(0,1)];
    [str addAttribute:NSForegroundColorAttributeName value:LIVING_REDCOLOR range:NSMakeRange(1,str.length-1)];
    
    [str addAttribute:NSFontAttributeName value:TEXT_FONT_LEVEL_2 range:NSMakeRange(0,1)];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range:NSMakeRange(1,str.length-1)];
    _priceLabel.attributedText = str;

    
    
    
}

-(void)setValue:(LMCouponVO *)vo
{
    if (!vo || ![vo isKindOfClass:[LMCouponVO class]]) {
        return;
    }
    NSLog(@"%@",(NSString *)vo.amount);
    
    
    _nameLabel.text = vo.livingName;
}

@end
