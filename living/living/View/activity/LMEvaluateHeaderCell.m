//
//  LMEvaluateHeaderCell.m
//  living
//
//  Created by WangShengquan on 2017/2/24.
//  Copyright © 2017年 chenle. All rights reserved.
//

#import "LMEvaluateHeaderCell.h"
#import "FitConsts.h"

@interface LMEvaluateHeaderCell ()

@property (nonatomic, strong) UIImageView *mainImgView;
@property (nonatomic, strong) UILabel *titleLbl;
@property (nonatomic, strong) UILabel *detailLbl;
@property (nonatomic, strong) UIImageView *iconImgView;
@property (nonatomic, strong) UILabel *nameLbl;


@end

@implementation LMEvaluateHeaderCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initLayout];
    }
    return self;
}

- (void)initLayout
{
    _mainImgView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 14, kScreenWidth * 0.36 - 33.6, kScreenWidth * 0.3 - 28)];
    _mainImgView.backgroundColor = BG_GRAY_COLOR;
    [self.contentView addSubview:_mainImgView];
    
    _titleLbl = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth * 0.36 - 13.6, 15, kScreenWidth *0.64 + 3.6, 16)];
    _titleLbl.text = @"比较大的大提琴课体验课";
    _titleLbl.font = TEXT_FONT_LEVEL_2;
    _titleLbl.textColor = TEXT_COLOR_LEVEL_1;
    [self.contentView addSubview:_titleLbl];
    
    _detailLbl = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth * 0.36 - 13.6, 33, kScreenWidth *0.64 + 3.6, kScreenWidth * 0.3 - 60)];
    _detailLbl.text = @"新年新计划，是时候开展一个属于你的音乐之旅，年后让你周围的小伙伴眼前一亮哦";
    _detailLbl.numberOfLines = 0;
    _detailLbl.font = TEXT_FONT_LEVEL_3;
    _detailLbl.textColor = TEXT_COLOR_LEVEL_2;
    [self.contentView addSubview:_detailLbl];
    
    _iconImgView = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth * 0.36 - 13.6, kScreenWidth * 0.3 - 30, 16, 16)];
    _iconImgView.backgroundColor = BG_GRAY_COLOR;
    _iconImgView.layer.cornerRadius = 8;
    _iconImgView.layer.borderWidth = 0.5;
    _iconImgView.layer.borderColor = TEXT_COLOR_LEVEL_3.CGColor;
    [self.contentView addSubview:_iconImgView];
    
    _nameLbl = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth * 0.36 + 6.4 , kScreenWidth * 0.3 - 30, kScreenWidth *0.64 + 22, 16)];
    _nameLbl.text = @"下女侠";
    _nameLbl.font = TEXT_FONT_LEVEL_3;
    _nameLbl.textColor = TEXT_COLOR_LEVEL_4;
    [self.contentView addSubview:_nameLbl];
    
}


- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
