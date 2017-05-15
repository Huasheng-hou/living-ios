//
//  LMClassroomCell.m
//  living
//
//  Created by Ding on 2016/12/12.
//  Copyright © 2016年 chenle. All rights reserved.
//

#import "LMClassroomCell.h"
#import "FitConsts.h"
#import "UIView+frame.h"
#import "UIImageView+WebCache.h"

@interface LMClassroomCell ()
{
    UIView *backView;
    UIImageView *headView;
    UILabel *titleLabel;
    UIImageView *headV;
    UILabel *nameLabel;
    UILabel *priceLabel;
    UILabel *timeLabel;
    UILabel *numberLabel;
}

@end

@implementation LMClassroomCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self    = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self setBackgroundColor:BG_GRAY_COLOR];
        [self addSubviews];
    }
    return self;
}

-(void)addSubviews
{
    backView = [[UIView alloc] initWithFrame:CGRectMake(15, 15, kScreenWidth-30, 120)];
    backView.backgroundColor = [UIColor whiteColor];
    backView.layer.cornerRadius = 5;
    [self addSubview:backView];
    
    headView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 15, 60, 60)];
    headView.contentMode = UIViewContentModeScaleAspectFill;
    headView.clipsToBounds = YES;
    headView.backgroundColor = BG_GRAY_COLOR;
    [backView addSubview:headView];
    
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 15, self.frame.size.width-90, 30)];
    titleLabel.textColor = TEXT_COLOR_LEVEL_2;
    titleLabel.font = TEXT_FONT_LEVEL_1;
    [backView addSubview:titleLabel];
    
    headV = [[UIImageView alloc] initWithFrame:CGRectMake(80, 50, 20, 20)];
    headV.contentMode = UIViewContentModeScaleAspectFill;
    headV.clipsToBounds = YES;
    headV.layer.cornerRadius = 10;
    headV.backgroundColor = BG_GRAY_COLOR;
    [backView addSubview:headV];
    
    priceLabel = [UILabel new];
    priceLabel.text = @"￥：999999";
    priceLabel.textColor = LIVING_REDCOLOR;
    [priceLabel sizeToFit];
    priceLabel.frame = CGRectMake(backView.frame.size.width-10-priceLabel.bounds.size.width, 45, priceLabel.bounds.size.width, 30);
    priceLabel.font = [UIFont systemFontOfSize:18];
    priceLabel.textAlignment  = NSTextAlignmentRight;
    [backView addSubview:priceLabel];
    
    nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 50, 150, 20)];
    nameLabel.textColor = TEXT_COLOR_LEVEL_2;
    nameLabel.font = TEXT_FONT_LEVEL_2;
    [backView addSubview:nameLabel];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(10, 85, backView.frame.size.width-20, 0.5)];
    lineView.backgroundColor = LINE_COLOR;
    [backView addSubview:lineView];
    
    timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 85, 150, 35)];
    timeLabel.font = TEXT_FONT_LEVEL_3;
    timeLabel.textColor = TEXT_COLOR_LEVEL_3;
    [backView addSubview:timeLabel];
    
//    numberLabel = [UILabel new];
//    numberLabel.font = TEXT_FONT_LEVEL_3;
//    numberLabel.textColor = TEXT_COLOR_LEVEL_3;
//    [backView addSubview:numberLabel];
    
    
}

-(void)setValue:(ClassroomVO *)list
{
    titleLabel.text = list.voiceTitle;
    [headView sd_setImageWithURL:[NSURL URLWithString:list.image]];
    [headV sd_setImageWithURL:[NSURL URLWithString:list.avatar]];
    nameLabel.text = [NSString stringWithFormat:@"讲师:%@",list.nickname];
    priceLabel.text = [NSString stringWithFormat:@"￥%@",list.perCost];
    NSDateFormatter     *formatter  = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm"];
    timeLabel.text = [NSString stringWithFormat:@"时间：%@", [formatter stringFromDate:list.startTime]];
//    numberLabel.text = [NSString stringWithFormat:@"学员:%d",list.currentNum];
    
    
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    [nameLabel sizeToFit];
//    [numberLabel sizeToFit];
    nameLabel.frame = CGRectMake(110, 50, backView.frame.size.width-10-priceLabel.bounds.size.width-110, 20);
//    numberLabel.frame = CGRectMake(backView.frame.size.width-10-numberLabel.bounds.size.width, 85, numberLabel.bounds.size.width, 35);
}


@end
