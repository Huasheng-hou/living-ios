//
//  LMCouponCell.m
//  living
//
//  Created by JamHonyZ on 2016/11/2.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "LMCouponCell.h"
#import "FitConsts.h"

@implementation LMCouponCell

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
    //背景图片
    UIImageView *imageV=[[UIImageView alloc]initWithFrame:CGRectMake(10, 5, kScreenWidth-20, 90)];
    [imageV setImage:[UIImage imageNamed:@"personCouponBg"]];
    [self addSubview:imageV];
    
//    名字
    _nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(15, 10, imageV.bounds.size.width*2/3-30, 30)];
    [_nameLabel setText:@"这是生活馆名字"];
    [_nameLabel setTextColor:[UIColor whiteColor]];
    [_nameLabel setFont:TEXT_FONT_LEVEL_1];
    [imageV addSubview:_nameLabel];
    
    //内容
    _contentLabel=[[UITextView alloc]initWithFrame:CGRectMake(10, 35, imageV.bounds.size.width*2/3-20, 40)];
    [_contentLabel setText:@"这是活动这是活动这是活动这是活动这是活动这是活动这是活动这是活动这是活动这是活动这是活动这是活动这是活动这是活动这是活动这是活动这是活动这是活动"];
    [_contentLabel setBackgroundColor:[UIColor clearColor]];
    [_contentLabel setFont:TEXT_FONT_LEVEL_2];
    [_contentLabel setUserInteractionEnabled:NO];
    [imageV addSubview:_contentLabel];
    
    //段落间隔
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:_contentLabel.text];;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    [paragraphStyle setLineSpacing:5];
    
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, _contentLabel.text.length)];
    _contentLabel.attributedText = attributedString;
    
     [_contentLabel setTextColor:[UIColor whiteColor]];

    //价格
    _priceLabel=[[UILabel alloc]initWithFrame:CGRectMake(imageV.bounds.size.width*2/3, 5, imageV.bounds.size.width/3, 80)];
    [_priceLabel setText:@"抵￥30"];
    [_priceLabel setTextColor:[UIColor redColor]];
    [_priceLabel setTextAlignment:NSTextAlignmentCenter];
    [_priceLabel setFont:[UIFont systemFontOfSize:20]];
    [imageV addSubview:_priceLabel];
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:_priceLabel.text];
    [str addAttribute:NSFontAttributeName value:TEXT_FONT_LEVEL_2 range:NSMakeRange(0, 1)];
    _priceLabel.attributedText = str;
}

@end
