//
//  LMCouponCell.m
//  living
//
//  Created by JamHonyZ on 2016/11/2.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "LMCouponCell.h"
#import "FitConsts.h"
#import "UIImageView+WebCache.h"
@implementation LMCouponCell
{
    UIImageView * rightImage;
}
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
    for (UIView * sub in self.subviews) {
        [sub removeFromSuperview];
    }
    
    //背景图片
    _imageV=[[UIImageView alloc]initWithFrame:CGRectMake(10, 5, kScreenWidth-20, 90)];
    [_imageV setImage:[UIImage imageNamed:@"CouponOR"]];
    [self addSubview:_imageV];
    
    
//    名字
    _nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(15, 10, _imageV.bounds.size.width*2/3-30, 30)];
    [_nameLabel setText:@"这是生活馆名字"];
    [_nameLabel setTextColor:[UIColor whiteColor]];
    [_nameLabel setFont:TEXT_FONT_LEVEL_1];
    [_imageV addSubview:_nameLabel];
    
    //内容
    _contentLabel=[[UITextView alloc]initWithFrame:CGRectMake(10, 40, _imageV.bounds.size.width*2/3-20, 35)];
    [_contentLabel setBackgroundColor:[UIColor clearColor]];
    [_contentLabel setFont:TEXT_FONT_LEVEL_2];
    [_contentLabel setTextColor:[UIColor colorWithWhite:1 alpha:0.9]];
    [_contentLabel setUserInteractionEnabled:NO];
    [_imageV addSubview:_contentLabel];

    //价格
    _priceLabel=[[UILabel alloc]initWithFrame:CGRectMake(_imageV.bounds.size.width*2/3, 5, _imageV.bounds.size.width/3, 80)];
    [_priceLabel setText:@"抵￥30"];
    [_priceLabel setTextColor:[UIColor redColor]];
    [_priceLabel setTextAlignment:NSTextAlignmentCenter];
    [_priceLabel setFont:[UIFont systemFontOfSize:20]];
    [_imageV addSubview:_priceLabel];
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:_priceLabel.text];
    [str addAttribute:NSFontAttributeName value:TEXT_FONT_LEVEL_2 range:NSMakeRange(0, 1)];
    _priceLabel.attributedText = str;
    
    //使用条件
    _typeLabel=[[UILabel alloc]initWithFrame:CGRectMake(_imageV.bounds.size.width*2/3, 60, _imageV.bounds.size.width/3, 20)];
    [_typeLabel setText:@"无限制"];
    [_typeLabel setTextColor:[UIColor redColor]];
    [_typeLabel setTextAlignment:NSTextAlignmentCenter];
    [_typeLabel setFont:[UIFont systemFontOfSize:12]];
    [_imageV addSubview:_typeLabel];
}


-(void)setValue:(LMCouponVO *)list
{
    _nameLabel.text = list.livingName;
    
    NSDateFormatter *formatter  = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"yyyy-MM-dd"];
    if (list.endTime && [list.endTime isKindOfClass:[NSDate class]]) {
        
        NSString *string = [formatter stringFromDate:list.endTime];
        _contentLabel.text = [NSString stringWithFormat:@"到期时间：%@",string];
    };
    
    if ([list.amount isEqual:@"188"]) {
        [_imageV setImage:[UIImage imageNamed:@"CouponOR"]];
    }
    
    if ([list.amount isEqual:@"388"]) {
        [_imageV setImage:[UIImage imageNamed:@"CouponRed1"]];
    }
    if ([list.amount isEqual:@"888"]) {
        [_imageV setImage:[UIImage imageNamed:@"CouponRed2"]];
    }
    if ([list.amount isEqual:@"30"]) {
        [_imageV setImage:[UIImage imageNamed:@"CouponBule"]];
    }

    _priceLabel.text =[NSString stringWithFormat:@"抵%@",list.amount];
    
}

- (void)setData:(NSDictionary *)dict{
    
    
    [_nameLabel removeFromSuperview];
    //if ([dict[@"type"] isEqualToString:@"gift"]) {
    if (_type == 1) {
        
        //商品
        _imageV.image = [UIImage imageNamed:@"CouponBule"];
        
        _contentLabel.text = dict[@"content"];
        _contentLabel.frame = CGRectMake(10, 25, _imageV.bounds.size.width*2/3-20, 35);
        _contentLabel.text = @"这里是商品描述";
        
        rightImage = [[UIImageView alloc] initWithFrame:CGRectMake(_imageV.bounds.size.width*2/3, 0, _imageV.bounds.size.width/3, _imageV.bounds.size.height)];
        rightImage.backgroundColor = BG_GRAY_COLOR;
        [rightImage sd_setImageWithURL:[NSURL URLWithString:dict[@"image"]]];
        [_imageV addSubview:rightImage];
        
        
        
    }
    
    if (_type == 2) {
    //if ([dict[@"type"] isEqualToString:@"coupon"]) {
        
        
        
        //礼包
        _imageV.image = [UIImage imageNamed:@"CouponRed2"];
        
        [rightImage removeFromSuperview];
        
//        _contentLabel.text = dict[@"title"];
        _contentLabel.text = @"";
        _contentLabel.frame = CGRectMake(10, 25, _imageV.bounds.size.width*2/3-20, 35);
        _contentLabel.text = @"这里是优惠券描述";
        
        _priceLabel.text = [NSString stringWithFormat:@"抵 %@", dict[@"amount"]];
        
    }
    
    
}

@end
